# frozen_string_literal: true

class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    member, @first_time = Member.from_google(**from_google_params)

    if member.present?
      sign_out_all_scopes
      flash[:success] = t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in(member, event: :authentication)

      if @first_time
        redirect_to(edit_member_path(member))
      else
        redirect_to(stored_location_for(member) || root_path)
      end
    else
      flash[:danger] = t('devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized.")
      redirect_to(new_member_session_path)
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_member_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      avatar_url: auth.info.image
    }
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
