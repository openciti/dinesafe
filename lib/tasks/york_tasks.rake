namespace :york do

  york = Acquisitions.instance.york


  desc "pwn york regional yorksave site"
  task :pwn => :environment do
    y = YorkPwner.new(york)

    #stores in grab
    y.get_inspection_links


  end
end