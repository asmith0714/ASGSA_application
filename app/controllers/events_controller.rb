# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    authorize(Event)
    @events = Event.all
    @events = @events.search(params[:query]) if params[:query].present?
    

    @events = case params[:filter]
              when 'Past Events'
                @events.where('date < ? AND archive = ?', DateTime.now, false)
              when 'Archived Events'
                @events.where(archive: true)
              else # Default to "Upcoming Events"
                @events.where('date >= ? AND archive = ?', DateTime.now, false)
              end
              
    @pagy, @events = pagy(@events.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort_column
    %w[name date start_time end_time category capacity points].include?(params[:sort]) ? params[:sort] : 'date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def show
    authorize(Event)
  end

  def new
    authorize(Event)
    @event = Event.new
  end

  def edit
    authorize(Event)
  end

  def delete_confirmation
    authorize(Event)
    # Render delete_confirmation view
    @event = Event.find(params[:id])
  end

  def create
    authorize(Event)
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        flash[:success] = 'Event was successfully created.'
        format.html { redirect_to(event_path(@event)) }
        format.json { render(:show, status: :create, location: @event) }
        case params[:send_email]
        when 'all'
          # Send email to all members expect those with role "Unapproved"
          member_role = Role.find_by(name: 'Member')
          officer_role = Role.find_by(name: 'Officer')
          admin_role = Role.find_by(name: 'Admin')
          members = member_role.members if member_role
          officers = officer_role.members if officer_role
          admins = admin_role.members if admin_role
          approved_members = members + officers + admins
          MemberMailer.event_email(@event, approved_members).deliver_now
        when 'officers'
          # Send email to officers only
          officer_role = Role.find_by(name: 'Officer')
          admin_role = Role.find_by(name: 'Admin')
          officers = officer_role.members if officer_role
          admins = admin_role.members if admin_role
          approved_members = officers + admins
          MemberMailer.event_email(@event, approved_members).deliver_now if officers || admins
        when 'members'
          # Send email to members only
          member_role = Role.find_by(name: 'Member')
          members = member_role.members if member_role
          MemberMailer.event_email(@event, members).deliver_now if members
        end
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  def update
    authorize(Event)
    respond_to do |format|
      if @event.update(event_params)
        flash[:success] = 'Event was successfully updated.'
        format.html { redirect_to(event_path(@event)) }
        format.json { render(:show, status: :ok, location: @event) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    authorize(Event)
    @event.destroy!

    respond_to do |format|
      flash[:success] = 'Event was successfully deleted.'
      format.html { redirect_to(events_url) }
      format.json { head(:no_content) }
    end
  end

  def toggle_archive
    @event = Event.find(params[:id])
    @event.update!(archive: !@event.archive)
    redirect_back(fallback_location: events_path)
  end

  def archive_past_events
    @events = Event.where('date < ? AND archive = ?', DateTime.now, false)
    @events.update_all(archive: true)
    redirect_back(fallback_location: events_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :name,
      :location,
      :start_time,
      :end_time,
      :date,
      :contact_info,
      :category,
      :description,
      :capacity,
      :points,
      :archive,
      :attachment
    )
  end
end
