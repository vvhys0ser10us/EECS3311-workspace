note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT

inherit
	STAR
	redefine
		make
	end
create
	make

feature
	make(n:INTEGER)
		do
			id := n
			icon := '*'
			luminosity := 2
		end
end
