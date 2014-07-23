namespace :dinesafe do
  desc "Tasks to downloads and unzips dinesafe.xml archive"
  task :grab => :environment do
    grabber = DinesafeGrabber.new
    grabber.grab
  end

  desc "Parses the xml archive and puts it into the database with ActiveRecord"
  task :parse => :environment do
    latest_dinesafe = Archive.last
    if !latest_dinesafe.nil?
      parser = DinesafeScraper.new(latest_dinesafe)
      if !parser
        puts 'Archive is not fresh. No parsing will be performed'
      else
        puts parser.to_s
        parser.parse
      end
    else
      puts "There are no dinesafe archives to parse.\nTry running 'rake dinesafe:grab'"
    end
  end
end