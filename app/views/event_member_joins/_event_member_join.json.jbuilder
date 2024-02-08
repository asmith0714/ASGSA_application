json.extract! event_member_join, :id, :attended, :rsvp, :created_at, :updated_at
json.url event_member_join_url(event_member_join, format: :json)
