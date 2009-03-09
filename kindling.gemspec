Gem::Specification.new do |s|
  s.name = "kindling"
  s.version = "0.2.0"
  s.authors = ["Jonathan S. Katz"]
  s.email = 'jonathan.katz@excoventures.com'
  s.homepage = 'http://www.excoventures.com'
  s.platform = Gem::Platform::RUBY
  s.summary = "A Campfire API using the Nokogiri library"
  s.files = ["README.textile", "lib/kindling.rb"]
  s.require_path = "lib"
  s.add_dependency("nokogiri", ">= 1.2.1")
  s.autorequire
  s.has_rdoc = false
end
