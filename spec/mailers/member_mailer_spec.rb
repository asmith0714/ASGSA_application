# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MemberMailer, type: :mailer) do
  before do
    Rails.application.load_seed
  end

  describe 'new_member_email' do
    let(:member) { create(:member) }
    let(:mail) { described_class.with(member: member).new_member_email }

    it 'renders the headers' do
      expect(mail.subject).to(eq('Your ASGSA Account Has Been Approved!'))
      expect(mail.to).to(eq([member.email]))
    end
  end

  describe 'support_email' do
    let(:mail) { described_class.support_email('John Doe', 'john.doe@example.com', 'Issue') }

    it 'renders the headers' do
      expect(mail.subject).to(eq('New Support Request'))
      expect(mail.to).to(eq(['asgsatamu1@gmail.com']))
    end
  end

  describe 'event_email' do
    let(:event) { Event.create!(name: 'Event', location: 'Location', start_time: Time.zone.parse('14:00'), end_time: Time.zone.parse('16:00'), date: Time.zone.today + 1.day, description: 'Description', category: 'Category', capacity: 100, points: 5) }
    let(:recipients) { create_list(:member, 3) }
    let(:mail) { described_class.event_email(event, recipients) }

    it 'renders the headers' do
      expect(mail.subject).to(eq('ASGSA: New Upcoming Event!'))
      expect(mail.to).to(match_array(recipients.pluck(:email)))
    end
  end

  describe 'notification_email' do
    let(:notification) { Notification.create!(title: 'Title', description: 'Body', date: Time.zone.today) }
    let(:recipients) { create_list(:member, 3) }
    let(:mail) { described_class.notification_email(notification, recipients) }

    it 'renders the headers' do
      expect(mail.subject).to(eq('ASGSA: Notification'))
      expect(mail.to).to(match_array(recipients.pluck(:email)))
    end
  end
end
