class ApplicationController < ActionController::Base
    include Pagy::Backend
    before_action :authenticate_member!
    
    include Pundit::Authorization
    protect_from_forgery

    def pundit_user
        current_member
    end

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private
    def user_not_authorized
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to(request.referrer || root_path)
      end
end