require 'bundler/setup'
require 'rspec'
require 'fakeweb'
require 'pry'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'tmdb_party'

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end
 
def tmdb_url(url)
  url =~ /^http/ ? url : "http://api.themoviedb.org/2.1#{url}"
end
 
def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, tmdb_url(url), options)
end
