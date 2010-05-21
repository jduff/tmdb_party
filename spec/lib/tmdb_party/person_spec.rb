require 'spec_helper'

describe TMDBParty::Person do
  let :full_person do
    HTTParty::Parser.call(fixture_file('megan_fox.json'), :json).first
  end
  
  let :movie_cast do
    {
      "name" => "Megan Fox",
      "profile" => "http://images.themoviedb.org/profiles/598/meghan_thumb.jpg",
      "character" => "Mikaela Banes",
      "url" => "http://www.themoviedb.org/person/19537",
      "id" => "19537",
      "job" => "Actor"
    }
  end

  context "full" do
    let(:megan) { TMDBParty::Person.new(full_person) }
  
    it "should have an id" do
      megan.id.should == 19537
    end
  
    it "should have a name" do
      megan.name.should == "Megan Fox"
    end
  
    it "should have a url" do
      megan.url.should == "http://www.themoviedb.org/person/19537"
    end
  
  end

  context "from movie casts" do
    let(:megan) { TMDBParty::Person.new(movie_cast) }
    
    it "should have an id" do
      megan.id.should == 19537
    end
  
    it "should have a name" do
      megan.name.should == "Megan Fox"
    end
  
    it "should have a url" do
      megan.url.should == "http://www.themoviedb.org/person/19537"
    end
  
    it "should have a character name" do
      megan.character_name.should == "Mikaela Banes"
    end
  
    it "should have a image url" do
      megan.image_url.should == "http://images.themoviedb.org/profiles/598/meghan_thumb.jpg"
    end
    
    it "should have a job" do
      megan.job.should == 'Actor'
    end
  end
  
  it ".parse should return an array" do
    TMDBParty::Person.parse(full_person).should be_instance_of(Array)
    TMDBParty::Person.parse(full_person).first.should be_instance_of(TMDBParty::Person)
  end
  
end