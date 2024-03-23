class MemberRolesController < ApplicationController
  before_action :set_member_role, only: %i[ show edit update destroy ]

  def index
    authorize MemberRole
    @member_roles = MemberRole.all
    if params[:query].present?
      @member_roles = @member_roles.joins(:member, :role).where("members.first_name ILIKE ? OR members.last_name ILIKE ? OR roles.name ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
    end
    @pagy, @member_roles = pagy @member_roles.reorder(sort_column => sort_direction), items: params.fetch(:count, 10)
    if params[:role].present?
      @member_roles = @member_roles.joins(:role).where(roles: { name: params[:role] })
    end
  end

  def sort_column
    %w{ member_id first_name last_name role }.include?(params[:sort]) ? params[:sort] : "member_id"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  # GET /member_roles/1 or /member_roles/1.json
  def show
    authorize MemberRole
  end

  # GET /member_roles/new
  def new
    authorize MemberRole
    @member_role = MemberRole.new
  end

  # GET /member_roles/1/edit
  def edit
    authorize MemberRole
  end

  def approve
    member_role = MemberRole.find(params[:id])
    member = member_role.member
    member_role.update(role: Role.find_by(name: 'Member'))
    MemberMailer.with(member: member).new_member_email.deliver_now
    redirect_to member_roles_path, notice: 'Account approved successfully'
  end

  def reject
    member_role = MemberRole.find(params[:id])
    member = member_role.member
    member_role.destroy
    member.destroy if member.member_roles.empty?
    redirect_to member_roles_path, notice: 'Account rejected successfully'
  end

  def approval
    @pagy, @member_roles = pagy(MemberRole.joins(:role).where(roles: { name: 'Unapproved' }))
  end

  # POST /member_roles or /member_roles.json
  def create
    authorize MemberRole
    @member_role = MemberRole.new(member_role_params)

    respond_to do |format|
      if @member_role.save
        format.html { redirect_to member_role_url(@member_role), notice: "Member role was successfully created." }
        format.json { render :show, status: :created, location: @member_role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /member_roles/1 or /member_roles/1.json
  def update
    authorize MemberRole
    respond_to do |format|
      if @member_role.update(member_role_params)
        format.html { redirect_to member_role_url(@member_role), notice: "Member role was successfully updated." }
        format.json { render :show, status: :ok, location: @member_role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_roles/1 or /member_roles/1.json
  def destroy
    authorize MemberRole
    @member_role.destroy!

    respond_to do |format|
      format.html { redirect_to member_roles_url, notice: "Member role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member_role
      @member_role = MemberRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_role_params
      params.require(:member_role).permit(:member_role_id, :member_id, :role_id)
    end
end
