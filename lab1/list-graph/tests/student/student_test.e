note
	description: "Summary description for {STUDENT_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST

inherit
	ES_TEST

create
	make
feature {NONE}-- Initialization

	make
		do
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)
		end

feature -- Tests

	t1: BOOLEAN
		local
			v1,v2,v3:VERTEX[INTEGER]
			e1,e2,e3,e4:EDGE[INTEGER]
		do
			comment("t1: VERTEX: add & remove edges")
			create v1.make (1)
			create v2.make (2)
			create v3.make (3)
			create e1.make (v1,v1)
			v1.add_edge (e1)
			create e2.make (v1,v2)
			v1.add_edge (e2)
			v2.add_edge (e2)
			create e3.make (v2,v1)
			v1.add_edge (e3)
			v2.add_edge (e3)
			create e4.make (v2,v3)
			v2.add_edge (e4)
			v3.add_edge (e4)

			Result := v1.outgoing.count ~ 2 and v1.incoming.count ~ 2 and v2.outgoing.count ~ 2 and v2.incoming.count ~ 1 and v3.outgoing.count ~ 0 and v3.incoming.count ~ 1
			check
				Result
			end

			Result :=  v1.has_incoming_edge (e1) and v1.has_outgoing_edge (e1) and v1.has_incoming_edge (e3) and v1.has_outgoing_edge (e2)
			check
				Result
			end

			Result := v1.edge_count ~ 4 and v2.edge_count ~ 3 and v3.edge_count ~ 1
			check
				Result
			end

			v1.remove_edge (e1)
			Result := not v1.has_incoming_edge (e1) and not v1.has_outgoing_edge (e1) and v1.edge_count ~ 2
			check
				Result --remove self-loop
			end

			v1.remove_edge (e2)
			Result := not v1.has_outgoing_edge (e2) and not v2.has_incoming_edge (e2)
			check
				Result --remove edge e2
			end
		end

	t2: BOOLEAN
		local
			v1,v2,v3:VERTEX[INTEGER]
			e1,e2,e3,e4,e5:EDGE[INTEGER]
			sorted_edges: ARRAY [EDGE [INTEGER]]
			sorted_out: STRING
		do
			comment("t2: VERTEX: outgoing_sorted")
			create v1.make (1)
			create v2.make (2)
			create v3.make (3)
			create e5.make (v1,v3)
			v1.add_edge (e5)
			v3.add_edge (e5)
			create e1.make (v1,v1)
			v1.add_edge (e1)
			create e2.make (v1,v2)
			v1.add_edge (e2)
			v2.add_edge (e2)
			create e3.make (v2,v1)
			create e4.make (v2,v3)
			v2.add_edge (e4)
			v3.add_edge (e4)
			v1.add_edge (e3)
			v2.add_edge (e3)
			sorted_edges := v1.outgoing_sorted
			Result := sorted_edges.count ~ 3
			create sorted_out.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_out.append (curr_edge.item.destination.out)
				sorted_out.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "1:1,2,3", v1.out)

			sorted_edges := v2.outgoing_sorted
			Result := sorted_edges.count ~ 2
			create sorted_out.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_out.append (curr_edge.item.destination.out)
				sorted_out.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "2:1,3", v2.out)
		end

	t3: BOOLEAN
		local
			l_g: LIST_GRAPH[INTEGER]
			a_array : ARRAY[TUPLE[INTEGER, INTEGER]]
			e1,e2,e3,e4 : EDGE[INTEGER]
		do
			comment("t3: LIST_GRAPH: add & remove edge")
			a_array := <<[1,2],[1,1],[2,1],[2,3],[2,4],[1,4],[3,4],[4,5],[4,6],[5,6],[6,7],[5,8],[8,7],[8,1]>>
			a_array.compare_objects
			create l_g.make_from_array (a_array)
			assert_equal ("correct vertices & edges", "[1:1,2,4][2:1,3,4][3:4][4:5,6][5:6,8][6:7][7][8:1,7]", l_g.out)
			Result := l_g.edge_count ~ 14 and l_g.vertex_count ~ 8
			check
				result
			end

			create e1.make (l_g.vertices[2], l_g.vertices[2])
			l_g.add_edge (e1)
			create e2.make (l_g.vertices[8], l_g.vertices[4])
			l_g.add_edge (e2)
			assert_equal ("correct vertices & edges", "[1:1,2,4][2:1,2,3,4][3:4][4:5,6][5:6,8][6:7][7][8:1,4,7]", l_g.out)
			Result := l_g.edge_count ~ 16
			check
				result
			end

			l_g.remove_edge (e1)
			create e3.make (l_g.vertices[1], l_g.vertices[1])
			create e4.make (l_g.vertices[2], l_g.vertices[4])
			l_g.remove_edge (e3)
			l_g.remove_edge (e4)
			assert_equal ("correct vertices & edges", "[1:2,4][2:1,3][3:4][4:5,6][5:6,8][6:7][7][8:1,4,7]", l_g.out)
			Result := l_g.edge_count ~ 13
			check
				result
			end

		end

	t4: BOOLEAN
		local
			l_g: LIST_GRAPH[INTEGER]
			a_array : ARRAY[TUPLE[INTEGER, INTEGER]]
			v1,v2 :VERTEX[INTEGER]
			e1,e2,e3 :EDGE[INTEGER]
		do
			comment("t4: LIST_GRAPH: add & remove vertex")
			a_array := <<[1,2],[1,1],[8,7],[2,1],[2,3],[2,4],[1,4],[3,4],[4,5],[4,6],[5,6],[6,7],[5,8],[8,1]>>
			a_array.compare_objects
			create l_g.make_from_array (a_array)
			l_g.remove_vertex (l_g.vertices[1])
			assert_equal ("correct vertices & edges", "[2:3,4][8:7][7][3:4][4:5,6][5:6,8][6:7]", l_g.out)
			Result := l_g.edge_count ~ 9
			check
				Result
			end
			l_g.remove_vertex (l_g.vertices[3])
			assert_equal ("correct vertices & edges", "[2:3,4][8][3:4][4:5,6][5:6,8][6]", l_g.out)
			Result := l_g.edge_count ~ 7
			check
				Result
			end

			create v1.make (1)
			create v2.make (9)
			create e1.make (v1, v2)
			create e2.make (l_g.vertices[2], v1)
			create e3.make (v1,v1)
			l_g.add_vertex (v1)
			l_g.add_vertex (v2)
			l_g.add_edge (e1)
			l_g.add_edge (e2)
			l_g.add_edge (e3)
			assert_equal ("correct vertices & edges", "[2:3,4][8:1][3:4][4:5,6][5:6,8][6][1:1,9][9]", l_g.out)
			Result := l_g.edge_count ~ 10
			check
				Result
			end

			l_g.remove_vertex (l_g.vertices[7])
			assert_equal ("correct vertices & edges", "[2:3,4][8][3:4][4:5,6][5:6,8][6][9]", l_g.out)
			Result := l_g.edge_count ~ 7
			check
				Result
			end
		end

	t5: BOOLEAN
		local
			l_g: LIST_GRAPH[INTEGER]
			a_array : ARRAY[TUPLE[INTEGER, INTEGER]]
			reachable : ARRAY[VERTEX[INTEGER]]

		do
			comment("t5: LIST_GRAPH: reachable")
			a_array := <<[1,2],[1,1],[2,1],[2,3],[2,4],[1,4],[3,4],[4,5],[4,6],[5,6],[6,7],[5,8],[8,7],[8,1]>>
			a_array.compare_objects
			create l_g.make_from_array (a_array)
			assert_equal ("correct vertices & edges", "[1:1,2,4][2:1,3,4][3:4][4:5,6][5:6,8][6:7][7][8:1,7]", l_g.out)
			Result := l_g.edge_count ~ 14 and l_g.vertex_count ~ 8
			check
				result
			end
			reachable := l_g.reachable (l_g.vertices[1])
			Result := reachable.count ~ 8 and reachable[1].item ~ 1 and reachable[2].item ~ 2 and reachable[3].item ~ 4 and reachable[4].item ~ 3 and reachable[5].item ~ 5 and reachable[7].item ~ 8 and reachable[8].item ~ 7
		end

end
