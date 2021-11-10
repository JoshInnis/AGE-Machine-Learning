CREATE OR REPLACE FUNCTION age_ml.directed_triangles
    (graph_name name)
RETURNS SETOF agtype
LANGUAGE plpgsql
AS $function$
DECLARE sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	sql := format('SELECT *
		FROM cypher(''%s''::name, $$ 
			MATCH p=(a)-[]->(b)-[]->(c)-[]->(a)
			RETURN p
		$$) as (p agtype)',
		graph_name);
	RETURN QUERY EXECUTE sql;
END
$function$;
