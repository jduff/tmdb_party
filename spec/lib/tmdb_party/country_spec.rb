require 'spec_helper'

describe TMDBParty::Country do
  let :country do
    { "code" => "US", "name" => "United States of America", "url" => "http://www.themoviedb.org/country/us" }
  end
  
  it "should have a code" do
    TMDBParty::Country.new(country).code.should == :us
  end
  
  it "should have a name" do
    TMDBParty::Country.new(country).name.should == 'United States of America'
  end
  
  it "should have a url" do
    TMDBParty::Country.new(country).url.should == 'http://www.themoviedb.org/country/us'
  end
  
  it ".parse should return an array" do
    TMDBParty::Country.parse(country).should be_instance_of(Array)
    TMDBParty::Country.parse(country).first.should be_instance_of(TMDBParty::Country)
  end
end