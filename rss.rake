namespace :rss do
  require 'rss'
  desc "GET NEW ARTICLES FROM RSS FEEDS"
  task get_articles: :environment do
    #pull list of RSS feeds from the database
    feeds = Feed.all
    #run through list of feeds
    feeds.each do |feed|
      #parse URL of feed and split articles into 'items'
      rss = RSS::Parser.parse(feed.url)
      #run through list of articles
      rss.items.each do |article|
        #check article URL and title against database to avoid duplicates
        unless Article.where(:url => article.link).count > 0 || Article.where(:name => article.title).count > 0
          #print to terminal for debugging purposes
          puts "Adding article..."
          puts "#{article.title}"
          puts "#{article.link}"
          puts " "
          puts "---------------"
          puts " "
          #create article and add it to the database
          Article.create!(:name => article.title,
                  :url => article.link,
                  :published => article.pubDate,
                  :source => feed.identifier,
                  :tags => feed.twitt,
                  :customtitle => article.title)
        end
      end
    end
  end

  desc "TEST OUTPUT OF FEED WITH PROVIDED URL FOR DEBUGGING PURPOSES"
  task :test_feed, [:url] => :environment do |t, args|
    #parse feed provided within task parameters
    rss = RSS::Parser.parse(args.url)
    #run through list of articles
    rss.items.each do |article|
      #print data to terminal
      puts "#{article.title}"
      puts "#{article.link}"
      puts "#{article.pubDate}"
      puts " "
      puts "--------------"
      puts " "
    end
  end

  desc "ARCHIVE ARTICLES OVER A WEEK OLD -- TO BE USED AS CRON JOB"
  task clear_articles: :environment do
    #get current date
    now = Date.today
    #get date equal to one week ago
    week = (now - 7)
    #search database for articles published more than a week ago
    articles = Article.where(:archived => false).where("published < ?", week).all
    #run through articles published more than a week ago
    articles.each do |article|
      #print to terminal
      puts "Archiving article '#{article.name}'..."
      #archive the article
      article.archive
      puts " "
      puts "---------------"
      puts " "
    end
  end

end
