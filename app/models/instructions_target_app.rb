class InstructionsTargetApp < ActiveRecord::Base
  belongs_to :instruction
  belongs_to :target_app, class_name: "RemoteApp"
end
