require_relative('../app_regional/acquisitions')
require_relative('../app_regional/ontario/waterloo/waterloo_archiver')

namespace :waterloo do
  waterloo = Acquisitions.instance.waterloo

  desc "acquire the three archives: shp, kml and inspections"
  task :grab => :environment do

    w = WaterlooArchiver.new(waterloo).grab



  end



end
