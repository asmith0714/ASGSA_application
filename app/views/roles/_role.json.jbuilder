# frozen_string_literal: true

json.extract!(role, :id, :role_id, :name, :permissions, :created_at, :updated_at)
json.url(role_url(role, format: :json))
