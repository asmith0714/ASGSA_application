# frozen_string_literal: true

class MemberRole < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: %i[first_name last_name position name], using: { tsearch: { prefix: true } }
  belongs_to :member
  belongs_to :role
  validates :member_id, presence: true
  validates :role_id, presence: true
  validates :role_id, numericality: { only_integer: true }
  validates :role_id, uniqueness: { scope: :member_id, message: 'member already has this role' }
  validates :member_id, numericality: { only_integer: true }
  validates :member_id, uniqueness: { scope: :role_id, message: 'role already has this member' }
  validate :at_least_one_admin, on: :update

  def at_least_one_admin
    admin_role = Role.find_by(name: 'Admin')
    admins = admin_role.members if admin_role
    errors.add(:role, 'At least one user must be an admin at all times') if admins.size == 1 && admins.find_by(member_id: member_id)
  end
end
