Gem::Specification.new do |s|
  s.name = "fix_clients_info"
  s.version = "0.1.1"
  s.summary = "CSV clients fixer"
  s.description = "Simple lib for a contact sorting info"

  s.author = "Alex Mercer"
  s.email = "alexey.bobyrev@gmail.com"
  s.homepage = "http://evil4live@wordpress.com"

  s.add_development_dependency 'csv'
  s.files = ['lib/fix_clients_info.rb'] + Dir.glob('lib/fix_clients_info/*.rb')
end
