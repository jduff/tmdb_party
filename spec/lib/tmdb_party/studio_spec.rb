require 'spec_helper'

describe TMDBParty::Studio do
  let :studio do
    { "name" => "Paramount Pictures", "url" => "http://www.themoviedb.org/company/4" }
  end
  
  it "should have a name" do
    TMDBParty::Studio.new(studio).name.should == 'Paramount Pictures'
  end
  
  it "should have a url" do
    TMDBParty::Studio.new(studio).url.should == 'http://www.themoviedb.org/company/4'
  end
  
  it ".parse should return an array" do
    TMDBParty::Studio.parse(studio).should be_instance_of(Array)
    TMDBParty::Studio.parse(studio).first.should be_instance_of(TMDBParty::Studio)
  end
end