require 'spec_helper'

describe TMDBParty::CastMember do
  let :cast_member do
    {
      "name" => "Megan Fox",
      "profile" => "http://images.themoviedb.org/profiles/598/meghan_thumb.jpg",
      "character" => "Mikaela Banes",
      "url" => "http://www.themoviedb.org/person/19537",
      "id" => "19537",
      "job" => "Actor"
    }
  end

  let(:megan) { TMDBParty::CastMember.new(cast_member, TMDBParty::Base.new('key')) }
  
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
  
  it "should have a person" do
    stub_get('/Person.getInfo/en/json/key/19537', 'megan_fox.json')
    megan.person.should be_instance_of(TMDBParty::Person)
  end

  it ".parse should return an array" do
    tmdb = TMDBParty::Base.new('key')
    TMDBParty::CastMember.parse(cast_member, tmdb).should be_instance_of(Array)
    TMDBParty::CastMember.parse(cast_member, tmdb).first.should be_instance_of(TMDBParty::CastMember)
  end
  
end