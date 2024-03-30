# frozen_string_literal: true

json.extract!(notification, :id, :description, :send_time, :send_date, :is_sent, :created_at, :updated_at)
json.url(notification_url(notification, format: :json))
