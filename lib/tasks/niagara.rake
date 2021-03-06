require_relative('../app_regional/acquisitions')
require_relative('../app_regional/ontario/infodine/niagara_pwner')


namespace :infodine do
  infodine = Acquisitions.instance.infodine

  # aquires quite a few files (3109)
  desc "pwn the niagara region"
  task :pwn => :environment do
    n = NiagaraPwner.new(infodine)
    n.get_inspection_data
  end

  desc "scrape the final inspection urls"
  task :scrape => :environment do

  end
end
