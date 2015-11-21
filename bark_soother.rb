require_relative 'parser'

# Record 1 second
`arecord -D hw:1,0 -f s16_le -d 1 > tmp/record.wav`

# Analyze recorded file
`sox tmp/record.wav -n stat > tmp/data.txt 2>&1`

# Parse analysis file
fp = FileParser.new(filename: 'tmp/data.txt')
fp.parse

# If max noise is over 0.02, play white noise
if fp.info["Maximum amplitude"] > 0.02
  `amixer cset numid=1 -- 90%`
  `aplay ocean.mp3 -d 10`
else
  puts 'Good doggie, all quiet'
end
