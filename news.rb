require 'rss'
require 'open-uri'
require "active_support/all"

module News
	def self.get_this_week_news
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
end