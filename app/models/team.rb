class Team < ActiveRecord::Base
  include InitialsHandler

  before_save :set_color

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :users
  belongs_to :leader, class_name: 'User', foreign_key: 'user_id'

  accepts_nested_attributes_for :users

  def set_color
    self.color ||= AvatarColor.new.as_rgb
  end
end
