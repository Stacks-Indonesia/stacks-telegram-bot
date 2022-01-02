require 'telegram/bot'
require './news'

token = ENV['TELEGRAM_BOT_TOKEN']

puts "=== Bot started"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/latest_news'
    	puts "answerring message #{message.chat.id}"
      bot.api.send_message(chat_id: message.chat.id, text: News::get_this_week_news, parse_mode: "HTML")
    end
  end
end