# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    authorize(Event)
    @events = Event.all
    @events = @events.search(params[:query]) if params[:query].present?
    # if params[:query].present?
    #   if parsed_date = parse_mm_dd_yyyy(params[:query])
    #     # If the search query is a valid date in MM/DD/YYYY format
    #     @events = @events.where("date(date) = ?", parsed_date)
    #   else
    #     # If the search query is not a valid date, search in other fields
    #     @events = @events.search(params[:query])
    #   end
    # end
    @pagy, @events = pagy @events.reorder(sort_column => sort_direction), items: params.fetch(:count, 10)

    case params[:filter]
    when "Past Events"
      @events = @events.where("date < ? AND archive = ?", DateTime.now, false)
    when "Archived Events"
      @events = @events.where(archive: true)
    else # Default to "Upcoming Events"
      @events = @events.where("date >= ? AND archive = ?", DateTime.now, false)
    end
  end

  # def parse_mm_dd_yyyy(date_string)
  #   begin
  #     # Try parsing the date in MM/DD/YYYY format
  #     Date.strptime(date_string, '%m/%d/%Y')
  #   rescue ArgumentError
  #     begin
  #       # Try parsing the date with just month and day
  #       Date.strptime(date_string, '%m/%d')
  #     rescue ArgumentError
  #       begin
  #         # Try parsing the date with just day
  #         Date.strptime(date_string, '%d')
  #       rescue ArgumentError
  #         # Handle if the date string is not in any expected format
  #         nil
  #       end
  #     end
  #   end
  # end
  
  

  # FIX NEED TO BE SORTED BY DATE AND TIME, ONLY DATE RIGHT NOW
  def sort_column
    %w{ name date start_time end_time category capacity points }.include?(params[:sort]) ? params[:sort] : 'date'
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
          # Send email to all members
          MemberMailer.event_email(@event, Member.all).deliver_now
        when 'officers'
          # Send email to officers only
          officer_role = Role.find_by(name: 'Officer')
          officers = officer_role.members if officer_role
          MemberMailer.event_email(@event, officers).deliver_now if officers
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
    @event.update(archive: !@event.archive)
    redirect_back(fallback_location: events_path)
  end

  def archive_past_events
    @events = Event.where("date < ? AND archive = ?", DateTime.now, false)
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
