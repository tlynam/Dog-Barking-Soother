volume   = ARGV[0]
duration = ARGV[1]

`amixer cset numid=1 -- #{volume}%`
`aplay ocean.mp3 -d #{duration}`
