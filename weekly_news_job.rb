require 'telegram/bot'
require './news'
require 'sidekiq'

class WeeklyNewsJob
  include Sidekiq::Worker

  TELEGRAM_ID="-1001281509424"
  TELEGRAM_TEST="-705566573"

  def perform(*args)
    token = ENV['TELEGRAM_BOT_TOKEN']
    messages = News::get_this_week_news

    Telegram::Bot::Client.run(token) do |bot|
      bot.api.send_message(chat_id: TELEGRAM_TEST, text: messages, parse_mode: "HTML")
    end
  end
end