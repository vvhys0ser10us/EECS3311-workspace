note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MAZE_ACCESS

feature
	m: MAZE
		once
			create Result.make
		end

invariant
	m = m
end




