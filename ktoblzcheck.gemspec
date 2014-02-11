# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name           = "ktoblzcheck"
  spec.version        = "1.44.0.beta"
  spec.authors        = ["Sascha Loetz", "Kim Rudolph", "Dominik Menke"]
  spec.email          = ["kim.rudolph@web.de", "dom@digineo.de"]
  spec.description    =
  spec.summary        = %q{ktoblzcheck is an interface for libktoblzcheck, a library to check German account numbers and bank codes. See http://ktoblzcheck.sourceforge.net for details.}
  spec.homepage       = "http://github.com/dmke/ktoblzcheck"
  spec.license        = "GPL"

  spec.files          = `git ls-files`.split($/)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["ext", "lib"]
  spec.extensions     = ["ext/ktoblzcheck/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
