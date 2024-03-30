# frozen_string_literal: true

json.extract!(member_notification, :id, :member_id, :notification_id, :created_at, :updated_at)
json.url(member_notification_url(member_notification, format: :json))
