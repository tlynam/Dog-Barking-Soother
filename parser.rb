require 'bigdecimal'
require 'active_support/core_ext/string/filters'

class FileParser
  attr_reader :info

  def initialize(filename:)
    @filename = ARGV[0] || filename
    @info = {}
  end

  def parse
    File.open(@filename, "r") do |f|
      f.each_line do |line|
        attribute = line.split(":")
        key = attribute[0].squish
        value = attribute[1].squish
        @info[key] = BigDecimal.new(value)
      end
    end
  end
end
