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
			create score.make
			create s.make_empty
			create graph.make_empty
			create g.make
			create draw.make (g.generate_new_maze (1))
			i := 0
			num := 0
			diff := 0
			in_game := false
			give_up := false
		end

feature -- model attributes
	s : STRING
	i : INTEGER

	num: INTEGER			--number of games

	graph : LIST_GRAPH [COORDINATE]
	g : MAZE_GENERATOR
	draw : MAZE_DRAWER

	diff : INTEGER 		--current difficulty

	in_game : BOOLEAN		--in-game state

	give_up : BOOLEAN		--abort state

	score : SCORE  		--score



feature -- model operations


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
				if(draw.maze_graph.reachable(draw.maze_graph.vertices.at (draw.size * draw.size )).has (draw.maze_graph.vertices.at (1)))then
					score.total_add (level)
				end
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
					score.curr_add (diff)
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
		local
			cur : VERTEX[COORDINATE]
			dst : VERTEX[COORDINATE]
			s_p : ARRAY[VERTEX[COORDINATE]]
			front :VERTEX[COORDINATE]
			queue : QUEUE[VERTEX[COORDINATE]]

		do
			if(in_game = false) then
				s:= "Error! Not in a game."
				i:= i + 1
			else
				if(not draw.maze_graph.reachable(draw.maze_graph.vertices.at (draw.size * draw.size )).has (draw.maze_graph.vertices.at (1))) then
					s := "Error! Maze is not solvable, you may abort with no penalty."
					i := i + 1
				else
					i:= i + 1

					create cur.make ([2,1])

					across draw.maze_graph.vertices is cod
					loop
						if(cod.item.row = draw.player_coord.row and cod.item.col = draw.player_coord.col) then
							cur := cod  --current position
						end
					end

					dst := draw.maze_graph.vertices.at (draw.size * draw.size)

					from
						s_p := <<cur>>
						queue := <<cur>>
					until
						s_p.has (dst)
					loop
						front := queue.first
						queue.dequeue
						across front.outgoing_sorted  is x
						loop
							if not s_p.has (x.destination) then
								s_p.force (x.destination, s_p.count + 1)
								queue.enqueue (x.destination)
							end
						end
					end

					across s_p is y
					loop
						if(draw.maze_ascii[y.item.row * 2, y.item.col][3] /~ draw.path_char and draw.maze_ascii[y.item.row * 2, y.item.col][3] /~ draw.player_char) then
							draw.maze_ascii[y.item.row * 2, y.item.col][3] := draw.soln_char
						end
					end
					s := draw.out
					s.append ("%N  Since you used the solution, no points are awarded.")
				end
			end
		end

feature
	reset
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
				if(s /~ "Error! Not a valid move." and s /~ "Error! In game already." and s /~ "Error! Maze is not solvable, you may abort with no penalty.") then
						Result.append ("ok")
				end
				Result.append (s)
				if(i /= 0 and give_up = false) then
					Result.append ("%N  Game Number: "+ num.out + "%N  " + score.out + "%N")
				end
			else
				Result.append (s)
			end
		end

end



