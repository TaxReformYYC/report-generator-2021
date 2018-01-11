require 'thor/group'
require 'csv'
module Proptax
  module Generators
    class Report < Thor::Group
      include Thor::Actions
      attr_accessor :address, :assessed_value, :y_axis_limits

      argument :csv_file, :type => :string
      argument :opts

      def create_report_dir
        puts "create_report_dir"
        empty_directory('reports')
        FileUtils.cp(csv_file, "reports")
      end

      def copy_report_template
        puts "copy_report_template"
        template = 'default'
        if opts.template?
          case opts.template
          when 'cherry-picked'
            template = 'cherry-picked'
          end
        end
        CSV.foreach(csv_file, headers: true) do |row|
          self.address = row['Location Address']
          self.assessed_value = row['Current Assessed Value']
          file_name = address.gsub(/\s/, '_')
          template("#{opts.template}.Rmd", "reports/#{file_name}.Rmd")
        end
      end

      def self.source_root
        puts "self.source_root"
        File.dirname(__FILE__) + "/report"
      end
    end
  end
end
