Gem::Specification.new do |s|
  s.name = 'http.rb' # I would have preferred 'http', but there's a library called http.rb with the gem name of http.  Confusing, eh?
  s.version = '0.12.1'
  s.date = '2025-02-07'

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
