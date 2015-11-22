require 'bigdecimal'

class FileParser
  attr_reader :info

  def initialize(filename:)
    @filename = ARGV[0] || filename
    @info = {}
  end

  def parse
    IO.foreach(@filename) do |line|
      attribute = line.split(":")
      key = attribute[0].strip
      value = attribute[1].strip
      @info[key] = BigDecimal.new(value)
    end
  end
end
