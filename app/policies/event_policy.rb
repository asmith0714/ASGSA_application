class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  
    def index?
      admin_officer_member_info?
    end
  
    def show?
      admin_officer_member_info?
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
  
  
    def admin_officer_member_info?
      user.admin? || user.officer? || record.id == user.id
    end
  
    def admin_officer?
      user.admin? || user.officer?
    end
  
    def admin?
      user.admin?
    end
end
