name = "consul_syncer"
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require "#{name}/version"

Gem::Specification.new name, ConsulSyncer::VERSION do |s|
  s.summary = "Sync remote services into consul"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 2.1.0'
  s.add_runtime_dependency 'faraday'
end
