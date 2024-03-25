class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    @events = Event.all
    @events = @events.search(params[:query]) if params[:query].present?
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

  # FIX NEED TO BE SORTED BY DATE AND TIME, ONLY DATE RIGHT NOW
  def sort_column
    %w{ name date start_time end_time category capacity points }.include?(params[:sort]) ? params[:sort] : 'date'
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def delete_confirmation
    # Render delete_confirmation view
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :create, location: @event }
        if params[:send_email] == 'all'
          # Send email to all members
          MemberMailer.event_email(@event, Member.all).deliver_now
        elsif params[:send_email] == 'officers'
          # Send email to officers only
          officers = Member.where(position: 'Officer')
          MemberMailer.event_email(@event, officers).deliver_now
        elsif params[:send_email] == 'members'
          # Send email to members only
          members = Member.where(position: 'Member')
          MemberMailer.event_email(@event, members).deliver_now
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_path(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully deleted." }
      format.json { head :no_content }
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
    redirect_to events_url
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
      :archive
    )
  end

end
