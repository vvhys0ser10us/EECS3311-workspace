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
			create g.make
			create h.make
			graph := g.generate_new_maze (1)
			create draw.make (g.generate_new_maze (1))
			i := 0
			num := 0
			diff := 0
			in_game := false
			give_up := false
			solve_state := false
			create solve_p.make_empty
		end

feature {NONE}-- model attributes
	s : STRING           --output string

	i : INTEGER			--number of states

	num: INTEGER			--number of games

	graph : LIST_GRAPH [COORDINATE]

	g : MAZE_GENERATOR

	h : MAZE_GENERATOR

	draw : MAZE_DRAWER	--maze_graph

	diff : INTEGER 		--current difficulty

	in_game : BOOLEAN		--in-game state

	give_up : BOOLEAN		--abort command state

	solve_state : BOOLEAN --solve command state

	score : SCORE  		--score

	solve_p : ARRAY[VERTEX[COORDINATE]] --keep the solution path for the last solve command



feature -- model operations

	new_game(level:INTEGER)
		do
			if(in_game ~ false) then
				graph :=h.generate_new_maze (level)
				in_game := true
				solve_state := false
				create draw.make (graph)
				s := draw.out
				i := i + 1
				num := num + 1
				score.total_add (level)
				diff := level
				give_up := false
			else
				s:= "Error! In game already."
				i := i + 1
			end

		end

feature --move
	move(direction:INTEGER)
		local
			pos : DIRECTION_UTILITY
			d : TUPLE[INTEGER,INTEGER]
		do
			if(in_game = TRUE) then

				-- move(N)
				if(direction = 4 ) then
					if(draw.maze_ascii[draw.player_coord.row-1, draw.player_coord.col] ~ "+   " or
						draw.maze_ascii[draw.player_coord.row-1, draw.player_coord.col] ~ "+   +%N" or
						draw.maze_ascii[draw.player_coord.row-1, draw.player_coord.col] ~ "+ * +%N" or
						draw.maze_ascii[draw.player_coord.row-1, draw.player_coord.col] ~ "+ * ") then
						d := pos.n
						draw.move_player (d)
						s:= draw.out
					else
						s:="Error! Not a valid move."
					end
				end

				--move(S)
				if(direction = 6) then
					if(draw.maze_ascii[draw.player_coord.row+1, draw.player_coord.col] ~ "+   " or
						draw.maze_ascii[draw.player_coord.row+1, draw.player_coord.col] ~ "+   +%N" or
						draw.maze_ascii[draw.player_coord.row+1, draw.player_coord.col] ~ "+ * +%N" or
					 	draw.maze_ascii[draw.player_coord.row+1, draw.player_coord.col] ~ "+ * ") then
						d := pos.s
						draw.move_player (d)
						s:= draw.out
					else
						s:="Error! Not a valid move."
					end
				end

				--move(W)
				if(direction = 7) then
					if(draw.maze_ascii[draw.player_coord.row, draw.player_coord.col] ~ "  X " or
						draw.maze_ascii[draw.player_coord.row, draw.player_coord.col] ~ "* X |%N" or
						draw.maze_ascii[draw.player_coord.row, draw.player_coord.col] ~ "  X |%N" or
						draw.maze_ascii[draw.player_coord.row, draw.player_coord.col] ~ "* X ") then
						d := pos.w
						draw.move_player (d)
						s:= draw.out
					else
						s:="Error! Not a valid move."
					end
				end

				--move(E)
				if(direction = 5) then
					if(draw.player_coord.col < draw.size) then
						if(draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "    " or
							draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "    |%N" or
							draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "  o |%N" or
							draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "* * " or
							draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "  * " or
							draw.maze_ascii[draw.player_coord.row, draw.player_coord.col+1] ~ "  o "
							)
							then
							d := pos.e
							draw.move_player (d)
							s:= draw.out
						else
							s:="Error! Not a valid move."
						end
					else
						s:="Error! Not a valid move."
					end
				end

				if(draw.player_coord.row ~ (draw.size * 2 + 1) and draw.player_coord.col ~ draw.size) then
					s.append ("%N  Congratulations! You escaped the maze!")
					if(solve_state = false) then
						score.curr_add (diff)
					end
					in_game := false
				end
				i := i + 1
			else
				s := "Error! Not in a game."
				i := i + 1
			end

		end

feature --abort
	abort
		do
			if(in_game = True) then
				-- not solvable, no penalty
				if(not draw.maze_graph.reachable(draw.maze_graph.vertices.at (draw.size * draw.size )).has (draw.maze_graph.vertices.at (1)))then
					score.abort_m (diff)
				end
				in_game := false
				i := i + 1
				give_up := true
				solve_state := false
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
			parent : FUN[VERTEX[COORDINATE],VERTEX[COORDINATE]]
			visited : SEQ[VERTEX[COORDINATE]]
			start: VERTEX[COORDINATE]
			reach : BOOLEAN
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

					--clear the last solution path
					solve_state := true
					across solve_p is mark
					loop
						if(draw.maze_ascii[mark.item.row * 2, mark.item.col][3] /~ draw.path_char and draw.maze_ascii[mark.item.row * 2, mark.item.col][3] /~ draw.player_char) then
							draw.maze_ascii[mark.item.row * 2, mark.item.col][3] := ' '
						end
					end

					create cur.make ([2,1])

					--find current vertex
					across draw.maze_graph.vertices is cod
					loop
						if((cod.item.row * 2) = draw.player_coord.row  and cod.item.col = draw.player_coord.col) then
							cur := cod
						end
					end

					--destination
					dst := draw.maze_graph.vertices.at (draw.size * draw.size)

					--BFS and find parent
					from
						queue := <<cur>>
						create parent.make_empty
						visited := <<cur>>
					until
						queue.has (dst)
					loop
						front := queue.first
						queue.dequeue
						across front.outgoing_sorted  is x
						loop
							if not visited.has (x.destination) then
								visited.append (x.destination)
								parent := parent @<+ [x.destination, front]
								queue.enqueue (x.destination)
							end
						end
					end

					--shortest path
					reach := true
					from
						create s_p.make_empty
						s_p.force (dst, s_p.count + 1)
						start := dst
					until
						reach = false
					loop
						s_p.force (parent[start] , s_p.count + 1 )
						start := parent[start]
						if(start ~ cur) then
							reach := false
						end
					end

					--keep the shortest path for clearing
					solve_p := s_p

					--show the solution path on the maze
					across s_p is y
					loop
						if(draw.maze_ascii[y.item.row * 2, y.item.col][3] /~ draw.path_char and draw.maze_ascii[y.item.row * 2, y.item.col][3] /~ draw.player_char) then
							draw.maze_ascii[y.item.row * 2, y.item.col][3] := draw.soln_char
						end
					end
					s := draw.out
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
				if(solve_state ~ true) then
					Result.append ("%N  Since you used the solution, no points are awarded.")
				end
				if(i /= 0 and give_up ~ false) then
					Result.append ("%N  Game Number: "+ num.out + "%N  " + score.out + "%N")
				end
			else
				Result.append (s)
			end
		end

end



