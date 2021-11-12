CREATE OR REPLACE FUNCTION age_ml.create_lollipop_graph(graph_name name, m int, n int)
RETURNS SETOF agtype
LANGUAGE plpgsql
AS $function$
DECLARE complete_graph agtype;
        id agtype;
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

        select ag_catalog.age_id(ag_catalog.age_head(age_ml.create_complete_graph(graph_name, m)))
        INTO id;

        sql := format('SELECT * FROM cypher(''%s'', $$ MATCH (n) WHERE id(n) = %s CREATE (n)-[:edge]->(a_1), (n)<-[:edge]-(a_1),', graph_name, id);

        FOR i IN 2..n LOOP
            SELECT CONCAT(sql, age_ml.create_path_part(i - 1, i), ',')
            INTO sql;
        END LOOP;

        SELECT CONCAT(LEFT(sql, length(sql) - 1), age_ml.create_return_list(n), '$$) AS (a agtype);')
        INTO sql;

        EXECUTE sql;

END
$function$;

