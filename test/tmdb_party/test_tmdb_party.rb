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

  test "getting a single result" do
    stub_get('/Movie.search?api_key=key&title=sweeney%20todd', 'single_result.xml')
    
    results = @tmdb.search('sweeney todd')
    
    assert_equal 1, results.length
    
    sweeney_todd = results.first
    
    assert_equal 'tt0408236', sweeney_todd.imdb
  end



  test "finding transformers via imdb id" do
    stub_get('/Movie.imdbLookup?api_key=key&imdb_id=tt0418279', 'imdb_search.xml')
    stub_get('/Movie.getInfo?api_key=key&id=1858', 'transformers.xml')
    
    result = @tmdb.imdb_lookup('tt0418279')
  
    # check that the attributes are populated
    assert_equal 52.0, result.popularity
    assert_equal 1.0, result.score
    assert_equal 1858, result.id
    assert_equal 'tt0418279', result.imdb
    assert_equal Date.new(2007, 7, 4), result.release
    assert result.poster.first.is_a?(TMDBParty::Image)
    assert result.backdrop.first.is_a?(TMDBParty::Image)
  
    # how about some that are loaded lazily
    assert_equal "http://www.transformersmovie.com/", result.homepage
    assert_equal "http://www.youtube.com/watch?v=eduwcuq1Exg", result.trailer.url
    
    assert_equal 9, result.categories.length
    
    category = result.categories.detect{|cat| cat.name == "Adventure Film"}
    assert_equal "http://www.themoviedb.org/encyclopedia/category/12", category.url
  end

  test "NOT finding transformers via imdb id" do
    stub_get('/Movie.imdbLookup?api_key=key&imdb_id=tt0418279dd', 'imdb_no_results.xml')
    result = @tmdb.imdb_lookup('tt0418279dd')
    assert_nil result
  end

end
