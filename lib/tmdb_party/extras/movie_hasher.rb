# MovieHasher based on the one found here:
# http://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes
#
# This will compute a unique hash for the movie that can be used for lookups on TMDB
# The algorithm calculates size + 64bit chksum of the first and last 64k (even if they overlap because the file is smaller than 128k).
# Make sure to uncomment and run the tests for this before making any changes
module TMDBParty
  module MovieHasher
    CHUNK_SIZE = 64 * 1024 # in bytes

    def self.compute_hash(file)
      filesize = file.size
      hash = filesize

      # Read 64 kbytes, divide up into 64 bits and add each
      # to hash. Do for beginning and end of file.
      # Q = unsigned long long = 64 bit
      file.read(CHUNK_SIZE).unpack("Q*").each do |n|
        hash = hash + n & 0xffffffffffffffff # to remain as 64 bit number
      end

      file.seek([0, filesize - CHUNK_SIZE].max, IO::SEEK_SET)

      # And again for the end of the file
      file.read(CHUNK_SIZE).unpack("Q*").each do |n|
        hash = hash + n & 0xffffffffffffffff
      end

      sprintf("%016x", hash)
    end
  end
end
