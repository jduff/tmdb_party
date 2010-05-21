require 'spec_helper'

describe TMDBParty::Person do
  let :person do
    HTTParty::Parser.call(fixture_file('megan_fox.json'), :json).first
  end
  
  let(:megan) { TMDBParty::Person.new(person, TMDBParty::Base.new('key')) }

  it "should have an id" do
    megan.id.should == 19537
  end

  it "should have a name" do
    megan.name.should == "Megan Fox"
  end

  it "should have a url" do
    megan.url.should == "http://www.themoviedb.org/person/19537"
  end
  
  it "should have a birthplace" do
    megan.birthplace.should == "Oakridge, TN"
  end
  
  it "should have a birthday" do
    megan.birthday.should == Date.new(1986, 5, 16)
  end

end