note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMODYSSEY

inherit
	ANY
		redefine
			out
		end

create {SIMODYSSEY_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			i := 0
		end

feature -- model attributes
	s : STRING
	i : INTEGER

feature -- model operations

	reset
			-- Reset model state.
		do
			make
		end

	play
		local
			galaxy:GALAXY
		do
			create galaxy.make
			s:= galaxy.out
		end

	test (p_threshold : INTEGER)
		do

		end

	move (dir:INTEGER)
		do
				
		end

	pass
		do

		end

	status
		do

		end

	abort
		do

		end

	land
		do

		end

	wormhole
		do

		end

	liftoff
		do

		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append ("System State: default model state ")
			Result.append ("(")
			Result.append (i.out)
			Result.append (")")
			Result.append (s)
		end

end




