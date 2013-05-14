class World
	def initialize(height, width, tile)
		@tile = tile
		@height = height
		@width = width
		@map = Array.new(@height) { Array.new(@width) {@tile}}
	end
	def draw
		# clear
		i = 0
		while i < @map.size
			print @map[i] 
			print "\n"
			i += 1
		end
	end
	def insert(entity)
		# raise ArgumentError, 'Location out of bounds.' if entity.x >= @width or 
		# 	entity.x < 0 or entity.y >= @height or entity.y < 0
		if entity.x < @width and entity.x >= 0 and entity.y < @height and entity.y >= 0
			@map[entity.y][entity.x] = entity.symbol
		end
	end
	def clear
		@map = Array.new(@height) { Array.new(@width) {@tile}}
	end
end

class Entity
	attr_reader :x, :y, :symbol

	def initialize(x, y , symbol)
		@x = x
		@y = y
		@symbol = symbol
	end
	def move(new_x, new_y)
		@x = new_x
		@y = new_y
	end
end

class Player < Entity
	attr_accessor :name
end

# read a character without pressing enter and without printing to the screen
def read_char
  begin
    # save previous state of stty
    old_state = `stty -g`
    # disable echoing and enable raw (not having to press enter)
    system "stty raw -echo"
    c = STDIN.getc.chr
    # gather next two characters of special keys
    if(c=="\e")
      extra_thread = Thread.new{
        c = c + STDIN.getc.chr
        c = c + STDIN.getc.chr
      }
      # wait just long enough for special keys to get swallowed
      extra_thread.join(0.00001)
      # kill thread so not-so-long special keys don't wait on getc
      extra_thread.kill
    end
  rescue => ex
    puts "#{ex.class}: #{ex.message}"
    puts ex.backtrace
  ensure
    # restore previous state of stty
    system "stty #{old_state}"
  end
  return c
end

def get_input 
    c = read_char
	case c
	when "\e[A" # Up
		player.move
	when "\e[B"
	  	puts "DOWN ARROW"
	when "\e[C"
	  	puts "RIGHT ARROW"
	when "\e[D"
	  	puts "LEFT ARROW"
	end
end

# initialize map and player
Earth = World.new( 10, 20, '.' );
player = Player.new( 0, 0, '@' );
Earth.insert(player);
Earth.draw

# Game loop, runs until player hits 'q'
while true
	c = read_char
	system('clear')
	case c
	when "\e[A" # Up
		player.move(player.x, player.y - 1)
	when "\e[B" # Down
	  	player.move(player.x, player.y + 1)
	when "\e[C" # Right
	  	player.move(player.x + 1, player.y)
	when "\e[D" # Left
	  	player.move(player.x - 1, player.y)
	when "q"
		break
	end
	Earth.clear
	Earth.insert(player)
	Earth.draw
end



