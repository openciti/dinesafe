class DurhamPwner

  def initialize(acquisition)
    @aq = acquisition
    @timestamp = Time.now.to_i
    @should_contain = "DineSafeInspectionResults"
    @form = "aspnetForm"
    @html_suffix = ".html"
  end

  def inspections
    query_page = Mechanize.new.get(@aq[:url])
    form = query_page.form(@form)
    button = form.button
    form.submit(button).links
  end

  def get_urls(links)
    urls = Array.new
    links.each do |link|
      if link.href.include? @should_contain
        #strip url of all whitespace including \r, \n and \t anywhere in the string
        urls.push(link.href.gsub(/\s+/, ''))
      end
    end
    urls
  end

  def ensure_dir(dir)
    Dir.mkdir(dir) unless Dir.exists?(dir)
  end

  def mass_wget(urls)
    fails = Array.new

    self.ensure_dir(@aq[:path])
    destination = File.join(@aq[:path], @timestamp.to_s)
    self.ensure_dir(destination)

    urls.each do |url_suffix|
      id = url_suffix.split('=').last.strip
      url = @aq[:prefix] + url_suffix
      destination_file = File.join(destination, id + @html_suffix)
      system("wget #{url} -O #{destination_file}")

      unless $?.exitstatus == 0
        puts "Failed to get #{id}".colorize(:red)
        fails.push(url)
      end

      if fails.count == 0
        puts 'No errors!'.colorize(:green)
      else
        puts "#{fails.count} Errors: "
        puts fails
      end
    end
  end

end
