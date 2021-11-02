CREATE OR REPLACE FUNCTION age_ml.neighborhood
    (graph_name name)
RETURNS TABLE(a agtype, neighborhoud agtype)
LANGUAGE plpgsql
AS $function$
DECLARE sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	sql := format('SELECT *
		FROM cypher(''%s''::name, $$ 
			MATCH (a)-[]-(b)
			WHERE a <> b
			RETURN a, collect(b)
		$$) as (a agtype, neighborhood agtype)
		UNION ALL 
		SELECT *
		FROM cypher(''%s''::name, $$ 
			MATCH (a)
			WHERE NOT EXISTS ((a)-[]-())
			RETURN a, []
		$$) as (a agtype, neighborhood agtype);',
		graph_name, graph_name);
	RETURN QUERY EXECUTE sql;
END
$function$;
