# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  # class Scope < Scope
  # NOTE: Be explicit about which records you allow access to!
  # def resolve
  #   scope.all
  # end
  #   def resolve
  #     if user.admin?
  #       scope.all
  #     else
  #       scope.where(id: user.id)
  #     end
  #   end
  # end

  def index?
    admin_officer?
  end

  def show?
    admin_officer?
  end

  def new?
    admin_officer?
  end

  def create?
    admin_officer?
  end

  def edit?
    admin_officer?
  end

  def update?
    admin_officer?
  end

  def destroy?
    admin_officer?
  end

  def delete_confirmation?
    admin_officer?
  end

  def admin_officer?
    user.admin? || user.officer?
  end
end
