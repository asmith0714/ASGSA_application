# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :event, optional: true
  has_many :member_notifications, dependent: :destroy
  has_many :members, through: :member_notifications
  accepts_nested_attributes_for :member_notifications
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
end
