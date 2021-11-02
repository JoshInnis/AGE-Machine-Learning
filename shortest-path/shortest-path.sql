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

CREATE OR REPLACE FUNCTION ag_catalog.age_shortest_path(graph_name agtype, v1 agtype, v2 agtype)
RETURNS agtype
LANGUAGE plpgsql
VOLATILE
AS $BODY$
DECLARE edges agtype;
	sql VARCHAR;
BEGIN
	
	sql := format('SELECT *
		FROM cypher(''%s''::name, $$
			MATCH (v1)-[e*]->(v2)
			WHERE id(v1) = %s AND id(v2) = %s
			RETURN min(e)
		$$) AS (a agtype);',
			substring(graph_name::varchar, 2,ag_catalog.age_size(graph_name)::int)::name, v1, v2);
	EXECUTE sql
	INTO edges;
	RETURN edges;
END
$BODY$;

