note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	MOVEABLE_ENTITY
	redefine
		make
	end
create
	make

feature

	make (n : INTEGER)
		do
			fuel := 3
			life := 3
			landed := false
			id := n
			icon :='E'

		end

feature

	max_fuel : INTEGER
		do
			Result := 3
		end

feature --variable

	fuel : INTEGER

	life :INTEGER

	landed : BOOLEAN

end
