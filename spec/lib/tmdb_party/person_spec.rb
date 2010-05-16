require 'spec_helper'

describe TMDBParty::Person do
  let :person do
    {
      "name" => "Megan Fox",
      "profile" => "http://images.themoviedb.org/profiles/598/meghan_thumb.jpg",
      "character" => "Mikaela Banes",
      "url" => "http://www.themoviedb.org/person/19537",
      "id" => "19537",
      "job" => "Actor"
    }
  end
  
  let(:megan) { TMDBParty::Person.new(person) }
  
  it "should have a name" do
    megan.name.should == "Megan Fox"
  end
  
  it "should have a url" do
    megan.url.should == "http://www.themoviedb.org/person/19537"
  end
  
  it "should have a job" do
    megan.job.should == 'Actor'
  end
  
  it ".parse should return an array" do
    TMDBParty::Person.parse(person).should be_instance_of(Array)
    TMDBParty::Person.parse(person).first.should be_instance_of(TMDBParty::Person)
  end
  
end