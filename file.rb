#Adapted from the Ruby Cookbook
class File
  def each_chunk(chunk_size= 100000)
    yield read(chunk_size) until eof?
  end
end

