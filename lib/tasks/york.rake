require_relative('../app_regional/acquisitions')
require_relative('../app_regional/facility_type_site_pwner')

namespace :york do
  york = Acquisitions.instance.york

  desc "pwn york regional yorksave site"
  task :pwn => :environment do
    y = FacilityTypeSitePwner.new(york)

    #stores in grab
    y.get_inspection_links

  end
end