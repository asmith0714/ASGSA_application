require "rails_helper"

RSpec.describe MemberMailer, type: :mailer do
  include ActionMailer::TestHelper

  # Defining a member variable at the top-level is fine if you use it in multiple tests.
  let(:admin_member) { create(:member, :admin, email: 'newmember@tamu.edu', first_name: 'New Member') }


  # Assign each member to a variable
  let(:admin_member_for_email) { create(:member, :admin, email: 'member1@tamu.edu', first_name: "Admin Member") }
  let(:officer_member_for_email) { create(:member, :officer, email: 'member2@tamu.edu', first_name: "Officer Member") }


  let(:event) do
    Event.create!(
      name: "Sample Event",
      location: "123 Main St",
      start_time: Time.zone.now,
      end_time: Time.zone.now + 1.hour,
      date: Date.today,
      description: "Event Description",
      capacity: 50,
      points: 10,
      contact_info: "info@example.com",
      category: "Social"
    )
  end

  let(:notification) do
    Notification.create!(
      title: "Urgent Update",
      description: "Please read this important notification.",
      date: Date.today,
      event_id: event.id
    )
  end

  # Example test using the variables
  describe "new_member_email" do
    it "sends a new member email" do
      email = MemberMailer.with(member: admin_member).new_member_email.deliver_now

      expect(email.to).to eq([admin_member.email])
      expect(email.subject).to eq('Your ASGSA Account Has Been Approved!')
    end
  end

  describe "event_email" do
    it "sends an event email with an attachment" do
      email = MemberMailer.event_email(event, Member.where(email: recipient_emails)).deliver_now

      expect(email.to).to match_array(recipient_emails)
      expect(email.subject).to eq('ASGSA: New Upcoming Event!')
      # Assuming the event.ics attachment is present
      expect(email.attachments['event.ics']).to be_present
    end
  end

  describe "notification_email" do
    it "sends a notification email" do
      # Assuming 'notification' is already defined
      # Fetch the Member records you just created
      recipients = Member.where(email: recipient_emails)

      email = MemberMailer.notification_email(notification, recipients).deliver_now

      expect(email.to).to match_array(recipient_emails)
      expect(email.subject).to eq('ASGSA: Notification')
      # Additional expectations as needed
    end
  end
end
