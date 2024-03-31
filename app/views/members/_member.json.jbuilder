# frozen_string_literal: true

json.extract!(member, :id, :first_name, :last_name, :email, :points, :position, :date_joined, :degree, :food_allergies, :status, :res_topic,
              :res_lab, :res_pioneer, :res_description, :area_of_study, :created_at, :updated_at
)
json.url(member_url(member, format: :json))
