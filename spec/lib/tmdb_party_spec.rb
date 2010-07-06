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
      
      TMDBParty::Base.new('key', 'sv').search('Transformers').should have(5).movies
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
      
      TMDBParty::Base.new('key', 'sv').imdb_lookup('tt0418279').should_not be_nil
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
      
      TMDBParty::Base.new('key', 'sv').get_info(1858).should_not be_nil
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
      
      TMDBParty::Base.new('key', 'sv').search_person('Megan Fox').should have(1).movie
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
      
      TMDBParty::Base.new('key', 'sv').get_person(19537).name.should == 'Megan Fox'
    end
  end
  
end