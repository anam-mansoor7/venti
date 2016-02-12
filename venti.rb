require 'digest/sha1'
#require 'pry'
require "base32"
require_relative "file"

class Venti
  def initialize(directory = 'venti')
    @block_size = 100
    @directory = directory
    Dir.mkdir @directory unless File.directory?(@directory)
  end
  
  #TODO: remove default value of file name
  def vac(filename)
    if File.file?(filename)
      puts 'vac in progress ...'
      data = File.read(filename)
      address_list = []

      File.open(filename,'rb') do |f|
        f.each_chunk(10000) do |c| 
          address_list += write_blocks(c, 100)
        end
      end

      #TODO: further investigate the condition whether to set address_list to nil on the first step?
      while address_list.size != 1 do
        address_list = write_blocks(address_list, 5)	
      end

      vacfile = filename.chomp(File.extname(filename)) + ".vac"

      #convert the hash to bin before writing
      file_details = {name: filename, size: data.size, address: address_list.first, directory: @directory}

      File.open(vacfile , "wb") do |file| 
        file.write(Marshal.dump(file_details))
      end 

      puts "vac completed successfully"
    else
      puts "Error #{filename} does not exist" 
    end
  end

  def unvac(file_details)
    puts 'unvac in progress ...'

    #file_details = File.read(filename).gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2}}.reduce(:merge)
    #contents = File.read(file)
    file_date = traverse(file_details[:address], file_details[:name])
    
    # File.open(file_details[:name], "w+") do |file| 
    #   file.write(file_date)
    # end

    puts "unvac completed successfully"
  end

  private

  def traverse(node, filename)
    file_data = ""
    q = [] 
    q << node
    
    open(filename, 'a') do |f|
      while !q.empty?
        score = q.shift
        node = read_block(score)
        if node.nil?
          #file_data += score
            f << score
        else  
          children = node.chars.each_slice(20).map(&:join)
          children.each do |c|
            q << c
          end
        end
      end
    end
    #file_data
  end

  def file_path(hash)
    @directory + '/' + Base32.encode(hash) + '.dat'
  end

  def read_block(address)
    file = file_path(address)
    contents = nil
    if File.file?(file)
      File.open(file, "rb") do |file| 
        contents = file.read
      end
    end   
    contents
  end   
  #range = 5 for pointer blks and 100 for data blks
  #type = 0 for pointer blks and 1 for data blks
  def write_blocks(data, range)
    address_list = []
    length       = (data.size.to_f / range).ceil

    for block in 0...length
      istart = block * range
      iend = istart + range
      block_data = data[istart...iend]
      block_data = block_data.join if range == 5
      address_list[block] = Digest::SHA1.digest block_data 
      write_block(address_list[block], block_data)   
    end
    address_list
  end

  def write_block(address, data)
    block_address = file_path(address)
    #TODO: make the .dat file hidden and binary
    unless File.file?(block_address)
      File.open(block_address , "wb") do |file| 
        file.write(data)
      end
    end
  end
end


