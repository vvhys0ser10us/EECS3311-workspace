note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	SIMODYSSEY_ACCESS

feature
	m: SIMODYSSEY
		once
			create Result.make
		end

invariant
	m = m
end




