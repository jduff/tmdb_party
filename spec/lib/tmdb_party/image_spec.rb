require 'spec_helper'

describe TMDBParty::Image do
  let :single_image do
    {
      "image" => {
        "size" => "original", "url" => "http://images.themoviedb.org/backdrops/35222/Transformers_4.jpg", "type" => "backdrop", "id" => 35222
      }
    }
  end
  
  let :image_collection do
    [
      {
        "image" => {
          "size" => "original", "url" => "http://images.themoviedb.org/backdrops/35222/Transformers_4.jpg",        "type" => "backdrop", "id" => 35222
        }
      },
      {
        "image" => {
          "size" => "poster",   "url" => "http://images.themoviedb.org/backdrops/35222/Transformers_4_poster.jpg", "type" => "backdrop", "id" => 35222
        }
      },
      {
        "image" => {
          "size" => "thumb",    "url" => "http://images.themoviedb.org/backdrops/35222/Transformers_4_thumb.jpg",  "type" => "backdrop", "id" => 35222
        }
      },
    ]
  end
  
  it "should have an id" do
    TMDBParty::Image.parse(image_collection).first.id.should == 35222
  end
  
  it "should have a type" do
    TMDBParty::Image.parse(image_collection).first.type.should == :backdrop
  end
  
  it "should have a set of sizes" do
    TMDBParty::Image.parse(image_collection).first.sizes.should == [:original, :poster, :thumb].to_set
  end
  
  it "should have an url for all the sizes" do
    image = TMDBParty::Image.parse(image_collection).first
    
    image.original_url.should =~ /_4.jpg$/
    image.poster_url.should   =~ /_poster.jpg$/
    image.thumb_url.should    =~ /_thumb.jpg$/
  end
  
  it "should have nil urls for sizes which the image doesn't have" do
    image = TMDBParty::Image.parse(image_collection.reject { |img| img['image']['size'] == 'thumb' }).first
    
    image.thumb_url.should be_nil
  end
  
  it ".parse should merge images by id and return them as an array" do
    images = %w[original thumb].product([1, 2]).map do |size, id|
      { "image" => single_image['image'].merge('size' => size, 'url' => "/#{size}.jpg", 'id' => id) }
    end
    
    parsed = TMDBParty::Image.parse(images)
    
    parsed.should have(2).items
    parsed.first.should be_instance_of(TMDBParty::Image)
  end
  
end