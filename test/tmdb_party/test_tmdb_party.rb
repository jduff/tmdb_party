require File.dirname(__FILE__) + '/../test_helper'

class TestTmdbParty < Test::Unit::TestCase
  
  before do
    @tmdb = TMDBParty::Base.new('key')
  end
  
  after do
    FakeWeb.clean_registry
  end
  
  test "searching for transformers" do
    stub_get('/Movie.search?api_key=key&title=transformers', 'search.xml')
    stub_get('/Movie.getInfo?api_key=key&id=1858', 'transformers.xml')
    
    results = @tmdb.search('transformers')
    
    assert_equal 5, results.length
    
    transformers = results.detect{|m| m.title == "Transformers"}
    
    # check that the attributes are populated
    assert_equal 31, transformers.popularity
    assert_equal 1.0, transformers.score
    assert_equal 1858, transformers.id
    assert_equal 'tt0418279', transformers.imdb
    assert_equal Date.new(2007, 7, 4), transformers.release
    assert transformers.poster.first.is_a?(TMDBParty::Image)
    assert transformers.backdrop.first.is_a?(TMDBParty::Image)
    
    # how about some that are loaded lazily
    assert_equal "http://www.transformersmovie.com/", transformers.homepage
    assert_equal "http://www.youtube.com/watch?v=eduwcuq1Exg", transformers.trailer.url
    
    assert_equal 9, transformers.categories.length
    
    category = transformers.categories.detect{|cat| cat.name == "Adventure Film"}
    assert_equal "http://www.themoviedb.org/encyclopedia/category/12", category.url
  end
end
