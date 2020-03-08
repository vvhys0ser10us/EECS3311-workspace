note
	description: "Summary description for {GALAXY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY

inherit ANY
	redefine
		out
	end

create
	make

feature -- attributes

	grid: ARRAY2 [SECTOR]
			-- the board

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	new_movable_id : INTEGER

	new_stationary_id :INTEGER
feature --constructor

	make
		-- creates a dummy of galaxy grid
		local
			row : INTEGER
			column : INTEGER
		do
			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)
			from
				row := 1
			until
				row > shared_info.number_rows
			loop

				from
					column := 1
				until
					column > shared_info.number_columns
				loop
					grid[row,column] := create {SECTOR}.make(row,column)
					column:= column + 1;
				end
				row := row + 1
			end
			placement
	end

feature -- command

	placement
		local
			n, value : INTEGER
		do
			new_movable_id := 0
			grid[1,1].put (create {EXPLORER}.make (new_movable_id))
			new_movable_id := new_movable_id + 1
			new_stationary_id := -1
			grid[3,3].put (create {BLACKHOLE}.make (new_stationary_id))
			new_stationary_id := new_stationary_id - 1
			across grid as sector
			loop
--				if (sector.item /~ grid[3,3]) then
					n := gen.rchoose (1, 3)
					across 1 |..| n is i
					loop
						value := gen.rchoose (1, 100)
						if(value < shared_info.planet_threshold) then
							sector.item.put (create {PLANET}.make (new_movable_id))
							new_movable_id := new_movable_id + 1
						end
					end
			--	end
			end
		end

feature -- query
	out: STRING
	--Returns grid in string form
	local
		string1: STRING
		string2: STRING
		row_counter: INTEGER
		column_counter: INTEGER
		contents_counter: INTEGER
		temp_sector: SECTOR
		temp_component: ENTITY
		printed_symbols_counter: INTEGER
	do
		create Result.make_empty
		create string1.make(7*shared_info.number_rows)
		create string2.make(7*shared_info.number_columns)
		string1.append("%N")

		from
			row_counter := 1
		until
			row_counter > shared_info.number_rows
		loop
			string1.append("    ")
			string2.append("    ")

			from
				column_counter := 1
			until
				column_counter > shared_info.number_columns
			loop
				temp_sector:= grid[row_counter, column_counter]
			    string1.append("(")
            	string1.append(temp_sector.print_sector)
                string1.append(")")
			    string1.append("  ")
				from
					contents_counter := 1
					printed_symbols_counter:=0
				until
					contents_counter > temp_sector.contents.count
				loop
					temp_component := temp_sector.contents[contents_counter]
					if attached temp_component as character then
						string2.append_character(character.icon)
					else
						string2.append("-")
					end -- if
					printed_symbols_counter:=printed_symbols_counter+1
					contents_counter := contents_counter + 1
				end -- loop

				from
				until (shared_info.max_capacity - printed_symbols_counter)=0
				loop
						string2.append("-")
						printed_symbols_counter:=printed_symbols_counter+1

				end
				string2.append("   ")
				column_counter := column_counter + 1
			end -- loop
			string1.append("%N")
			if not (row_counter = shared_info.number_rows) then
				string2.append("%N")
			end
			Result.append (string1.twin)
			Result.append (string2.twin)

			row_counter := row_counter + 1
			string1.wipe_out
			string2.wipe_out
		end
	end

end
