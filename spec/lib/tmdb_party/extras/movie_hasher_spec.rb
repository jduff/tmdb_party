require 'spec_helper'

# Download the sample files from here:
# http://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes
# and uncomment these tests before making any changes
describe TMDBParty::MovieHasher do
  # Not sure the best way to have tests for this without having real files to work with.
  it "should compute hash" do
    pending
    File.open('breakdance.avi') do |file|
      TMDBParty::MovieHasher.compute_hash(file).should == "8e245d9679d31e12"
    end
  end

  it "should compute hash on large file" do
    pending
    File.open('dummy.bin') do |file|
      TMDBParty::MovieHasher.compute_hash(file).should == "61f7751fc2a72bfb"
    end
  end
end
