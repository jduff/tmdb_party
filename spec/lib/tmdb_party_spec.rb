require 'spec_helper'

describe TMDBParty::Base do
  it "should take an api key when initialized" do
    expect { TMDBParty::Base.new('key') }.to_not raise_error
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
    
    it "should populate score for all movies" do
      stub_get('/Movie.search/en/json/key/Transformers', 'search.json')
      tmdb.search('Transformers').map { |m| m.score }.should == [1.0, 0.292378753423691, 0.0227534640580416, 0.0150842536240816, 0.00380283431150019]
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
  end
  
  describe "#get_info" do
    it "should return a movie instance" do
      stub_get('/Movie.getInfo/en/json/key/1858', 'transformers.json')
      tmdb.get_info(1858).should be_instance_of(TMDBParty::Movie)
    end
  end
  
end