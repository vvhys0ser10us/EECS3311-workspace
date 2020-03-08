note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE
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
			icon := 'O'
		end
end
