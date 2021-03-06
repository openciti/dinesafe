Dinesafe
===

A dinesafe application covering as much of Ontario as possible.

BC is the next target.

Twitter: @mydinesafe will serve data by interactive tweet

https://twitter.com/mydinesafe

Web: TODO

Android: TODO

Monitors open data from Peel, Waterloo and Toronto.
Compiles all versions into a master archive.

Collects inspection urls from other regions in Ontario without
open data inspection formats and stores them the Grab model.

URLs in the Grab model are then scraped and serialized.

Licences
---
Contains information licensed under the Open Government Licence – Toronto.
http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=4a37e03bb8d1e310VgnVCM10000071d60f89RCRD

Contains information provided by the Regional Municipality of Waterloo under licence
http://www.regionofwaterloo.ca/en/regionalGovernment/OpenDataLicence.asp.

Contains public sector Information made available under The Regional Municipality of Peel's Open Data Licence - Version 1.0
http://opendata.peelregion.ca/terms-of-use.aspx

Acquisitions Singleton
---
App data is contained here until as many regions as possible are covered.
TODO put into a model and seed in seeds.db

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/acquisitions.rb


Open Data Regions
===

Its 2014, have you seen my open data?
Apparently only Peel, Toronto and Waterloo know the future is now.
TODO: send smoke signals to other regions

Ottawa
---
The City of Ottawa has decided to release the data in CSV format *and* make it available as an API, which is a first in Canada.

Still working on figuring all this out.
Check the ottawa branch on the repo: https://github.com/openciti/dinesafe/tree/ottawa

rake task to grab the archive, store the unzipped file, record the server timestamp and unzip the files
This only occurs if the archive has been modified (using the faraday gem https://github.com/lostisland/faraday)
https://github.com/openciti/dinesafe/blob/ottawa/lib/tasks/ottawa.rake

TODO: populate a model based on the csv data

Thanks to Ryan Furuness for doing it right.

![Screenshot](https://raw.githubusercontent.com/openciti/dinesafe/master/app/assets/images/dev_screenshots/ottawagrab.png)

Dinesafe (Toronto)
---
Available as an XML file updated on a Monday morning early each month.
https://github.com/openciti/dinesafe/tree/master/lib/app_regional/ontario/dinesafe
![Screenshot](https://raw.githubusercontent.com/openciti/dinesafe/master/app/assets/images/dev_screenshots/DineSafeGrabber.png)

Waterloo Region
---
Has open data, in csv and kml formats. Shapefile is corrupted.

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/ontario/waterloo/waterloo_archiver.rb

Peel Region
---
TODO

Non Open Data Regions
===

Fax? Smoke signals? Memorandum? Carrier pigeon?

How to ask for open data from these places? #sarcasm

Dinesafe (Durham)
---
Nicely puts all (approx 3000) inspection links on a single page when you click on an empty form.

https://github.com/openciti/dinesafe/tree/master/lib/app_regional/ontario/durham_dinesafe

While most scrapes are done with Nokogiri, some aspx (.net) apps require Mechanize.

Mechanize is a way to browse websites programmatically.

https://github.com/sparklemotion/mechanize

InfoDine - Niagara (12 regions)
---
More involved than Durham region as there are 12 inspection sites instead of one

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/ontario/infodine/niagara_pwner.rb

    - gets the 12 regional urls from the infodine homepage
    - creates a directory structure with a timestamp as the root and
        with a subfolder for each region
    - blasts through each regional site to get inspection urls
    - saves the eventual desired file path and the url in the Grab
        model for later processing
    - TODO start a cron task to perform scraping on the over 3000 inspection urls
    - TODO write the final scraper

Regions Using the Hedgerow web application
===

Referred to as 'Facility' due to this term common to the URLs

Inspections for these regions are very easy to access,
as the urls and web structure are the same or similar.

Request all records in one page by setting &page-size=-1

https://github.com/openciti/dinesafe/blob/master/lib/app_regional/facility_type_site_pwner.rb

    General class that covers
        Guelph / Wellington
        Timiskaming
        Vancouver Coastal Region
        York region

British Columbia (BC)
===

All regions except for VCH use the same web app.

Rake Tasks
---
https://github.com/openciti/dinesafe/tree/master/lib/tasks

    dinesafe:grab dinesafe:parse
    dinesafe:grabshapefile dinesafe:geo

    guelph:pwn durham:pwn infodine:pwn niagara:pwn york:pwn waterloo:grab

Cron Jobs
---
Done with RufusScheduler https://github.com/jmettraux/rufus-scheduler

https://github.com/openciti/dinesafe/tree/master/config/initializers/crons

