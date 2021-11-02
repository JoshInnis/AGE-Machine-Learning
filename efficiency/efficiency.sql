
CREATE OR REPLACE FUNCTION ag_catalog.age_efficiency(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS TABLE(start_vertex agtype, end_vertex agtype, efficiency agtype)
LANGUAGE plpgsql
AS $function$
DECLARE ge agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	SELECT ag_catalog.age_global_efficiency(graph_name, label, properties)
	INTO ge;

	RETURN QUERY
	SELECT a.start_vertex, a.end_vertex, agtype_in((1/(age_size(a.edges)::int::numeric))::varchar::cstring)
	FROM ag_catalog.age_shortest_path(graph_name, label, properties) as a;
END
$function$