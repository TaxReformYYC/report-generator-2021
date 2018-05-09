require "proptax/version"

module Proptax
  class Consolidator

  require 'csv'
  require 'pathname'

    #
    # Headers for publicly available assessment data for 2018.
    #
    Headers = ['Current Assessed Value', 'Roll Number', 'Location Address', 'Taxation Status',
               'Assessment Class', 'Property Type', 'Property Use', 'Valuation Approach',
               'Market Adjustment', 'Community', 'Market Area', 'Sub Neighbourhood Code (SNC)',
               'Sub Market Area', 'Influences', 'Land Use Designation', 'Assessable Land Area',
               'Building Count', 'Building Type/Structure', 'Year of Construction',
               'Quality', 'Total Living Area Above Grade', 'Living Area Below Grade', 'Basement Suite',
               'Walkout Basement', 'Garage Type', 'Garage Area', 'Fireplace Count', 'Renovation',
               'Constructed On Original Foundation', 'Modified For Disabled', 'Old House On New Foundation',
               'Basementless', 'Penthouse']

    #
    # Keys that can be assigned multiple values
    #
    MultiFieldHeaders = ['Influences']

    #
    # Section headers for publicly available assessment data for 2018.
    #
    Sections = ['Assessment Details', 'Assessment Approach', 'Location Details', 'Land Details', 'Building Details']
  
    #
    # Convert a directory containing 2018 PDF assessment reports to text and
    # write the relevant CSV information to stdout
    #
    # @param string - path to directory containing PDFs
    #
    # @return nil
    #
    def self.process(dir_name)
      # `strip!': can't modify frozen String (RuntimeError)
      #dir_name.strip!
      dir_name = dir_name.strip
      if dir_name.empty?
        puts "No directory specified"
        return
      end

      begin
        path = Pathname.new(dir_name).realpath
        puts Headers.to_csv if Dir.exists?(path)
        Dir.glob("#{path}/*.{pdf,PDF}") do |pdf|
          data = `pdftotext "#{pdf}" -`
          puts parse(data).to_csv
        end
      rescue 
        puts "Directory #{dir_name} does not exist"
      end
    end
  
    #
    # Take text-converted 2018 assessment reports and extract the relevant data
    # into an array.
    # 
    # @param string - text converted 2018 assessment report
    #
    # @return array
    #
    def self.parse(text)
      csv_hash = {}
      current_header = nil
      text.split(/\n/).each do |line|
        # Replace non-breaking spaces with space and strip
        line = line.gsub(/\u00a0/, ' ').strip
  
        # Remove soft hyphens
        line.gsub!(/\u00AD/, '')
        ## This is untested
        line.gsub!(/â\\200\\224/, '-')

        # Remove trailing colon
        line.gsub!(/:+$/, "");
  
        next if line.empty?
  
        if current_header
          if Sections.include? line
            current_header = nil 
            next
          end

          if MultiFieldHeaders.include? current_header
            if csv_hash[current_header].nil?
              csv_hash[current_header] = clean(line, current_header)
            else
              csv_hash[current_header] += "/#{clean(line, current_header)}"
            end
          else
            csv_hash[current_header] = clean(line, current_header)
            current_header = nil
          end
        elsif Headers.include? line
          current_header = line
        #
        # Need a rasterized report (a la, Windows 7)
        #
        # For tesseract-extracted text
#        else
#          Headers.each do |header|
#            current_header = line[Regexp.new("^#{Regexp.escape(header)}")]
#            break if current_header
#          end
#          if current_header
#            line = line.gsub(Regexp.new("^#{Regexp.escape(current_header)}"), '').strip
#            csv_hash[current_header] = clean(line, current_header)
#            current_header = nil
#          end
        end
      end
#      Headers.map { |header| csv_hash[header] || '0' }
      Headers.map do |header|
        if header == 'Renovation'
          csv_hash[header] || 'unk.' 
        else
          csv_hash[header] || '0' 
        end
      end
    end
  
    #
    # Return square footage only when given spacial data
    #
    # @param string - the text data to be cleaned
    # @param string - the header associated with the text data
    #
    # @return string
    #
    def self.clean(text, header)
      case header
      when 'Current Assessed Value'
        text.gsub!(/,/, '')
      when 'Assessable Land Area',
           'Total Living Area Above Grade',
           'Living Area Below Grade',
           'Garage Area'
        text = text.split(' ')[0].gsub(/,/, '')
      when 'Basement Suite',
           'Walkout Basement',
           'Constructed On Original Foundation',
           'Modified For Disabled',
           'Old House On New Foundation',
           'Basementless',
           'Penthouse',
           'Market Adjustment'
        text = text == 'Yes' ? 'T' : 'F'
      end
      text
    end
  end
end
