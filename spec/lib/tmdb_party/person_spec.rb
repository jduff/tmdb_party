require 'spec_helper'

describe TMDBParty::Person do
  let :person do
    HTTParty::Parser.call(fixture_file('megan_fox.json'), :json).first
  end
  
  let(:megan) { TMDBParty::Person.new(person, TMDBParty::Base.new('key')) }

  it "should have a score when coming from search results" do
    TMDBParty::Person.new({'score' => '0.374527342'}, TMDBParty::Base.new('key')).score.should == 0.374527342
  end
  
  it "should have an id" do
    megan.id.should == 19537
  end

  it "should have a name" do
    megan.name.should == "Megan Fox"
  end
  
  it "should have a popularity" do
    megan.popularity.should == 3
  end

  it "should have a url" do
    megan.url.should == "http://www.themoviedb.org/person/19537"
  end
  
  it "should have a biography" do
    megan.biography.should be_a(String)
  end
  
  it "should have a birthplace" do
    megan.birthplace.should == "Oakridge, TN"
  end
  
  it "should have a birthday" do
    megan.birthday.should == Date.new(1986, 5, 16)
  end
  
  describe "biography" do
    it "should have proper newlines" do
      megan.biography.should include("\n")
    end
    
    it "should properly get HTML tags" do
      # HTTParty does not parse the encoded hexadecimal properly. It does not consider 000F to be a hex, but 000f is
      megan.biography.should include("<b>Career</b>")
    end
  end

end