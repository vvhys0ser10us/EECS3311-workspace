note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

create
	make, make_dummy

feature -- attributes
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	contents: ARRAYED_LIST [ENTITY] --holds 4 quadrants

	row: INTEGER

	column: INTEGER

feature -- constructor
	make(row_input: INTEGER; column_input: INTEGER)
		--initialization
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		do
			row := row_input
			column := column_input
			create contents.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			contents.compare_objects
--			if (row = 3) and (column = 3) then
--				put (create {ENTITY_ALPHABET}.make ('O')) -- If this is the sector in the middle of the board, place a black hole
--			else
--				if (row = 1) and (column = 1) then
--					put (create {ENTITY_ALPHABET}.make ('E')) -- If this is the top left corner sector, place the explorer there
--				end
--			end -- if
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		do
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
		end


feature {GALAXY} --command

	put (new_component: ENTITY)
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			found: BOOLEAN
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or found
			loop
				if contents [loop_counter] = new_component then
					found := TRUE
				end --if
				loop_counter := loop_counter + 1
			end -- loop

			if not found and not is_full then
				contents.extend (new_component)
			end

		ensure
			component_put: not is_full implies contents.has (new_component)
		end

feature -- Queries

	print_sector: STRING
			-- Printable version of location's coordinates with different formatting
		do
			Result := ""
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	is_full: BOOLEAN
			-- Is the location currently full?
		local
			loop_counter: INTEGER
			occupant: ENTITY
			empty_space_found: BOOLEAN
		do
			if contents.count < shared_info.max_capacity then
				empty_space_found := TRUE
			end
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				end
				loop_counter := loop_counter + 1
			end

			if contents.count = shared_info.max_capacity and then not empty_space_found then
				Result := TRUE
			else
				Result := FALSE
			end
		end

--	has_stationary: BOOLEAN
--			-- returns whether the location contains any stationary item
--		local
--			loop_counter: INTEGER
--		do
--			from
--				loop_counter := 1
--			until
--				loop_counter > contents.count or Result
--			loop
--				if attached contents [loop_counter] as temp_item  then
--					Result := temp_item.is_stationary
--				end -- if
--				loop_counter := loop_counter + 1
--			end
--		end

end
