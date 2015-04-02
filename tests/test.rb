#!/usr/bin/env ruby

module Main
  @@bin = "genea-tester"

  def self.usage
    $stderr.puts "Usage: #{@@bin} file"
    return false
  end

  def self.show_error err
      $stderr.puts "#{@@bin}: error: #{err}"
  end

  def self.parse_args(args)
    file = nil

    len = args.length
    i = 0
    while i < len
      if args[i] == '-h'
          exit usage
      else
          file = args[i]
      end
      i += 1
    end
    if file == nil
        show_error "Missing file argument"
        exit usage
    end
    return file
  end

  def self.run(args)
	file = parse_args(args)

	graph = Genea.parse file

  puts "// Families"
  puts graph.families
  puts "// People"
	puts graph.people

	return true
  end

end