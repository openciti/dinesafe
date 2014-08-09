# good candidate to seed into an Acquisitions model,
require 'singleton'

class Acquisitions
  include Singleton

  def shapefiles
    {url: 'http://opendata.toronto.ca/gcc/address_points_wgs84.zip',
     path: 'app/assets/shapefiles',
     filename: 'ADDRESS_POINT_WGS84.shp',
     archive: 'app/assets/shapefiles/archives',
     category: 'shapefile',
     region: 'Toronto'}
  end

  def dinesafe
    {url: 'http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip',
     path: 'app/assets/dinesafe',
     filename: 'dinesafe.xml',
     archive: 'app/assets/dinesafe/archives',
     category: 'dinesafe',
     region: 'Toronto'}
  end

  def durham
    {url: 'http://www.durham.ca/dineSafe/DineSafeInspectionSearch.aspx',
     path: 'app/assets/dinesafe_durham',
     prefix: 'http://www.durham.ca/dineSafe/',
     archive: 'app/assets/dinesafe_durham/archives',
     category: 'durham',
     region: 'Durham'}
  end

  def infodine
    {url: 'http://www.niagararegion.ca/living/health_wellness/inspect/infodine/',
     path: 'app/assets/infodine',
     filename: nil,
     archive: 'app/assets/infodine/archives',
     category: 'infodine',
     region: 'Niagara'}
  end

end