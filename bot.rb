require 'rss'
require 'open-uri'
require 'byebug'
require "active_support/all"
require 'telegram/bot'

def get_this_week_news
	rsses = ["https://discourse.elm-lang.org/latest.rss",
				   "https://feeds.simplecast.com/8tQUlnkG",
				   "https://elm-radio.com/feed.xml"]

	feeds = rsses.map do |url|
		URI.open(url) do |rss|
			feed = RSS::Parser.parse(rss)
		end
	end

	items = feeds.reduce([]) do |all, current|
						all + current.items
					end

	valid = items.select { |a| a.pubDate > 1.week.ago }

	"This week in Elm Ecosystem: " + valid.map { |a| "<b><i>Title</i></b>: #{a.title} \n <b>Date</b>: #{a.pubDate} \n <b>Link</b>: #{a.link} \n"}.join("\n")
end


token = ENV['TELEGRAM_BOT_TOKEN']

puts "=== Bot started"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/latest_news'
    	puts "answerring message #{message.chat.id}"
      bot.api.send_message(chat_id: message.chat.id, text: get_this_week_news, parse_mode: "HTML")
    end
  end
end

TELEGRAM_ID="-1001281509424"
TELEGRAM_TEST="-705566573"

# messages = get_this_week_news

# Telegram::Bot::Client.run(token) do |bot|
#   bot.api.send_message(chat_id: TELEGRAM_TEST, text: messages, parse_mode: "HTML")
# end