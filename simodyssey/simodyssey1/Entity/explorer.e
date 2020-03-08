note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	MOVABLE_ENTITY
	redefine
		make
	end

create
	make

feature
	make (n : INTEGER)
		do
			id := n
			fuel := 3
			life := 3
			icon := 'E'
		end

feature
	fuel : INTEGER


	life : INTEGER

	landed : BOOLEAN

	max_fuel : INTEGER

feature
	decrease_fuel
		do
			fuel := fuel - 1
		end

end
