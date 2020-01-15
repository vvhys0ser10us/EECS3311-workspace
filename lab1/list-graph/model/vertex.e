note
	description: "[
		A vertex has an item in the generic parameter, 
		as well as incoming and outgoing edges:
			item: G
			outgoing: LIST[EDGE[G]]
			incoming: LIST[EDGE[G]]
			outgoing_sorted: ARRAY[EDGE[G]]
		outgoing_sorted is an array of edges
		sorted based on comparable items in destination vertices. This allows
		for a unique ordering as in breadth first searches etc.
			]"
	note_to_student: "[
		Only modify features that have a `Todo` comment inside of them.
		You must also write the postcondition for command `remove_edge`.
		]"
	ca_ignore: "CA085"
	author: "JSO and JW"
	date: "$Date$"
	revision: "$Revision$"

class
	VERTEX[G -> COMPARABLE]
inherit
	ANY
		redefine is_equal, out end

	DEBUG_OUTPUT
		redefine is_equal, out end

	COMPARABLE
		redefine is_equal, out end
create
	make

feature {NONE} -- Initialization

	make(a_item: G)
			-- Initialization for `Current'.
		do
			create {LINKED_LIST[EDGE[G]]}outgoing.make
			outgoing.compare_objects
			create {LINKED_LIST[EDGE[G]]}incoming.make
			incoming.compare_objects
			item := a_item
		ensure
			item_set:
				item ~ a_item
			empty_edges:
				outgoing.is_empty and incoming.is_empty
		end

feature -- Comparable

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := item < other.item
		end

	is_equal(other: like Current): BOOLEAN
		do
			Result := item ~ other.item
		end


feature -- basic queries
	item: G

	outgoing: LIST[EDGE[G]]
		-- outging edges

	incoming: LIST[EDGE[G]]
		-- incoming edges

feature -- derived queries

	outgoing_sorted: ARRAY[EDGE[G]]
			-- Return outgoing edges as a sorted array
			-- (based on destination vertices of edges).
		do

			-- Todo: complete implementation

			create Result.make_empty -- this line is for compilation purposes
		ensure
			-- ∀ i ∈ 1 .. (Result.count - 1) : Result[i].destination ≤ Result[i + 1].destination
			sorted:
				across 1 |..| (Result.count - 1) as l_i all
					Result[l_i.item].destination <= Result[l_i.item + 1].destination
				end
		end

	outgoing_edge_count: INTEGER
		-- number of outgoing edges
		do

			-- Todo: complete implementation

		ensure
			outgoing_edge_count:
				Result = outgoing.count
		end

	incoming_edge_count: INTEGER
		-- number of incoming edges
		do

			-- Todo: complete implementation

		ensure
			incoming_edge_count:
				Result = incoming.count
		end

	edge_count: INTEGER
			-- number of incoming and outgoing edges
		do

			-- Todo: complete implementation

		ensure
			correct_count:
				Result = incoming_edge_count + outgoing_edge_count
		end


	has_outgoing_edge(a_edge: EDGE[G]): BOOLEAN
			-- `Current` has `a_edge` as an outgoing edge
		do

			-- Todo: complete implementation

		ensure
			Result = outgoing.has (a_edge)
		end

	has_incoming_edge(a_edge: EDGE[G]): BOOLEAN
			-- `Current` has `a_edge` as an incoming edge
		do

			-- Todo: complete implementation

		ensure
			Result = incoming.has (a_edge)
		end

feature -- commands

	add_edge(a_edge: EDGE[G])
		require
			edge_contains_current: a_edge.source ~ Current or a_edge.destination ~ Current
			new_edge: not (has_incoming_edge (a_edge) or has_outgoing_edge (a_edge))
		do

			-- Todo: complete implementation

		ensure
			a_edge.destination ~ Current implies incoming.count = old incoming.count + 1
			a_edge.source ~ Current implies outgoing.count = old outgoing.count + 1
			a_edge.destination ~ Current implies incoming.has (a_edge)
			a_edge.source ~ Current implies outgoing.has (a_edge)
			-- incomplete, to add!
		end

	remove_edge(a_edge: EDGE[G])
		require
			a_edge.source ~ Current or a_edge.destination ~ Current
		do

			-- Todo: complete implementation

		ensure
			-- To do.
		end

feature -- out

	out: STRING
			-- Return string representation of current vertex
		do
			Result := item.out + ":"
			across outgoing_sorted as l_edge loop
				Result := Result + l_edge.item.debug_output +","
			end
			Result.remove (Result.count)
		end

	debug_output: STRING
			-- Return string representation of current vertex in debugger
		do
			Result := item.out + ":"
			across outgoing_sorted as l_edge loop
				Result := Result + l_edge.item.destination.item.out +","
			end
			Result.remove (Result.count)
		end

invariant
	outgoing_edges_start_with_current:
		across outgoing as l_edge all
			l_edge.item.source ~ Current
		end

	incoming_edges_end_with_current:
		across incoming as l_edge all
			l_edge.item.destination ~ Current
		end

	object_comparison:
		outgoing.object_comparison and incoming.object_comparison
end
