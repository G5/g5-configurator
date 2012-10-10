class WebhookController < ApplicationController
  def index
    Entry.consume_feed
    render json: {}, status: :ok
  end
end
