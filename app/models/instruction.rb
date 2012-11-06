class Instruction < ActiveRecord::Base
  attr_accessible :target, :body, :remote_app_id
  belongs_to :remote_app
  validates :body, :remote_app_id, presence: true
end
