# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :set_role, only: %i[show edit update destroy]

  # GET /roles or /roles.json
  def index
    authorize Role
    @roles = Role.all
    @roles = @roles.search(params[:query]) if params[:query].present?
    @pagy, @roles = pagy(@roles.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort_column
    %w[role_id name permissions].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # GET /roles/1 or /roles/1.json
  def show
    authorize Role
    @role = Role.find(params[:id])
  end

  # GET /roles/new
  def new
    authorize Role
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    authorize Role
    @role = Role.find(params[:id])
  end

  # POST /roles or /roles.json
  def create
    authorize Role
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        flash[:success] = 'Role was successfully created.'
        format.html { redirect_to(role_url(@role)) }
        format.json { render(:show, status: :created, location: @role) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @role.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    authorize Role
    respond_to do |format|
      if @role.update(role_params)
        flash[:success] = 'Role was successfully updated.'
        format.html { redirect_to(role_url(@role)) }
        format.json { render(:show, status: :ok, location: @role) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @role.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    authorize Role
    @role.destroy!

    respond_to do |format|
      flash[:success] = 'Role was successfully destroyed.'
      format.html { redirect_to(roles_url) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:role_id, :name, :permissions)
  end
end
