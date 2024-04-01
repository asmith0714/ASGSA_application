# frozen_string_literal: true

class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include PgSearch::Model
  pg_search_scope :general_search, against: [:first_name, :last_name, :email, :position, :area_of_study, :points, :status], using: { tsearch: { prefix: true } }
  pg_search_scope :allergies_search, against: [:first_name, :last_name, :food_allergies], using: { tsearch: { prefix: true } }
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  # Validate presence of essential attributes
  # validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "can only contain letters" }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@tamu\.edu\z/i, message: 'must be TAMU affiliated' }
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, presence: true
  validates :food_allergies, presence: true
  has_many :attendees, dependent: :destroy
  has_many :member_roles, dependent: :destroy
  has_many :roles, through: :member_roles
  has_many :member_notifications, dependent: :destroy
  has_many :notifications, through: :member_notifications

  def admin?
    member_roles.exists?(role_id: Role.find_by(name: 'Admin').id)
  end

  def officer?
    member_roles.exists?(role_id: Role.find_by(name: 'Officer').id)
  end

  def member?
    member_roles.exists?(role_id: Role.find_by(name: 'Member').id)
  end

  def approved?
    !member_roles.exists?(role_id: Role.find_by(name: 'Unapproved').id)
  end

  def unapproved?
    member_roles.exists?(role_id: Role.find_by(name: 'Unapproved').id)
  end

  def unseen_notifications_count
    member_notifications.where(seen: false).count
  end

  def self.from_google(email:, first_name:, last_name:, uid:, avatar_url:)
    first_time = !Member.exists?(email: email)
    return nil unless /@tamu.edu\z/.match?(email)

    member = create_with(uid: uid, first_name: first_name, last_name: last_name, avatar_url: avatar_url, points: 0, position: 'Member',
                         date_joined: Time.current, food_allergies: 'None'
    ).find_or_create_by!(email: email)
    role = Role.find_by(name: 'Unapproved')
    MemberRole.create!(member: member, role: role) if first_time
    [member, first_time]
  end
end
