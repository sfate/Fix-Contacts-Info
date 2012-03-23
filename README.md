# Fix Clients Info

Simple lib that allow's to fix structure of contacts,
which was exported to csv file.

## HowTo Use
> Да и к чему слова, когда на небе звезды?
> -- В.Пелевин

The code below will ask on questions howto use that:

     ```Ruby
     # load lib
     require 'fix_clients_info'

     # create an instance with file need to be fixed
     csv_clients = FixClientsInfo::Csv.new(:file => "/path/to/file.csv")

     # read it
     csv_clients.read

     # get a first csv line
     csv_clients.show_first_row
     ```

## TODO:

* [+] exceptions handler
* [+] full file parser
* [+] logic of data fix
* [+] test

## Version: 0.1.alpha (22 march 2012)

