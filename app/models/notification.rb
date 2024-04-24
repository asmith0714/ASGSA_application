# frozen_string_literal: true

class Notification < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: %i[title description], using: { tsearch: { prefix: true } }
  belongs_to :event, optional: true
  has_many :member_notifications, dependent: :destroy
  has_many :members, through: :member_notifications
  accepts_nested_attributes_for :member_notifications
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  has_one_attached :attachment
  validate :acceptable_file

  def acceptable_file
    return unless attachment.attached?

    acceptable_types = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf']
    return if acceptable_types.include?(attachment.content_type)

    errors.add(:attachment, 'must be a JPEG, JPG, PNG, or PDF file')
  end
end
