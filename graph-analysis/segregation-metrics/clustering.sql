CREATE OR REPLACE FUNCTION age_ml.clustering
    (graph_name name)
RETURNS TABLE(a agtype, cnt agtype)
LANGUAGE plpgsql
AS $function$
DECLARE sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

        sql := format('SELECT t.a,
                        (
                            SELECT COUNT(1.0)::agtype
                            FROM age_ml.neighborhood(''%s'') n
                            WHERE ag_catalog.agtype_in_operator(t.neighborhoud, n.a)
                        )::bigint::decimal/ag_catalog.age_size(t.neighborhoud)
                        FROM age_ml.neighborhood(''%s'') as t;',
                        graph_name, graph_name);
        RETURN QUERY EXECUTE sql;
END
$function$;

