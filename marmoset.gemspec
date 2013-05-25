Gem::Specification.new do |s|
  s.name        = 'marmoset'
  s.version     = '1.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jamie Wong']
  s.summary     = 'Submit to UW Marmoset from the command line'
  s.description = 'A utility using highline, mechanize and choice to submit to UW Marmoset from the command line'
  s.email       = ['jamie.lf.wong@gmail.com']
  s.homepage    = 'http://github.com/phleet/MarmosetSubmit'
  s.add_dependency 'highline',  '>= 1.6.1'
  s.add_dependency 'mechanize', '>= 1.0.0'
  s.add_dependency 'choice',    '>= 0.1.4'

  s.files               =  ['bin/marmoset']
  s.executables         =  ['marmoset'] 
end
