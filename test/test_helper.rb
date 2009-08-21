require 'rubygems'
require 'test/unit'
require 'context'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tmdb_party'

class Test::Unit::TestCase
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end
 
def tmdb_url(url)
  url =~ /^http/ ? url : "http://api.themoviedb.org/2.0#{url}"
end
 
def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, tmdb_url(url), options)
end
 
def stub_post(url, filename)
  FakeWeb.register_uri(:post, tmdb_url(url), :string => fixture_file(filename))
end