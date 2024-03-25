# frozen_string_literal: true

require 'cgi'

class MemberMailer < ApplicationMailer
  def new_member_email
    @member = params[:member]
    mail(to: @member.email, subject: 'Your ASGSA Account Has Been Approved!')
  end

  def support_email(name, email, issue)
    @name = name
    @email = email
    @issue = issue

    mail(to: 'asgsatamu1@gmail.com', subject: 'New Support Request')
  end

  def event_email(event, recipients)
    @event = event

    @calendar_link = AddToCalendar::URLs.new(
      start_datetime: Time.zone.local(@event.date.year, @event.date.month, @event.date.day, @event.start_time.hour, @event.start_time.min,
                                      @event.start_time.sec
      ),
      end_datetime: Time.zone.local(@event.date.year, @event.date.month, @event.date.day, @event.end_time.hour, @event.end_time.min,
                                    @event.end_time.sec
      ),
      title: @event.name,
      location: @event.location,
      description: @event.description,
      timezone: 'America/Chicago'
    )

    ics_content = CGI.unescape(@calendar_link.ical_url.split(',')[1])
    attachments['event.ics'] = { mime_type: 'text/calendar', content: ics_content }

    mail(to: recipients.pluck(:email), subject: 'ASGSA: New Upcoming Event!')
  end

  def notification_email(notification)
    @notification = notification

    mail(to: Member.pluck(:email), subject: 'ASGSA: Notification')
  end
end
