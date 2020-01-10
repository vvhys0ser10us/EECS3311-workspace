note
	description: "Summary description for {MY_COUNTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_COUNTER
create
	make

feature
	value: INTEGER

feature
	make(v:INTEGER)
	-- Initialize counter with value ’v’.
-- No require clause here means that there’s no precondition.
-- Any input value ’v’ will be accepted and used to assign to ’value’.

	do
		value :=v
	end

feature
	increment_by(v:INTEGER)
	-- Increment the counter value by ’v’ unless
    -- it causes its value to go above the max.
	require -- Precondition: what’s assumed true by the supplier
		not_above_max: value + v <=10
	do
		value := value + v
	ensure -- Postcondition: what’s expected to be true, guaranteed by supplier
		value_incremented: value = old value + v
	end

	decrement_by(v:INTEGER)
	-- Decrement the counter value by ’v’ unless
	-- it causes its value to go below the min.
	require
		not_below_min: value - v >=0 
	do
		value := value - v
	ensure
		value_decremented: value = old value - v
	end

invariant -- Class invariant: what a legitimate counter means.
	counter_in_range:
	0 <= value and value <= 10
end
