# frozen_string_literal: true

class MemberNotification < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, associated_against:{ notification: %i[title description]}, using: { tsearch: { prefix: true } }
  belongs_to :member
  belongs_to :notification
  validates :member_id, presence: true
  validates :notification_id, presence: true
  validates :seen, inclusion: [true, false]
  validates :member_id, numericality: { only_integer: true }
  validates :notification_id, numericality: { only_integer: true }
end
