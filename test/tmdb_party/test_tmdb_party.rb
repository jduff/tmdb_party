require File.dirname(__FILE__) + '/../test_helper'

class TestTmdbParty < Test::Unit::TestCase
  
  before do
    @tmdb = TMDBParty::Base.new('key')
  end
  
  after do
    FakeWeb.clean_registry
  end
  
  test "searching for transformers" do
    stub_get('/Movie.search/en/json/key/Transformers', 'search.json')
    stub_get('/Movie.getInfo/en/json/key/1858', 'transformers.json')
    
    results = @tmdb.search('Transformers')
    
    assert_equal 5, results.length
    
    transformers = results.detect{|m| m.name == "Transformers"}
    
    # check that the attributes are populated
    assert_equal 52, transformers.popularity
    assert_equal 1.0, transformers.score
    assert_equal 1858, transformers.id
    assert_equal 'tt0418279', transformers.imdb_id
    assert_equal Date.new(2007, 7, 4), transformers.released

    # assert transformers.poster.first.is_a?(TMDBParty::Image)
    # assert transformers.backdrop.first.is_a?(TMDBParty::Image)
    # 
    # how about some that are loaded lazily
    assert_equal "http://www.transformersmovie.com/", transformers.homepage
    assert_equal "http://www.youtube.com/watch?v=c0PXr8GV2_Q", transformers.trailer
    
    assert_equal 3, transformers.genres.length
    
    genre = transformers.genres.detect{|g| g.name == "Adventure"}
    assert_equal "http://themoviedb.org/encyclopedia/category/12", genre.url
    
    assert_equal 132, transformers.runtime
    assert_equal 36, transformers.cast.length
      
  end
  
  test "getting a single result" do
    stub_get('/Movie.search/en/json/key/sweeney%20todd', 'single_result.json')
    
    results = @tmdb.search('sweeney todd')
    sweeney_todd = results.first
    
    assert_equal 1, results.length
    assert_equal 'tt0408236', sweeney_todd.imdb_id
  end

  test "finding transformers via imdb id" do
    stub_get('/Movie.imdbLookup/en/json/key/tt0418279', 'imdb_search.json')
    stub_get('/Movie.getInfo/en/json/key/1858', 'transformers.json')
    
    
    result = @tmdb.imdb_lookup('tt0418279')
  
    # check that the attributes are populated
    assert_equal 52.0, result.popularity
    assert_equal 1858, result.id
    assert_equal 'tt0418279', result.imdb_id
    assert_equal Date.new(2007, 7, 4), result.released
    # assert result.poster.first.is_a?(TMDBParty::Image)
    # assert result.backdrop.first.is_a?(TMDBParty::Image)
    #   
    # how about some that are loaded lazily
    assert_equal "http://www.transformersmovie.com/", result.homepage
    assert_equal "http://www.youtube.com/watch?v=c0PXr8GV2_Q", result.trailer
    
    assert_equal 3, result.genres.length
    
    genre = result.genres.detect{|g| g.name == "Adventure"}
    assert_equal "http://themoviedb.org/encyclopedia/category/12", genre.url
    
    assert_equal 132, result.runtime
    assert_equal 36, result.cast.length
  end

  test "NOT finding transformers via imdb id" do
    stub_get('/Movie.imdbLookup/en/json/key/tt0418279dd', 'imdb_no_results.json')
    result = @tmdb.imdb_lookup('tt0418279dd')
    assert_nil result
  end
  
  test "no people found" do
    stub_get('/Movie.search/en/json/key/rad', 'rad.json')
    stub_get('/Movie.getInfo/en/json/key/13841', 'no_groups.json')
  
    rad = @tmdb.search('rad').first
    
    assert_equal [], rad.cast
    assert_equal [], rad.genres
    
    assert_equal 0, rad.directors.length
    assert_equal 0, rad.writers.length
    assert_equal 0, rad.actors.length
  end
  
  # test "specific people" do
  #   stub_get('/Movie.imdbLookup?api_key=key&imdb_id=tt0418279', 'imdb_search.xml')
  #   stub_get('/Movie.getInfo?api_key=key&id=1858', 'transformers.xml')
  # 
  #   result = @tmdb.imdb_lookup('tt0418279')
  #   
  #   assert_equal 1, result.directors.length
  #   assert_equal 1, result.writers.length
  #   assert_equal 17, result.actors.length
  # end
  # 
  # test "single groups" do
  #   stub_get('/Movie.imdbLookup?api_key=key&imdb_id=tt0418279', 'imdb_search.xml')
  #   stub_get('/Movie.getInfo?api_key=key&id=1858', 'single_groups.xml')
  # 
  #   result = @tmdb.imdb_lookup('tt0418279')
  # 
  #   assert_equal Array, result.people.class
  #   assert_equal Array, result.categories.class
  # end

end
