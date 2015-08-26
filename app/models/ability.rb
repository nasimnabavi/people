class Ability < ActiveRecord::Base
  mount_uploader :icon, IconUploader

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :users

  before_save :update_name_downcase!

  def to_s
    name
  end

  private

  def update_name_downcase!
    self.name_downcase = name.downcase
  end
end
