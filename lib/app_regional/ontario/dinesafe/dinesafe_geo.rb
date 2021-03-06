class DinesafeGeo
  attr_reader :timestamp, :aq

  def initialize(acquisition, archive_directory)
    @aq = acquisition
    @timestamp = archive_directory.get_sorted_timestamps.last
  end

  def most_recent_fullpath
    File.join(aq[:path], timestamp.to_s, aq[:shapefile])
  end

  def parse
    return false unless Shape.where(:timestamp => timestamp).count == 0

    # truncate table we are only interested in the latest data
    Address.delete_all

    # set the shape model up
    s = Shape.where(:timestamp => timestamp, :region => 'Toronto').first_or_create

    # Shapefile reader
    RGeo::Shapefile::Reader.open(most_recent_fullpath) do |file|
      n = file.num_records
      puts "\nFile contains #{n} records.".colorize(:orange)

      file.each do |record|

        attributes = record.attributes

        lat = attributes['LATITUDE']
        lng = attributes['LONGITUDE']
        num = attributes['ADDRESS']
        street = attributes['LFNAME']
        lonum = attributes['LONUM']
        lonumsuf = attributes['LONUMSUF']
        hinum = attributes['HINUM']
        hinumsuf = attributes['HINUMSUF']
        ward = attributes['WARD_NAME']
        mun = attributes['MUN_NAME']
        dist = attributes['DISTANCE']
        arc = attributes['ARC_SIDE']
        name = attributes['NAME']

        a = Address.where(:shape_id => s.id,
                          :lat => lat.to_f,
                          :lng => lng.to_f,
                          :num => num.to_s,
                          :street => street.to_s,
                          :lonum => lonum.to_s,
                          :lonumsuf => lonumsuf.to_s,
                          :hinum => hinum.to_s,
                          :hinumsuf => hinumsuf.to_s,
                          :ward => ward.to_s,
                          :mun => mun.to_s,
                          :arc => arc.to_s,
                          :dist => dist.to_f,
                          :name => name).first_or_create

        puts n.to_s.colorize(:light_blue) + ": #{num} #{street}".colorize(:orange) + " #{name} ".colorize(:yellow) + "#{lat} #{lng}".colorize(:blue)
        n -= 1
      end
    end
    Scrape.create(:category => aq[:category], :version => timestamp)
  end
end
