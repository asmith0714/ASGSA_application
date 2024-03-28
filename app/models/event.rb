class Event < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search, against: [:name, :date, :category, :capacity, :points], using: { tsearch: { prefix: true } }
    validates :name, presence: true
    validates :location, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
    validates :date, presence: true
    validates :capacity, numericality: {only_integer: true, greater_than_or_equal_to: 1}, allow_blank: true
    validates :points, numericality: {only_integer: true, greater_than_or_equal_to: 0}
    validates :contact_info, presence: false
    validates :category, presence: true
    validates :description, presence: false
    validate :end_time_after_start_time
    validate :archive
    before_validation :set_default_archive
    has_many :attendees
    has_many :attendees, dependent: :destroy
    has_many :notifications, dependent: :destroy

    private

    def set_default_archive
        self.archive ||= false
    end

    def end_time_after_start_time
        return if end_time.blank? || start_time.blank?

        if end_time <= start_time
        errors.add(:end_time, "must be after the start time")
        end
    end
end
