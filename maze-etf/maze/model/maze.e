note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	MAZE

inherit
	ANY
		redefine
			out
		end

create {MAZE_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create graph.make_empty
			create g.make
			create draw.make (g.generate_new_maze (1))
			i := 0
			num := 0
			curr := 0
			total := 0
			diff := 0
			in_game := false
			create pass.make_empty
			give_up := false
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	num: INTEGER
	graph : LIST_GRAPH [COORDINATE]
	g : MAZE_GENERATOR
	draw : MAZE_DRAWER
	total : INTEGER
	curr : INTEGER
	pass : STRING
	diff : INTEGER
	in_game : BOOLEAN
	give_up : BOOLEAN

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	new_game(level:INTEGER)
		local
			pic : MAZE_DRAWER
			game : MAZE_GENERATOR
		do
			if(in_game ~ false) then
				create game.make
				in_game := true
				create pic.make (game.generate_new_maze (level))
				draw := pic
				s := pic.out
				i := i + 1
				num := num + 1
				total := level + total
				diff := level
				give_up := false
			else
				s:= "Error! In game already."
				i := i + 1
			end

		end

	move(direction:INTEGER)
		local
			pic : MAZE_DRAWER
			pos : DIRECTION_UTILITY
			d : TUPLE[INTEGER,INTEGER]
		do
			if(in_game = TRUE) then
				pic := draw
				if(direction = 4 ) then
					if(pic.maze_ascii[pic.player_coord.row-1, pic.player_coord.col] ~ "+   " or
						pic.maze_ascii[pic.player_coord.row-1, pic.player_coord.col] ~ "+   +%N" or
						pic.maze_ascii[pic.player_coord.row-1, pic.player_coord.col] ~ "+ * +%N" or
						pic.maze_ascii[pic.player_coord.row-1, pic.player_coord.col] ~ "+ * ") then
						d := pos.n
						pic.move_player (d)
						s:= pic.out
					else
						s:="Error! Not a valid move."
					end
				end

				if(direction = 6) then
					if(pic.maze_ascii[pic.player_coord.row+1, pic.player_coord.col] ~ "+   " or
						pic.maze_ascii[pic.player_coord.row+1, pic.player_coord.col] ~ "+   +%N" or
						pic.maze_ascii[pic.player_coord.row+1, pic.player_coord.col] ~ "+ * +%N" or
					 	pic.maze_ascii[pic.player_coord.row+1, pic.player_coord.col] ~ "+ * ") then
						d := pos.s
						pic.move_player (d)
						s:= pic.out
					else
							s:="Error! Not a valid move."
					end
				end

				if(direction = 7) then
					if(pic.maze_ascii[pic.player_coord.row, pic.player_coord.col] ~ "  X " or
						pic.maze_ascii[pic.player_coord.row, pic.player_coord.col] ~ "* X |%N" or
						pic.maze_ascii[pic.player_coord.row, pic.player_coord.col] ~ "  X |%N" or
						pic.maze_ascii[pic.player_coord.row, pic.player_coord.col] ~ "* X ") then
						d := pos.w
						pic.move_player (d)
						s:= pic.out
					else
						s:="Error! Not a valid move."
					end
				end

				if(direction = 5) then
					if(pic.player_coord.col < pic.size) then
						if(pic.maze_ascii[pic.player_coord.row, pic.player_coord.col+1] ~ "    " or
							pic.maze_ascii[pic.player_coord.row, pic.player_coord.col+1] ~ "    |%N" or
							pic.maze_ascii[pic.player_coord.row, pic.player_coord.col+1] ~ "* * " or
							pic.maze_ascii[pic.player_coord.row, pic.player_coord.col+1] ~ "  * ")
							then
							d := pos.e
							pic.move_player (d)
							s:= pic.out
						else
							s:="Error! Not a valid move."
						end
					else
						s:="Error! Not a valid move."
					end
				end

				draw := pic
				if(pic.player_coord.row ~ (pic.size * 2 + 1) and pic.player_coord.col ~ pic.size) then
					s.append ("%N  Congratulations! You escaped the maze!")
					curr := curr + diff
					in_game := false
				end
				i := i + 1
			else
				s := "Error! Not in a game."
				i := i + 1
			end

		end

	abort
		do
			if(in_game = True) then
				in_game := false
				i := i + 1
				give_up := true
				s.make_empty
			else
				s := "Error! Not in a game."
				i := i + 1
			end
		end

	solve
		do

		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("State: ")
			Result.append (i.out)
			Result.append (" -> ")
			if(s /~ "Error! Not in a game.") then
				if(s /~ "Error! Not a valid move." and s /~ "Error! In game already.") then
						Result.append ("ok")
				end
				Result.append (s)
				if(i /= 0 and give_up = false) then
					Result.append ("%N  Game Number: "+ num.out + "%N  Score: " + curr.out + " / "+ total.out + "%N")
				end
			else
				Result.append (s)
			end
		end

end




