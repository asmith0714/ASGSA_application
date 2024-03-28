class MemberMailerPreview < ActionMailer::Preview
  def notification_email
    MemberMailer.notification_email(Notification.first, Member.all)
  end
end