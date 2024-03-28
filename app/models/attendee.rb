class Attendee < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: [:first_name, :last_name, :email, :position], using: { tsearch: { prefix: true } }
  belongs_to :event
  belongs_to :member

  validate :unique_member_and_event
  validates :member_id, presence: true
  validates :event_id, presence: true
  validates :attended, presence: false
  validates :rsvp, presence: false

  private

  def unique_member_and_event
    existing_attendee = Attendee.find_by(member_id: member_id, event_id: event_id)

    if existing_attendee && existing_attendee != self
      errors.add(:base, "RSVP for this event has already been created")
    end
  end
end
