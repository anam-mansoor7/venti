require 'digest/sha1'
require 'pry'

class Venti
	def initialize
		@block_size = 100
		@directory = 'venti'
    Dir.mkdir @directory unless File.directory?(@directory)
  end
  
  #TODO: remove default value of file name
  def vac(filename = nil)
  	data             = File.read('test.txt')
  	number_of_blocks = (data.size.to_f / 100).ceil
  	addresses        = []
  	
  	for block in 0...number_of_blocks 
  		istart = block * 100
      iend   = istart + 99  
      block_data = data[istart..iend]
  		addresses[block] = Digest::SHA1.digest block_data
  		write_block(addresses[block], block_data)
  	end 

  	length     = (addresses.size.to_f / 5).ceil


  end

  private

  def write_block(address, data)
  	encoded_address  = @directory + '/'+ addresses.encode('utf-8', 'iso-8859-15') + '.dat'
    #TODO: make the .dat file hidden and binary
		unless File.file?(filename)
  		File.open(encoded_address , "w+") do |file| 
  			file.write(block_data)
  		end
  	end
  end

  def write_blocks(data, length, range)
    for i in 0...length
  		istart      = i * range
      iend        = istart + range
      block_data  = data[istart...iend]
      address[block] = Digest::SHA1.digest block_data
      write_block(address[block], block_data)   
  	end
  end
end

v = Venti.new
v.vac
