class Instruction < ActiveRecord::Base
  attr_accessible :target, :body, :remote_app_id

  belongs_to :remote_app

  validates :body, presence: true
  validates :remote_app_id, presence: true

  def created_at_computer_readable
    created_at.utc.to_s(:computer)
  end

  def created_at_human_readable
    created_at.to_s(:human)
  end
end
