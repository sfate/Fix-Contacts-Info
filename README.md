# Fix Clients Info

Simple lib that allow's to fix structure of contacts,
which was exported to csv file.

## HowTo Use
> Да и к чему слова, когда на небе звезды?
> -- В.Пелевин

* The code below will ask on questions howto use that:

     ```Ruby
     # load lib
     require 'fix_clients_info'
     # create an instance with file need to be fixed
     csv_clients = FixClientsInfo::Csv.new(:input => "/path/to/file.csv", :output => "/path/to/file.csv")
     # read it
     csv_clients.read
     # get a csv line by line number (integer value)
     # zero row is taken as header
     # e.g.: to get first row type:
     csv_clients.show_row(1)

     # create new csv file with specified header row
     csv_clients.fix_n_create(:header => ['First column', ...])
     # write file
     csv_clients.write_output
     ```

## TODO:

* [+] exceptions handler
* [+] full file parser
* [+] logic of data fix
* [+] test

## Version: 0.1.2 (30 march 2012)

