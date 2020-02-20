note
	description: "Summary description for {SCORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCORE
inherit
	ANY
	redefine
		out
	end

create
	make

feature 	{NONE}--command

	make
		do
			total := 0
			curr := 0
		end

feature {NONE}--attributes

	total : INTEGER

	curr : INTEGER

feature

	total_add (d : INTEGER)
		require
			d = 1 or d = 2 or d = 3
		do
			total := total + d
		ensure
			add_t:
				total = old total + d
			not_smaller:
				curr <= total
		end

	curr_add (d : INTEGER)
		require
			d = 1 or d = 2 or d = 3
		do
			curr := curr + d
		ensure
			add_c:
				curr = old curr + d
			not_larger:
				curr <= total
		end

feature

	out : STRING
		do
			create Result.make_empty
			Result.append ("Score: ")
			Result.append (curr.out)
			Result.append (" / ")
			Result.append (total.out)
		end

invariant
	curr_not_larger:
		total >= curr and curr >= 0 and total >= 0
end
