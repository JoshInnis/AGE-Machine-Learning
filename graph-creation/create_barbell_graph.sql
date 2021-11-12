CREATE OR REPLACE FUNCTION age_ml.create_barbell_graph(graph_name name, m int, n int)
RETURNS SETOF agtype
LANGUAGE plpgsql
AS $function$
DECLARE complete_graph agtype;
        id1 agtype;
        id2 agtype;
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

        select ag_catalog.age_id(ag_catalog.age_head(age_ml.create_complete_graph(graph_name, m)))
        INTO id1;

        select ag_catalog.age_id(ag_catalog.age_head(age_ml.create_complete_graph(graph_name, m)))
        INTO id2;


        sql := format('SELECT * FROM cypher(''%s'', $$ MATCH (n), (m) WHERE id(n) = %s AND id(m) = %s CREATE (n)-[:edge]->(a_1), (n)<-[:edge]-(a_1),', graph_name, id1, id2);

        FOR i IN 2..n LOOP
            SELECT CONCAT(sql, age_ml.create_path_part(i - 1, i), ',')
            INTO sql;
        END LOOP;


        SELECT CONCAT(sql, format(' (a_%s)-[:edge]->(m), (a_%s)<-[:edge]-(m) $$) AS (a agtype);', n, n))
        INTO sql;

        EXECUTE sql;

END
$function$;

