CREATE OR REPLACE FUNCTION age_ml.closed_triplets
    (graph_name name)
RETURNS TABLE(a agtype, b agtype, c agtype)
LANGUAGE plpgsql
AS $function$
DECLARE ge agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;

	sql := format('SELECT DISTINCT *
		FROM cypher(''%s''::name, $$ 
			MATCH (a)-[]-(b)-[]-(c)
			RETURN a, b, c
		$$) as (a agtype, b agtype, c agtype)',
		graph_name);
	RETURN QUERY EXECUTE sql;
END
$function$;

