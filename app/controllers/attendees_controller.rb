# frozen_string_literal: true

class AttendeesController < ApplicationController
  before_action :set_attendee, only: %i[show edit update destroy delete]
  before_action :set_event, only: %i[index new edit delete check_in new_check_in]

  # GET /attendees or /attendees.json
  def index
    @members = Member.all
    @attendees = Attendee.where(event_id: params[:event_id])
    @members = @members.search(params[:query]) if params[:query].present?
    @pagy, @members = pagy(@members.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  # GET /attendees/1 or /attendees/1.json
  def show; end

  # GET /attendees/new
  def new
    @attendee = Attendee.new
    @current_time = Time.zone.now

    date = @event.date

    @event_time = @event.start_time.change(year: date.year, month: date.month, day: date.day)
  end

  # GET /attendees/1/edit
  def edit
    @member = Member.find(@attendee.member_id)

    @attendee.update!(attended: !@attendee.attended)

    redirect_to(check_in_event_attendees_path(@event, member_filter: params[:member_filter]))
  end

  # POST /attendees or /attendees.json
  def create
    @event = Event.find(attendee_params[:event_id])
    @attendee = Attendee.new(attendee_params)

    if Member.exists?(member_id: attendee_params[:member_id]) && @attendee.save
      respond_to do |format|
        if @attendee.rsvp
          flash[:success] = 'RSVP was successfully created.'
          format.html { redirect_to(event_attendees_path(@event)) }
        else
          @attendee.update!(rsvp: true)
          flash[:success] = 'Member was successfully checked in.'
          format.html { redirect_to(check_in_event_attendees_path(@event)) }
        end
        format.json { render(:show, status: :created, location: @attendee) }
      end
    end
  end

  # PATCH/PUT /attendees/1 or /attendees/1.json
  def update; end

  def delete; end

  # DELETE /attendees/1 or /attendees/1.json
  def destroy
    event_id = @attendee.event_id
    @member = Member.find(@attendee.member_id)

    @attendee.destroy!

    respond_to do |format|
      flash[:success] = 'RSVP was successfully deleted.'
      format.html { redirect_to(event_attendees_path(Event.find(event_id))) }
      format.json { head(:no_content) }
    end
  end

  def check_in
    # SEARCH FEATURE NOT WORKING PROPERLY FOR 'Attended' AND 'RSVP'
    attendees = Attendee.where(event_id: params[:event_id])
    @members = Member.all
    @members = @members.search(params[:query]) if params[:query].present?
    @pagy, @members = pagy @members.reorder(sort_column => sort_direction), items: params.fetch(:count, 10)

    case params[:member_filter]
    when "Attended"
      @members = attendees.where(attended: true).map(&:member)
    when "All Members"

    when "Non-RSVP"
      @members = @members.where.not(member_id: attendees.pluck(:member_id))
    else # Default to "RSVP"
      @members = attendees.where(rsvp: true, attended: false).map(&:member)
    end
  end

  def sort_column
    %w[member_id first_name last_name position points date_joined res_topic].include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def new_check_in
    @attendee = Attendee.new
    @member = Member.find(params[:member_id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Only allow a list of trusted parameters through.
  def attendee_params
    params.require(:attendee).permit(:attended, :rsvp, :member_id, :event_id)
  end
end
