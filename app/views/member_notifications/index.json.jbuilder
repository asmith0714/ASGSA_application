# frozen_string_literal: true

json.array!(@member_notifications, partial: 'member_notifications/member_notification', as: :member_notification)
