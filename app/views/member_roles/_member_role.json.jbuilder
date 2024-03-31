# frozen_string_literal: true

json.extract!(member_role, :id, :id, :member_id, :role_id, :created_at, :updated_at)
json.url(member_role_url(member_role, format: :json))
