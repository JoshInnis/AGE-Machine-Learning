CREATE OR REPLACE FUNCTION age_ml.undirected_triangles
    (graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS TABLE(a agtype, b agtype, c agtype)
LANGUAGE plpgsql
AS $function$
DECLARE ge agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	sql := format('SELECT *
		FROM cypher(''%s''::name, $$ 
			MATCH (a)-[]-(b)-[]-(c)-[]->(a)
			RETURN a, b, c
		$$) as (a agtype, b agtype, c agtype)',
		graph_name);
	RETURN QUERY EXECUTE sql;
END
$function$;

