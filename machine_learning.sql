CREATE OR REPLACE FUNCTION ag_catalog.age_shortest_path(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS TABLE(start_vertex agtype, end_vertex agtype, edges agtype)
LANGUAGE plpgsql
AS $function$
DECLARE edges agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	sql := format('SELECT *
		FROM cypher(''%s''::name, $$
		MATCH (u)-[e%s* %s]->(v)
		RETURN u, v, min(e)
		$$) AS (start_vertex agtype, end_vertex agtype, edges agtype);',
		graph_name,
		CASE
			WHEN label IS NULL THEN ''
			ELSE CONCAT(':', label) END,
		CASE
			WHEN properties IS NULL THEN ''
			ELSE REGEXP_REPLACE(properties::varchar, '"(([^"]|\\")+)":', '\1:')
		END
	);
	RETURN QUERY EXECUTE sql;
END
$function$

CREATE OR REPLACE FUNCTION ag_catalog.age_average_shortest_path(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)+
RETURNS agtype
LANGUAGE plpgsql
AS $function$                                                                                                        
DECLARE average_size numeric;                                                                                        
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	SELECT avg(age_size(a.edges)::int8::numeric)
	INTO average_size
	FROM age_shortest_path(graph_name, label, properties) as a;
	RETURN average_size;
END
$function$                                                                                                           


CREATE OR REPLACE FUNCTION ag_catalog.age_global_efficiency(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS agtype
LANGUAGE plpgsql
AS $function$
DECLARE ge agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;
	SELECT 1/ag_catalog.age_avg(age_size(a.edges))
	INTO ge
	FROM age_shortest_path(graph_name, label, properties) as a;
	RETURN ge;
END
$function$                                                                                                           



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

