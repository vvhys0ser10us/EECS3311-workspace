note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF
inherit
	STAR
	redefine
		make
	end

feature
	make(n : INTEGER)
		do
			id := n
			icon := 'Y'
			luminosity := 3
		end

end
