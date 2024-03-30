# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  def new_member_email
    member = Member.first
    MemberMailer.with(member: member).new_member_email
  end
end
