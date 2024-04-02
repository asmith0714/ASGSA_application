# frozen_string_literal: true

class MemberMailerPreview < ActionMailer::Preview
  def notification_email
    MemberMailer.notification_email(Notification.last, Member.all)
  end

  def event_email
    MemberMailer.event_email(Event.last, Member.all)
  end
end
