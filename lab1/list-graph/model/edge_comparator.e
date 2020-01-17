note
	description: "Summary description for {EDGE_COMPARATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EDGE_COMPARATOR[G -> COMPARABLE]

inherit
	KL_COMPARATOR[EDGE[G]]


feature
	attached_less_than (u,v: EDGE[G]): BOOLEAN
			-- Is `u' considered less than `v'?
		do
		result:= u.destination < v.destination

		end

end
