# frozen_string_literal: true

json.extract!(attendee, :id, :attended, :rsvp, :created_at, :updated_at)
json.url(attendee_url(attendee, format: :json))
