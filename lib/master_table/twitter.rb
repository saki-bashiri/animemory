module MasterTable
  module Twitter
    CONSUMER_KEY    = Rails.env.production? ? "" : ""
    CONSUMER_SECRET = Rails.env.production? ? "" : ""

    BOT_CONSUMER_KEY        = Rails.env.production? ? "" : ""
    BOT_CONSUMER_SECRET     = Rails.env.production? ? "" : ""
    BOT_ACCESS_TOKEN        = Rails.env.production? ? "" : ""
    BOT_ACCESS_TOKEN_SECRET = Rails.env.production? ? "" : ""
  end
end