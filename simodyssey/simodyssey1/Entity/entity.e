note
	description: "Summary description for {ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY

create
	make

feature
	make(n : INTEGER)
		do
			id := n
		end

feature
	id : INTEGER
	icon : CHARACTER


--invariant
--	allowable_symbols:
--		icon = 'E' or icon = 'P' or icon = 'W' or icon = 'Y' or icon = '*' or icon = 'O'
end
