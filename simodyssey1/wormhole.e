note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

inherit
	STATIONARY_ENTITY
	redefine
		make
	end

create
	make

feature
	make(n : INTEGER)
		do
			id := n
			icon := 'W'
		end
end
