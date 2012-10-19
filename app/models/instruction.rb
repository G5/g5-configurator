class Instruction < ActiveRecord::Base
  default_scope order('created_at desc')
  attr_accessible :target, :body, :deployer_id
  belongs_to :remote_app, foreign_key: :deployer_id
  validates :body, :deployer_id, presence: true
end
