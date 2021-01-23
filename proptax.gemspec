# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "proptax/version"

Gem::Specification.new do |spec|
  spec.name          = "proptax"
  spec.version       = Proptax::VERSION
  spec.authors       = ["Daniel Bidulock"]
  spec.email         = ["daniel@capitolhill.ca"]

  spec.summary       = %q{Automatically process and visualize residential property data collected by the City of Calgary in 2021.}
  spec.description   = %q{This software produces reports from property data collected and provided by the City of Calgary. The versions used in previous years have won three victories before Calgary's Assessment Review Board, the quasi-judicial body that rules on property tax appeals.}
  spec.homepage      = "https://github.com/TaxReformYYC/report-generator-2021"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
#  else
#    raise "RubyGems 2.0 or newer is required to protect against " \
#      "public gem pushes."
#  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "aruba", "~> 0.14.3"

  spec.add_dependency "thor"
end
