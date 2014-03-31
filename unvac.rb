require_relative 'venti'

if ARGV.size == 1
	filename = ARGV[0]
	if File.file?(filename)
	  file_details = Marshal.load(File.read(filename))
	  v = Venti.new(file_details[:directory])
	  v.unvac(file_details)
	else
		puts "Error #{filename} does not exist"
	end
else
	print "Invalid Arguments! pleaase specify file to unarchive(with ac extension)"
end

