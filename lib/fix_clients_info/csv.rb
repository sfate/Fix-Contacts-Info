module FixClientsInfo
  class Csv

    def initialize(options={})
      raise ArgumentError, "No files specified" unless (file?(options[:input]) || options[:output].blank?)
       @csv_input_path = options[:input]
      @csv_output_path = options[:output]
    end

    def read
      # read all csv file and send state
      @csv_loaded_file   = CSV.read(@csv_input_path, :encoding => 'windows-1251:utf-8')
      @csv_loaded_header = @csv_loaded_file[0].delete_if(&:nil?) ; true
    end

    def create(options={})
      raise ArgumentError, "No header row specified" if ( options[:header].nil? )
      @csv_new_file = CSV.open(@csv_output_path)
      @csv_new_file << options[:header]
      @csv_new_header = @csv_new_file[0]
      build_header ; true
    end

    def show_row(row_number)
      raise TypeError, "Only integer value acceptable" unless row_number.class.eql? Fixnum
      current_row = @csv_loaded_file[row_number]
      if current_row.nil?
        current_row = "No such row in CSV file"
      else
        unless row_number.eql? 0
          hash_array = []
          (@csv_loaded_header.size).times do |i|
            i=i+1
            next if(i.eql? @csv_loaded_header.size)
            hash_array.push([@csv_loaded_header[i], current_row[i]])
          end
          current_row = Hash[hash_array]
        end
      end
      current_row
    end

    def fix_n_create
      build_header
      @csv_loaded_file.size.times do |i|
        # dirty hack to skip first element
        i=i+1
        next if(i.eql? @csv_loaded_file.size)

        # get row
        current_row = show_row(i)

        # fill it with additional keys
        @csv_new_header.each do |field|
          # horrible times.. horrible code..
          current_row[field] = nil if current_row[field].nil?
        end

        unless current_row["Notes"].nil?
          #main parse code will be there
          hash_notes = {}
               notes = current_row["Notes"].split("\r\n")
          notes.each do |note|
            note = note.split(": ")
            # i'll be punished for that asap..
            note.first = "E-mail Address" if note.first.include? "Email Address"
            hash_notes[note.first] = note.last
          end
        end

        # main evil concentration is here.. below..
        hash_notes.each do |note, value|
          unless (value.nil?)
            # if e-mail happenz and we have already email then write it to email 2 field.. otherwise write directly to email field
            if(value == "E-mail Address" && not(current_row[value].nil? || current_row[value].include? "empt"))
              current_row["E-mail 2 Address"] = value
            else
              current_row[note] = value
            end
          end
        end

        # add each row to new file
        full_row = []
        current_row.each do |key, value|
          # find coinciding key in row to index in header and write it to full row info
          full_row[@csv_new_header.find_index(key)] = value
        end
        @csv_new_file << full_row
      end
    end

    def write_output
      raise NoMethodError, "Nothing to save. No opened file to write." if @csv_new_file.nil?
      # write csv object into file
      @csv_new_file.close
      @csv_new_file   = nil
      @csv_new_header = nil
      "Written into: #{@csv_output_path}"
    end

    def file?(file)
      File.file? file
    end

    def build_header
      arr = @csv_loaded_header.clone
      arr << "Street"
      arr << "City"
      arr << "State"
      arr << "ZipCode"
      arr << "Country"
      arr << "Phone"
      arr << "Principal Business"
      arr << "Primary Job Function"
      arr << "Buying Influence"
      arr << "Number of Employees"
      arr << "Annual Sales Volume"
      @csv_new_header = arr
    end

    private :file?, :build_header

  end
end

