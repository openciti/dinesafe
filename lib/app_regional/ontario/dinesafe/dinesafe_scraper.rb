=begin
  <ROWDATA>
  ...
    <ROW>
      <ROW_ID>904</ROW_ID>
      <ESTABLISHMENT_ID>9001491</ESTABLISHMENT_ID>
      <INSPECTION_ID>102852179</INSPECTION_ID>
      <ESTABLISHMENT_NAME>JAPAN SUSHI</ESTABLISHMENT_NAME>
      <ESTABLISHMENTTYPE>Restaurant</ESTABLISHMENTTYPE>
      <ESTABLISHMENT_ADDRESS>482 BLOOR ST W</ESTABLISHMENT_ADDRESS>
      <ESTABLISHMENT_STATUS>Pass</ESTABLISHMENT_STATUS>
      <MINIMUM_INSPECTIONS_PERYEAR>3</MINIMUM_INSPECTIONS_PERYEAR>
      <INFRACTION_DETAILS/>
      <INSPECTION_DATE>2012-11-02</INSPECTION_DATE>
      <SEVERITY/>
      <ACTION/>
      <COURT_OUTCOME> </COURT_OUTCOME>
      <AMOUNT_FINED> </AMOUNT_FINED>
    </ROW>
  ...
  </ROWDATA>
=end

class DinesafeScraper
  attr_reader :aq, :archive_directory

  def initialize(acquisition, archive_directory)
    @aq = acquisition
    @archive_directory = archive_directory
  end

  def xml_file_path(timestamp)
    File.join(aq[:path], timestamp, aq[:dinesafe])
  end

  def parse_all
    archive_directory.get_sorted_timestamps.each do |a_timestamp|
      unless Event.where(:version => a_timestamp).count == 0
        puts self.parse(a_timestamp) ?
                 "OK on #{a_timestamp}".colorize(:light_blue) :
                 "ERROR on #{a_timestamp}".colorize(:red)
      end
    end
  end

  def parse(timestamp)
    # splits the xml file into single inspection chunks (see top of file)

    return false unless Scrape.where(:version => timestamp).count == 0

    path = xml_file_path(timestamp)

    i = Nokogiri::XML(File.open(path)).css('ROWDATA ROW')

    # counter for output
    # rows start at 1
    n = 1

    new_entries = 0
    existing_entries = 0
    existing_venues = 0
    new_venues = 0

    i.each_with_index do |row|

      #rid =      row.xpath('ROW_ID').text.to_i
      eid =      row.xpath('ESTABLISHMENT_ID').text.to_i
      iid =      row.xpath('INSPECTION_ID').text.to_i
      name =     row.xpath('ESTABLISHMENT_NAME').text.strip.split.join(' ')
      etype =    row.xpath('ESTABLISHMENTTYPE').text.strip.split.join(' ')
      status =   row.xpath('ESTABLISHMENT_STATUS').text.strip.split.join(' ')
      details =  row.xpath('INFRACTION_DETAILS').text.strip.split.join(' ')
      date =     row.xpath('INSPECTION_DATE').text.strip.split.join(' ')
      severity = row.xpath('SEVERITY').text.strip.split.join(' ')
      action =   row.xpath('ACTION').text.strip.split.join(' ')
      outcome =  row.xpath('COURT_OUTCOME').text
      fine =     row.xpath('AMOUNT_FINED').text
      address =  row.xpath('ESTABLISHMENT_ADDRESS').text.strip.split.join(' ')
      mipy =     row.xpath('MINIMUM_INSPECTIONS_PERYEAR').text.to_i

      v = Venue.where(:eid => eid,
                      :name => name,
                      :address => address,
                      :etype => etype,
                      :lat => nil,
                      :lng => nil,
                      :mipy => mipy).first_or_create

      i = Event.where(:iid => iid,
                      :venue_id => v.id,
                      :status => status,
                      :details => details,
                      :date => date,
                      :severity => severity,
                      :action => action,
                      :outcome => outcome,
                      :fine => fine).first_or_create(version: timestamp)

      if Venue.last.eid == eid
        existing_venues += 1
      else
        new_venus += 1
      end 

      if i.version == timestamp
        existing_entries += 1
      else
        new_entries +=1
      end

      nb = v.name.colorize(:blue)
      ib = i.iid.to_s.colorize(:blue)
      eb = v.eid.to_s.colorize(:blue)

      puts "#{n} ".colorize(:green) + "name:#{nb}, EID: #{eb}, IID: #{ib}" if n % 500 == 0

      n += 1
    end

    puts 'Version: '.colorize(:orange) + timestamp.to_s.colorize(:light_green)
    puts "#{existing_entries.to_s.colorize(:blue)} Existing Entries".colorize(:green)
    puts "#{new_entries.to_s.colorize(:blue)} New Entries".colorize(:green)
    puts "#{existing_venues.to_s.colorize(:blue)} Existing Venues".colorize(:green)
    puts "#{new_venues.to_s.colorize(:blue)} New Venues".colorize(:green)
    puts "\n" + '-' * 80 + "\n"

    Scrape.create(:category => aq[:category], :version => timestamp)

    true
  end
end
