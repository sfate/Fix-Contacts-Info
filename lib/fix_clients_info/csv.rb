module FixClientsInfo
  class Csv

    def initialize(options={})
      raise ArgumentError, "No file specified" if options.empty?
      @csv_filepath = options[:file]
    end

    def parse
      #TODO: grab each row and process it
    end

    def show_row(row_number)
      raise TypeError, "Only integer value acceptable" unless row_number.class.eql? Fixnum
      current_row = @csv_file[row_number]
      if current_row.nil?
        current_row = "No such row in CSV file"
      else
        unless row_number.eql? 0
          hash_array = []
          header_row = @csv_file[0]
          (header_row.size-1).times do |i|
            hash_array.push([header_row[i], current_row[i]])
          end
          current_row = Hash[hash_array]
        end
      end
      current_row
    end

    def read
      # read all csv file and send state
      @csv_file = CSV.read(@csv_filepath, :encoding => 'windows-1251:utf-8') ; true
    end

  end
end

