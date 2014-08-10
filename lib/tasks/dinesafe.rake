require_relative('../app_regional/acquisitions')
require_relative('../app_regional/header')
require_relative('../app_regional/ontario/dinesafe/archiver')
require_relative('../app_regional/ontario/dinesafe/dinesafe_scraper')
require_relative('../app_regional/ontario/dinesafe/dinesafe_geo')
namespace :dinesafe do

  dinesafe = Acquisitions.instance.dinesafe
  shapefiles = Acquisitions.instance.shapefiles

  desc "Tasks to downloads and unzips dinesafe.xml archive"
  task :grab => :environment do

    city_archive_timestamp = Header.new(dinesafe[:url]).last_modified

    latest = LatestArchive.where(:category => dinesafe[:category])

    latest_timestamp = latest[0].headstamp

    if latest.count == 0 || latest_timestamp < city_archive_timestamp
      archiver = Archiver.new(dinesafe, city_archive_timestamp)
      f, fb, fr = archiver.print_setup

      puts "\nDownloading #{f}............".colorize(:green)
      puts archiver.grab ? 'Downloaded: '.colorize(:green) + fb : "Failed Download: #{fr}"
      puts archiver.verify ? 'Verified: '.colorize(:green) + fb : "Failed Verify: #{fr}"
      puts archiver.extract ? 'Extracted: '.colorize(:green) + fb : "Failed Extraction: #{fr}"

      archiver.persist

      la = LatestArchive.create(:category => dinesafe[:category], :headstamp => city_archive_timestamp)
      puts "Latest #{dinesafe[:category]} Archive stored: #{city_archive_timestamp}"
    else
      puts 'Archive not downloaded. Fresh copy not available'.colorize(:red)
    end
  end

  desc "Parses the latest xml archive and persists the data"
  task :parse => :environment do
    latest = LatestArchive.where(:category => dinesafe[:category])
    latest_timestamp = latest[0].headstamp
    DinesafeScraper.new(dinesafe, ArchiveDirectory.new(dinesafe)).parse(latest_timestamp)
  end

  desc "Parses all the xml archives and persists the data"
  task :parse_all => :environment do
   DinesafeScraper.new(dinesafe, ArchiveDirectory.new(dinesafe)).parse_all
  end

  desc "Download the Shapefile from the city of Toronto"
  task :grabshape => :environment do
    city_archive_timestamp = Header.new(shapefiles[:url]).last_modified

    latest = LatestArchive.where(:category => shapefiles[:category])

    latest_timestamp = latest[0].headstamp
    if latest.count == 0 || latest_timestamp < city_archive_timestamp
      archiver = Archiver.new(shapefiles, city_archive_timestamp)

      f, fb, fr = archiver.print_setup

      puts "\nDownloading #{f}............".colorize(:green)
      puts archiver.grab ? 'Downloaded: '.colorize(:green) + fb : "Failed Download: #{fr}"
      puts archiver.verify ? 'Verified: '.colorize(:green) + fb : "Failed Verify: #{fr}"
      puts archiver.extract ? 'Extracted: '.colorize(:green) + fb : "Failed Extraction: #{fr}"

      archiver.persist

      la = LatestArchive.create(:category => shapefiles[:category], :headstamp => city_archive_timestamp)
      puts "Latest #{shapefiles[:category]} Archive stored: #{city_archive_timestamp}"
    else
      puts 'Archive not downloaded. Fresh copy not available'.colorize(:red)
    end
  end

  desc "Populates the Address Model with geo data from a shape file"
  task :geo => :environment do
    puts DinesafeGeo.new(shapefiles, ArchiveDirectory.new(shapefiles)).parse ?
             'Finished parsing shapefile'.colorize(:green) :
             'Shapefile archived previously parsed or not fresh'.colorize(:red)
  end

  desc "Meshes the geo data in the Address model with the Venue model"
  task :mesh => :environment do

  end
end