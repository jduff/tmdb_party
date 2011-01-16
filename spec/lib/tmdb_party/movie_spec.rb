require 'spec_helper'
require 'httparty'

describe TMDBParty::Movie do
  before(:each) do
    stub_get('/Movie.getInfo/en/json/key/1858', 'transformers.json')
  end
  
  let :transformers do
    HTTParty::Parser.call(fixture_file('transformers.json'), :json).first
  end
  
  let :transformers_movie do
    TMDBParty::Movie.new(transformers, TMDBParty::Base.new('key'))
  end
  
  it "should take an attributes hash and a TMDBParty::Base instance when initialized" do
    expect { TMDBParty::Movie.new({}, TMDBParty::Base.new('key')) }.to_not raise_error
  end
  
  describe "attributes" do
    it "should have a score when coming from search results" do
      TMDBParty::Movie.new({'score' => '0.374527342'}, TMDBParty::Base.new('key')).score.should == 0.374527342
    end
    
    [:posters, :backdrops, :homepage, :trailer, :runtime, :genres, :cast, :countries, :tagline, :studios].each do |attribute|
      it "should load #{attribute} attribute by looking up the movie if it is missing" do
        movie = TMDBParty::Movie.new({ 'id' => 1858 }, TMDBParty::Base.new('key'))
        movie.send(attribute).should_not be_nil
      end
    
      it "should not look up the movie when #{attribute} is not missing" do
        tmdb = mock(TMDBParty::Base)
        movie = TMDBParty::Movie.new({ 'id' => 1858, attribute.to_s => transformers[attribute.to_s] }, tmdb)
        
        tmdb.should_not_receive(:get_info)
        movie.send(attribute)
      end
    end
    
    it "should have a release date" do
      transformers_movie.released.should == Date.new(2007, 7, 4)
    end
    
    it "should have a translated? attribute" do
      transformers_movie.should be_translated
    end
    
    it "should have a language" do
      transformers_movie.language.should == :en
    end
    
    it "should have a tagline" do
      transformers_movie.tagline.should == "Their war. Our world."
    end
    
    it "should have a certification" do
      transformers_movie.certification.should == "PG-13"
    end
    
    it "should have a last modified at timestamp" do
      transformers_movie.last_modified_at.should == Time.parse('Sat Jan 15 02:02:30 -0500 2011')
    end
    
    it "should have a cast" do
      transformers_movie.cast.should have(36).members
      transformers_movie.cast.first.should be_instance_of(TMDBParty::CastMember)
    end
    
    it "should have a list of directors" do
      transformers_movie.directors.map { |p| p.name }.should == ['Michael Bay']
    end
    
    it "should have a list of actors" do
      transformers_movie.should have(17).actors
    end
    
    it "should have a list of writers" do
      transformers_movie.should have(3).writers
    end
    
    it "should have a list of poster images" do
      transformers_movie.should have(18).posters
      poster = transformers_movie.posters.first
      poster.sizes.should include(:cover, :thumb, :mid, :original)
    end
    
    it "should have a list of backdrop images" do
      transformers_movie.should have(13).backdrops
      backdrop = transformers_movie.backdrops.first
      backdrop.sizes.should include(:thumb, :poster, :original)
    end
    
    it "should have a list of genres" do
      transformers_movie.should have(3).genres
      transformers_movie.genres.map { |g| g.name }.should include('Action', 'Thriller', 'Science Fiction')
    end
    
    it "should have a list of countries" do
      transformers_movie.should have(1).countries
      transformers_movie.countries.first.url.should == 'http://www.themoviedb.org/country/us'
    end
    
    it "should have a list of studios" do
      transformers_movie.should have(1).studios
      transformers_movie.studios.first.name.should == 'DreamWorks SKG'
    end
  end
  
end
