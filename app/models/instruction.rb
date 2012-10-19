class Instruction < ActiveRecord::Base
  attr_accessible :target, :body, :deployer_id
  belongs_to :remote_app, foreign_key: :deployer_id
  validates :body, :deployer_id, presence: true
end
