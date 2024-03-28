class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ show edit update destroy delete_confirmation]

  # GET /notifications or /notifications.json
  def index
    authorize Notification
    @notifications = Notification.all
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    authorize Notification
  end

  # GET /notifications/new
  def new
    authorize Notification
    @notification = Notification.new
    Member.count.times {@notification.member_notifications.build}
  end

  # GET /notifications/1/edit
  def edit
    authorize Notification
  end

  # GET /notifications/1/delete_confirmation
  def delete_confirmation
    authorize Notification
    # Render delete_confirmation view
  end

  # POST /notifications or /notifications.json
  def create
    authorize Notification
    @notification = Notification.new(notification_params)
    @members = Member.all

    respond_to do |format|
      if @notification.save
        case params[:send_email]
        when 'all'
          # Send email to all members
          MemberMailer.notification_email(@notification, Member.all).deliver_now
        when 'officers'
          # Send email to officers only
          officer_role = Role.find_by(name: 'Officer')
          @members = officer_role.members if officer_role
          MemberMailer.notification_email(@notification, @members).deliver_now if officers
        when 'members'
          # Send email to members only
          member_role = Role.find_by(name: 'Member')
          @members = member_role.members if member_role
          MemberMailer.notification_email(@notification, @members).deliver_now if members
      end
        
        
        # creates a member_notification for all members id selected
        @members.each do |mem|
          @notification.member_notifications.create(member_id: mem.id, notification_id: @notification.id, seen: false)
        end
        
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully created." }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    authorize Notification
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully updated." }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    authorize Notification
    @notification.destroy!

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:description, :title, :date,  :event_id)
    end    
end
