class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path
    else
      flash[:alert] = "Error creating event."
      render('new')
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      flash[:alert] = "Error updating event"
      render('edit')
    end
  end

  def delete
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private

  def event_params
    permitted_params = params.require(:event).permit(
      :name,
      :location,
      :date,
      :description,
      :capacity,
      :points
    )
  
    # Check and format start_time
    if params[:event][:start_hour].present? && params[:event][:start_minute].present? && params[:event][:start_am_pm].present?
      start_hour = params[:event][:start_hour].to_i
      start_minute = params[:event][:start_minute].to_i
      start_am_pm = params[:event][:start_am_pm]
      
      if start_hour == 0
        permitted_params[:start_time] = nil
      else
        permitted_params[:start_time] = "#{start_hour}:#{start_minute.to_s.rjust(2, '0')} #{start_am_pm}"
      end
    end
  
    # Check and format end_time
    if params[:event][:end_hour].present? && params[:event][:end_minute].present? && params[:event][:end_am_pm].present?
      end_hour = params[:event][:end_hour].to_i
      end_minute = params[:event][:end_minute].to_i
      end_am_pm = params[:event][:end_am_pm]
      
      if end_hour == 0
        permitted_params[:end_time] = nil
      else
        permitted_params[:end_time] = "#{end_hour}:#{end_minute.to_s.rjust(2, '0')} #{end_am_pm}"
      end
    end
  
    permitted_params
  end
  
  

end
