class InstructionsTargetApp < ActiveRecord::Base
  attr_accessible :instruction_id, :target_app_id

  belongs_to :instruction
  belongs_to :target_app, class_name: "RemoteApp"
end
