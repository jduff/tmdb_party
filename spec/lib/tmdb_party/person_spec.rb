require 'spec_helper'

describe TMDBParty::Person do
  let :person do
    HTTParty::Parser.call(fixture_file('megan_fox.json'), :json).first
  end
  
  let(:megan) { TMDBParty::Person.new(person) }

  it "should have an id" do
    megan.id.should == 19537
  end

  it "should have a name" do
    megan.name.should == "Megan Fox"
  end

  it "should have a url" do
    megan.url.should == "http://www.themoviedb.org/person/19537"
  end

  it ".parse should return an array" do
    TMDBParty::Person.parse(person).should be_instance_of(Array)
    TMDBParty::Person.parse(person).first.should be_instance_of(TMDBParty::Person)
  end
  
end