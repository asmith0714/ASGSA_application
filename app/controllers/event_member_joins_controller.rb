class EventMemberJoinsController < ApplicationController
  before_action :set_event_member_join, only: %i[ show edit update destroy ]

  # GET /event_member_joins or /event_member_joins.json
  def index
    @event_member_joins = EventMemberJoin.all
  end

  # GET /event_member_joins/1 or /event_member_joins/1.json
  def show
  end

  # GET /event_member_joins/new
  def new
    @event_member_join = EventMemberJoin.new
  end

  # GET /event_member_joins/1/edit
  def edit
  end

  # POST /event_member_joins or /event_member_joins.json
  def create
    @event_member_join = EventMemberJoin.new(event_member_join_params)

    respond_to do |format|
      if @event_member_join.save
        format.html { redirect_to event_member_join_url(@event_member_join), notice: "Event member join was successfully created." }
        format.json { render :show, status: :created, location: @event_member_join }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_member_join.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_member_joins/1 or /event_member_joins/1.json
  def update
    respond_to do |format|
      if @event_member_join.update(event_member_join_params)
        format.html { redirect_to event_member_join_url(@event_member_join), notice: "Event member join was successfully updated." }
        format.json { render :show, status: :ok, location: @event_member_join }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_member_join.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_member_joins/1 or /event_member_joins/1.json
  def destroy
    @event_member_join.destroy!

    respond_to do |format|
      format.html { redirect_to event_member_joins_url, notice: "Event member join was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_member_join
      @event_member_join = EventMemberJoin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_member_join_params
      params.require(:event_member_join).permit(:attended, :rsvp)
    end
end
