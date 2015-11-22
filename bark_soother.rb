require_relative 'parser'

# Set base sound level to 70%
`amixer cset numid=1 -- 70%`

# Start soothing loop
loop do
  # Record 1 second
  `arecord -D hw:1,0 -f s16_le -r 44100 -d 1 -q > tmp/record.wav`

  # Analyze recorded file
  `sox tmp/record.wav -n stat > tmp/sox.data 2>&1`

  # Parse analysis file
  fp = FileParser.new(filename: 'tmp/sox.data')
  fp.parse

  # If max noise is over 0.02, play white noise and log entry
  if fp.info["Maximum amplitude"] > 0.02
    `aplay short_wave.wav`
    current_volume = `amixer get PCM|grep -o [0-9]*%|sed 's/%//'`

    File.open('tmp/barks.log', 'a') do |file|
      file.write("Barking at: " + Time.now.to_s + " Volume: " + current_volume)
    end

    `amixer cset numid=1 -- #{current_volume.to_i + 10}%`
  else
    # Set base sound level back to 70%
    `amixer cset numid=1 -- 70%`
    puts 'Good doggie, all quiet'
  end

  puts 'Current volume: ' + `amixer get PCM|grep -o [0-9]*%|sed 's/%//'` + "\n"
end
