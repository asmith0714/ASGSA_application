class MemberPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      if user.admin? # Assuming `admin` is a method that determines if a user is an admin
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
 
  def index?
    approved?
  end
  
  def show?
 # Information displayed by show is controlled by the view. But everyone can access. 
    approved?
  end
  
  def new?
    admin_officer?
  end

  def create?
    admin_officer? # Only admins and officers can create new members
  end

  def edit?
    admin_officer_member_info?
  end

  def update?
    admin_officer_member_info?
  end

  def destroy?
    admin_officer?
  end

  def delete_confirmation?
    admin_officer?
  end



  def admin_officer_member_info?
    user.admin? || user.officer? || record.id == user.id
  end

  def admin_officer?
    user.admin? || user.officer?
  end

  def admin?
    user.admin?
  end

  def approved?
    !user.unapproved?
  end

end
