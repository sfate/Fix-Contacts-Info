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

    def create(options)
      raise ArgumentError, "No header row specified" if ( options[:header].nil? )
      build_header
      @csv_new_file = CSV.open(@csv_output_path, 'w')
      @csv_new_file << @csv_new_header #options[:header]
      # @csv_new_header = @csv_new_file[0]
      true
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

    def fix_n_create(options={})
      create(options)
      @csv_loaded_file.size.times do |i|
        ## break for a quick lib work check
        ## break if i.eql? 10
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

        hash_notes = {}
        unless current_row["Notes"].nil?
          #main parse code will be there
               notes = current_row["Notes"].split("\r\n")
          notes.each do |note|
            note = note.split(": ")
            next if note.empty?
            # i'll be punished for that asap..
            note[0] = "E-mail Address" if note.first.include? "Email Address"
            hash_notes[note.first.strip] = note.last.strip
          end
        end

        # main evil concentration is here.. below..
        hash_notes.each do |note, value|
          unless (value.nil?)
            # if e-mail happenz and we have already email then write it to email 2 field.. otherwise write directly to email field
            if(note == "E-mail Address" && not(current_row[note].nil? || (current_row[note].include? "empt")))
              current_row["E-mail 2 Address"] = value
            elsif(note == "Zip")
              current_row["ZIP Code"] = value
            elsif(note == "Address 1")
              current_row["Street 1"] = value
            else
              current_row[note] = value
            end
          end
        end

        # add each row to new file
        full_row = []
        current_row.each do |key, value|
          next if key.nil?
          # find coinciding key in row to index in header and write it to full row info
          begin
            full_row[@csv_new_header.find_index(key)] = value
          rescue
            full_row << value
          end
        end
        @csv_new_file << full_row
        puts i
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
      arr << "Street 1"
      arr << "City"
      arr << "State"
      arr << "ZIP Code"
      arr << "Country"
      arr << "Phone"
      arr << "Principal Business"
      arr << "Primary Job Function"
      arr << "Buying Influence"
      arr << "Number of Employees"
      arr << "Annual Sales Volume"
      arr << "Web Site"
      @csv_new_header = arr
    end

    private :file?, :build_header, :create

  end
end

