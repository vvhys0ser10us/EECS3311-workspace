note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit
	MOVEABLE_ENTITY
	redefine
		make
	end

create
	make

feature
	make(n : INTEGER)
		do
			id := n
			icon := 'P'
		end

feature --variable
	attach : BOOLEAN

	support_life : BOOLEAN

	visited : BOOLEAN

	turns_left : INTEGER

end
