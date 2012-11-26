class Instruction < ActiveRecord::Base
  attr_accessible :target_app_id, :remote_app_id, :body

  # the app that should perform the instruction
  belongs_to :target_app, class_name: "RemoteApp"
  # the app that will be effected by the instruction
  belongs_to :remote_app

  # validates :target_app_id, presence: true
  # validates :remote_app_id, presence: true
  # validates :body, presence: true

  after_save :post_webhook
  
  def created_at_computer_readable
    created_at.utc.to_s(:computer)
  end

  def created_at_human_readable
    created_at.to_s(:human)
  end
  private

  # TODO: this should post to all subscribers (client hub, client hub deployer)
  def post_webhook
    url = ENV["CLIENT_APP_CREATOR_WEBHOOK_URL"]
    if url
      begin
        Webhook.post(url) 
      rescue ArgumentError => e
        logger.error e
      end
    end
  end
end
