class Instruction < ActiveRecord::Base
  attr_accessible :target, :body
  belongs_to :remote_app
  validates :target, :body, :deployer_id, presence: true
end
