Gem::Specification.new do |s|
  s.name = 'HTTP.rb'
  s.version = '0.13.0'
  s.date = '2025-03-04'

  s.summary = "HTTP made easy."
  s.description = "HTTP is the simplest HTTP mezzanine library for Ruby.  Supply a URI, \
    some optional query arguments, some optional headers, and some \
    Net::HTTP options, and that's it!"
  s.author = 'thoran'
  s.email = 'code@thoran.com'
  s.homepage = "http://github.com/thoran/HTTP"

  s.files = [
    'Gemfile',
    'README.md',
    'http.rb.gemspec',
    Dir['lib/**/*.rb'],
    Dir['spec/**/*.rb']
  ].flatten

  s.require_paths = ['lib']

  s.has_rdoc = false
end
