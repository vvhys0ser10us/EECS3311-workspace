note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET
inherit
	MOVABLE_ENTITY
	redefine
		make
	end
create
	make

feature
	make ( n : INTEGER)
		do
			id := n
			icon := 'P'
		end

feature
	attatch : BOOLEAN

	support_life : BOOLEAN

	visited : BOOLEAN

	turn_left : INTEGER
	
end
