#require 'csv'
require 'thor'
require 'proptax'
#require 'proptax/generators/promo'
#require 'proptax/generators/report'
module Proptax
  class CLI < Thor
#    check_unknown_options!
#
#    # 2016-2-29 http://stackoverflow.com/questions/14346285/how-to-make-two-thor-tasks-share-options
#    shared_options = [:ylimit, {
#                        :type => :string,
#                        :default => "10000",
#                        :description => "Expand y-axis limits"}]
#    report_options = [:template, {
#                        :type => :string,
#                        :default => "default",
#                        :description => "Apply specific template: [default, cherry-picked]"}]
#    consolidate_options = [:consolidate, {
#                            :type => :boolean,
#                            :default => true,
#                            :description => "Consolidate the PDFs before generating the report"}] 
#
    desc "consolidate DIR", "Outputs CSV data extracted from 2018 property assessment reports"
    def consolidate(dir)
      Proptax::Consolidator.process(dir)
    end

#    desc "promos CSV_FILE", "Generate promotional fliers"
#    method_option *shared_options
#    def promos(dir)
#      `proptax consolidate #{dir} > consolidated.csv`
#      Proptax::Generators::Promo.start(['consolidated.csv', options])
#      generate_material("promos")
#    end
#
#    desc "reports CSV_FILE", "Generate assessment reports"
#    method_option *shared_options
#    method_option *report_options
#    method_option *consolidate_options
#    def reports(dir)
#      csv_file = 'consolidated.csv'
#      if options.consolidate?
#        `proptax consolidate #{dir} > #{csv_file}`
#      else
#        csv_file = "#{dir}/consolidated.csv"
#      end
#      Proptax::Generators::Report.start([csv_file, options])
#      generate_material("reports")
#    end
#
#    desc "auto DIR", "Automatically create CSV file and promotional fliers"
#    method_option *shared_options
#    method_option *report_options
#    def auto(dir)
#      `proptax consolidate #{dir} > consolidated.csv`
#      Proptax::Generators::Promo.start(['consolidated.csv', options])
#      Proptax::Generators::Report.start(['consolidated.csv', options])
#      generate_material("promos")
#      generate_material("reports")
#    end
#
#    desc "filter CSV_FILE", "Calculate and display assessment discrepancies"
#    method_option :csv,
#                    :type => :boolean,
#                    :default => false,
#                    :description => "Output in CSV format"
#    method_option :header,
#                    :type => :boolean,
#                    :default => true,
#                    :description => "Include header row in CSV format"
#    def filter(csv)
#      data_frame = `Rscript "#{__dir__}"/../R/filter_csv.R "#{csv}"`
#      if options[:csv]
#        lines = data_frame.split("\n")
#        # Print header
#        puts lines[0].squeeze(' ').split(' ').to_csv if options[:header]
#
#        # Print data (minus R-inserted integer row name) 
#        lines[1..-1].each do |line|
#          puts line.squeeze(' ').split(' ')[1..-1].to_csv
#        end
#      else
#        puts data_frame
#      end
#    end
#
#    no_commands do
#      def generate_material(dir)
#        Dir.foreach(dir) do |file|
#          if /\.Rmd/.match(file)
#            puts "#{file}" 
#            `cd "#{dir}" && Rscript -e "library('knitr'); knit('#{file}');"`
#            file.gsub!('.Rmd', '.md')
#            `cd "#{dir}" && Rscript -e "library('knitr'); pandoc('#{file}', format = 'latex');"`
#          end
#        end
#      end
#    end
  end
end
