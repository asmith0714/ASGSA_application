class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    authorize Event
    @events = Event.all
    @events = @events.search(params[:query]) if params[:query].present?
    @pagy, @events = pagy @events.reorder(sort_column => sort_direction), items: params.fetch(:count, 10)
  end

  def sort_column
    %w{ name date start_time end_time capacity points }.include?(params[:sort]) ? params[:sort] : "date"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  def show
    authorize Event
  end

  def new
    authorize Event
    @event = Event.new
  end

  def edit
    authorize Event
  end

  def delete_confirmation
    authorize Event
    # Render delete_confirmation view
    @event = Event.find(params[:id])
  end

  def create
    authorize Event
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :create, location: @event }
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
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize Event
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
    authorize Event
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully deleted." }
      format.json { head :no_content }
    end
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
      :description,
      :contact_info,
      :capacity,
      :points
    )
  end



end
