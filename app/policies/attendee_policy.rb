# frozen_string_literal: true

class AttendeePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    approved?
  end

  def show?
    approved?
  end

  def new?
    approved?
  end

  def create?
    approved?
  end

  def edit?
    admin_officer?
  end

  def update?
    admin_officer?
  end

  def destroy?
    approved?
  end

  def check_in?
    admin_officer?
  end

  def add_points?
    admin_officer?
  end

  def new_check_in
    admin_officer?
  end

  def admin_officer_member_info?
    user.admin? || user.officer? || record.id == user.id
  end

  def admin_officer?
    user.admin? || user.officer?
  end

  delegate :admin?, to: :user

  def authorized?
    user.admin? || user.officer? || user.member?
  end

  delegate :approved?, to: :user
end
