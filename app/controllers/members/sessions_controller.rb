# frozen_string_literal: true

class Members::SessionsController < Devise::SessionsController
  def new
    @events = Event.all
    super
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_member_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Member) && resource_or_scope.current_sign_in_at == resource_or_scope.last_sign_in_at
      edit_member_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end
end
