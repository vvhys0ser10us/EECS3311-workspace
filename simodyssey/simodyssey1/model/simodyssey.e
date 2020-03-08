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
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end


	play
		local
			galaxy : GALAXY
			sa: SHARED_INFORMATION_ACCESS
			info: SHARED_INFORMATION
		do

			info := sa.shared_info
        	info.set_planet_threshold(30)
        	create galaxy.make
			s := galaxy.out

		end


	test (p_threshold : INTEGER)
		local
			galaxy : GALAXY
			sa: SHARED_INFORMATION_ACCESS
			info: SHARED_INFORMATION
		do
			info := sa.shared_info
        	info.set_planet_threshold(p_threshold)
        	create galaxy.make
			s := galaxy.out
		end


	move (dir : INTEGER)
		do

		end


	pass

		do



		end


	status
		do

		end


	land
		do

		end


	liftoff
		do

		end


	wormhole
		do

		end


	abort
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
			Result.append ("System State: default model state ")
			Result.append ("(")
			Result.append (i.out)
			Result.append (")")
			Result.append (s)
		end

end




