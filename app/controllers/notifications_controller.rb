# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show edit update destroy delete_confirmation]

  # GET /notifications or /notifications.json
  def index
    authorize(Notification)
    @notifications = Notification.all
    @notifications = @notifications.search(params[:query]) if params[:query].present?
    @pagy, @notifications = pagy(@notifications.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort_column
    %w[notification_id title description event].include?(params[:sort]) ? params[:sort] : 'notification_id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    authorize(Notification)
  end

  # GET /notifications/new
  def new
    authorize(Notification)
    @notification = Notification.new
    Member.count.times { @notification.member_notifications.build }
  end

  # GET /notifications/1/edit
  def edit
    authorize(Notification)
  end

  # GET /notifications/1/delete_confirmation
  def delete_confirmation
    authorize(Notification)
    # Render delete_confirmation view
  end

  # POST /notifications or /notifications.json
  def create
    authorize(Notification)
    @notification = Notification.new(notification_params)
    @members = Member.all

    respond_to do |format|
      if @notification.save
        case params[:send_email]
        when 'all'
          # Send email to all members expect those with role "Unapproved"
          member_role = Role.find_by(name: 'Member')
          officer_role = Role.find_by(name: 'Officer')
          admin_role = Role.find_by(name: 'Admin')
          members = member_role.members if member_role
          officers = officer_role.members if officer_role
          admins = admin_role.members if admin_role
          @members = members + officers + admins
          MemberMailer.notification_email(@notification, @members).deliver_now
        when 'officers'
          # Send email to officers only
          officer_role = Role.find_by(name: 'Officer')
          admin_role = Role.find_by(name: 'Admin')
          officers = officer_role.members if officer_role
          admins = admin_role.members if admin_role
          @members = officers + admins
          MemberMailer.notification_email(@notification, @members).deliver_now if @members
        when 'members'
          # Send email to members only
          member_role = Role.find_by(name: 'Member')
          @members = member_role.members if member_role
          MemberMailer.notification_email(@notification, @members).deliver_now if @members
        end

        # creates a member_notification for all members id selected
        @members.each do |mem|
          @notification.member_notifications.create!(member_id: mem.id, notification_id: @notification.id, seen: false)
        end

        flash[:success] = 'Notification was successfully created.'
        format.html { redirect_to(notifications_url) }
        format.json { render(:show, status: :created, location: @notification) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @notification.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    authorize(Notification)
    respond_to do |format|
      if @notification.update(notification_params)
        flash[:success] = 'Notification was successfully updated.'
        format.html { redirect_to(notification_url(@notification)) }
        format.json { render(:show, status: :ok, location: @notification) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @notification.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    authorize(Notification)
    @notification.destroy!

    respond_to do |format|
      flash[:success] = 'Notification was successfully destroyed.'
      format.html { redirect_to(notifications_url) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:description, :title, :date, :event_id, :attachment)
  end
end
