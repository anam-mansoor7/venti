require_relative 'venti'


if ARGV.size > 1
	directory = ARGV[0]
	filename = ARGV[1]
  v = Venti.new(directory)
  v.vac(filename)
#v.unvac('test.vac')

else
	print "Invalid Arguments! The first argument should be the archival directory and the second should be the file to archive"
end

