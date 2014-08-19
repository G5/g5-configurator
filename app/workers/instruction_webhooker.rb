class InstructionWebhooker
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :webhooker

  def self.perform(instruction_id)
    Rails.logger.info "Start webooking Instruction ##{instruction_id}..."
    puts "Start webooking Instruction ##{instruction_id}..."
    Instruction.find(instruction_id).webhook_target_apps
    Rails.logger.info "Done webooking Instruction ##{instruction_id}."
    puts "Done webooking Instruction ##{instruction_id}."
  end
end
