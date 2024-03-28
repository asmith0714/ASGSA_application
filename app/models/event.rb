# frozen_string_literal: true

class Event < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: %i[name date capacity points], using: { tsearch: { prefix: true } }
  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :date, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_blank: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :contact_info, presence: false
  validates :description, presence: false
  validate :end_time_after_start_time
  has_many :attendees, dependent: :destroy
  has_one_attached :attachment
  validate :acceptable_file

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    errors.add(:end_time, 'must be after the start time') if end_time <= start_time
  end

  def acceptable_file
    return unless attachment.attached?

    acceptable_types = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf']
    return if acceptable_types.include?(attachment.content_type)

    errors.add(:attachment, 'must be a JPEG, JPG, PNG, or PDF file')
  end
end
