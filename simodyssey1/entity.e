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
	make (n : INTEGER)
		do
			id := n
		end

feature --constant

	id : INTEGER

	icon : CHARACTER

end
