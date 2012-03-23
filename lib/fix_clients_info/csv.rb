module FixClientsInfo
  class Csv

    def initialize(options={})
      raise ArgumentError, "No file specified" if options.empty?
      @csv_filepath = options[:file]
    end

    def parse
      #TODO: grab each row and process it
    end

    def show_first_row
      first_row = nil
      @csv_file.each do |row|
        first_row = row
        break
      end
      first_row
    end

    def read
      # read all csv file and send state
      @csv_file = CSV.read(@csv_filepath, :encoding => 'windows-1251:utf-8')
      true
    end

  end
end

