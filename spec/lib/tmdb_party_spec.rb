require 'spec_helper'

describe TMDBParty::Base do
  it "should take an api key when initialized" do
    expect { TMDBParty::Base.new('key') }.to_not raise_error
  end
  
  it "should take an optional preferred language when initialized" do
    expect { TMDBParty::Base.new('key', 'sv') }.to_not raise_error
  end
  
  let :tmdb do
    TMDBParty::Base.new('key')
  end
  
  describe "#search" do
    it "should return an empty array when no matches was found" do
      stub_get('/Movie.search/en/json/key/NothingFound', 'nothing_found.json')
      tmdb.search('NothingFound').should == []
    end
    
    it "should return an array of movies" do
      stub_get('/Movie.search/en/json/key/Transformers', 'search.json')
      tmdb.search('Transformers').should have(5).movies
      tmdb.search('Transformers').first.should be_instance_of(TMDBParty::Movie)
    end
    
    it "should use the preferred language" do
      stub_get('/Movie.search/en/json/key/Transformers', 'shitty_shit_result.json')
      stub_get('/Movie.search/sv/json/key/Transformers', 'search.json')
      
      tmdb.search('Transformers', 'sv').should have(5).movies
    end
  end
  
  describe "#imdb_lookup" do
    it "should return nil when no movie could be found" do
      stub_get('/Movie.imdbLookup/en/json/key/tt0418279dd', 'imdb_no_results.json')
      tmdb.imdb_lookup('tt0418279dd').should be_nil
    end
    
    it "should return a single movie when found" do
      stub_get('/Movie.imdbLookup/en/json/key/tt0418279', 'imdb_search.json')
      tmdb.imdb_lookup('tt0418279').should be_instance_of(TMDBParty::Movie)
    end
    
    it "should use the preferred language" do
      stub_get('/Movie.imdbLookup/en/json/key/tt0418279', 'shitty_shit_result.json')
      stub_get('/Movie.imdbLookup/sv/json/key/tt0418279', 'imdb_search.json')
      
      tmdb.imdb_lookup('tt0418279', 'sv').should_not be_nil
    end
  end
  
  describe "#get_info" do
    it "should return a movie instance" do
      stub_get('/Movie.getInfo/en/json/key/1858', 'transformers.json')
      tmdb.get_info(1858).should be_instance_of(TMDBParty::Movie)
    end
    
    it "should use the preferred language" do
      stub_get('/Movie.getInfo/en/json/key/1858', 'shitty_shit_result.json')
      stub_get('/Movie.getInfo/sv/json/key/1858', 'transformers.json')
      
      tmdb.get_info(1858, 'sv').should_not be_nil
    end
  end

  describe "#get_info with file" do
    it "should return a movie instance" do
      file = mock("file")
      file.should_receive(:size).and_return(742086656)
      TMDBParty::MovieHasher.should_receive(:compute_hash).with(file).and_return("907172e7fe51ba57")
      stub_get('/Media.getInfo/en/json/key/907172e7fe51ba57/742086656', 'transformers.json')
      tmdb.get_file_info(file).should have(1).movies
    end

    it "should return empty array when no movie found" do
      file = mock("file")
      file.should_receive(:size).and_return("fake")
      TMDBParty::MovieHasher.should_receive(:compute_hash).with(file).and_return("fake")
      stub_get('/Media.getInfo/en/json/key/fake/fake', 'nothing_found.json')
      tmdb.get_file_info(file).should == []
    end
  end
  
  describe "#search_person" do
    it "should return empty array when no people was found" do
      stub_get('/Person.search/en/json/key/Megatron%20Fox', 'nothing_found.json')
      tmdb.search_person('Megatron Fox').should be_empty
    end
    
    it "should return instances of Person" do
      stub_get('/Person.search/en/json/key/Megan%20Fox', 'search_person.json')
      tmdb.search_person('Megan Fox').should have(1).person
      tmdb.search_person('Megan Fox').first.should be_instance_of(TMDBParty::Person)
    end
    
    it "should use the preferred language" do
      stub_get('/Person.search/en/json/key/Megan%20Fox', 'shitty_shit_result.json')
      stub_get('/Person.search/sv/json/key/Megan%20Fox', 'search_person.json')
      
      tmdb.search_person('Megan Fox', 'sv').should have(1).movie
    end
  end
  
  describe "#get_person" do
    it "should return a person instance" do
      stub_get('/Person.getInfo/en/json/key/19537', 'megan_fox.json')
      tmdb.get_person(19537).should be_instance_of(TMDBParty::Person)
    end
    
    it "should use the preferred language" do
      stub_get('/Person.getInfo/en/json/key/19537', 'shitty_shit_result.json')
      stub_get('/Person.getInfo/sv/json/key/19537', 'megan_fox.json')
      
      tmdb.get_person(19537, 'sv').name.should == 'Megan Fox'
    end
  end
  
  describe "#get_genres" do
    it "should return instances of Genre" do
      stub_get('/Genres.getList/en/json/key', 'genres_results.json')
      tmdb.get_genres.should have(33).genre
      tmdb.get_genres.first.should be_instance_of(TMDBParty::Genre)
    end
    
    it "should use the preferred language" do
      stub_get('/Genres.getList/en/json/key', 'shitty_shit_result.json')
      stub_get('/Genres.getList/sv/json/key', 'genres_results.json')
      
      tmdb.get_genres('sv').first.name.should == 'Action'
    end
  end


  describe "#browse" do
    it "should return an empty array when no matches was found" do
      stub_get('/Movie.browse/en/json/key?order=asc&order_by=title&query=NothingFound', 'nothing_found.json')

      tmdb.browse(:query => 'NothingFound').should == []
    end

    it "should return an array of movies" do
      stub_get('/Movie.browse/en/json/key?order=asc&order_by=title&query=Transformers', 'browse.json')

      tmdb.browse(:query => 'Transformers').should have(12).movies
      tmdb.browse(:query => 'Transformers').first.should be_instance_of(TMDBParty::Movie)
    end

    it "should use the preferred language" do
      stub_get('/Movie.browse/en/json/key?order=asc&order_by=title&query=Transformers', 'shitty_shit_result.json')
      stub_get('/Movie.browse/sv/json/key?order=asc&order_by=title&query=Transformers', 'browse.json')

      tmdb.browse({:query => 'Transformers'}, 'sv').should have(12).movies
    end
  end
end
