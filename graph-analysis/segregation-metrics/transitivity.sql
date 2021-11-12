CREATE OR REPLACE FUNCTION age_ml.transitivity
    (graph_name name)
RETURNS agtype
LANGUAGE plpgsql
AS $function$
DECLARE trans agtype;
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

sql := format('SELECT
        (
        SELECT count(*)
        FROM age_ml.closed_triplets(''%s'')
        ) / 
        (SELECT 3 * (count(*) - 3) + 1  FROM %s._ag_label_vertex) as max_triangles;
', graph_name, graph_name);

EXECUTE sql INTO trans;
RETURN trans;
/*
        sql := format('SELECT DISTINCT *
                FROM cypher(''%s''::name, $$ 
                        MATCH (a)-[]-(b)-[]-(c)
                        RETURN a, b, c
                $$) as (a agtype, b agtype, c agtype)',
                graph_name);
        RETURN QUERY EXECUTE sql;
*/
END
$function$;


