require 'spec_helper'

describe TMDBParty::Genre do
  let :genre do
    { "name" => "Action", "id" => 28, "url" => "http://www.themoviedb.org/genre/action" }
  end
  
  it "should have a name" do
    TMDBParty::Genre.new(genre).name.should == 'Action'
  end
  
  it "should have a url" do
    TMDBParty::Genre.new(genre).url.should == 'http://www.themoviedb.org/genre/action'
  end
  
  it "should have an id" do
    TMDBParty::Genre.new(genre).id.should == 28
  end
  
  it ".parse should return an array" do
    TMDBParty::Genre.parse(genre).should be_instance_of(Array)
    TMDBParty::Genre.parse(genre).first.should be_instance_of(TMDBParty::Genre)
  end
end