class WebhooksController < ApplicationController
  def consume_feed
    # TODO: async
    Entry.consume_feed
    render json: {}, status: :ok
  end
end
