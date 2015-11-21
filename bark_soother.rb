require_relative 'parser'

# set a base volume level, and run this procedure in a loop
# if it’s still over  threshold, you bump the volume level x%
# until you get up to full volume
# if it’s below threshold, reset volume to min level and stop playing the sound

# Set base sound level to 70%
`amixer cset numid=1 -- 70%`

# Start soothing loop
loop do
  # Record 1 second
  `arecord -D hw:1,0 -f s16_le -r 44100 -d 1 -q > tmp/record.wav`

  # Analyze recorded file
  `sox tmp/record.wav -n stat > tmp/data.txt 2>&1`

  # Parse analysis file
  fp = FileParser.new(filename: 'tmp/data.txt')
  fp.parse

  # If max noise is over 0.02, play white noise
  if fp.info["Maximum amplitude"] > 0.02
    `aplay ocean.mp3 -d 2`
    current_volume = `amixer get PCM|grep -o [0-9]*%|sed 's/%//'`
    `amixer cset numid=1 -- #{current_volume.to_i + 10}%`
  else
    # Set base sound level back to 70%
    `amixer cset numid=1 -- 70%`
    puts 'Good doggie, all quiet'
  end
  puts 'current volume: ' + `amixer get PCM|grep -o [0-9]*%|sed 's/%//'`
end
