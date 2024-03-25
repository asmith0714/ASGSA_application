# frozen_string_literal: true

class PagesController < ApplicationController
  def help
    if request.post?
      name = params[:name]
      email = params[:email]
      issue = params[:issue]

      # Send the email
      MemberMailer.support_email(name, email, issue).deliver_now

      # Redirect to some page with a success message
      redirect_to(root_path, notice: 'Your message was sent successfully.')
    end
  end

  def faq_member; end

  def faq_officer; end
end
