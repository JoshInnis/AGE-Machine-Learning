CREATE OR REPLACE FUNCTION age_ml.create_path_part(a int, b int)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $function$
DECLARE sql VARCHAR;
BEGIN
	sql := format(' (a_%s)-[:edge]->(a_%s), (a_%s)<-[:edge]-(a_%s)', a, b, a, b);
	RETURN sql;
END
$function$;

CREATE OR REPLACE FUNCTION age_ml.create_complete_graph(graph_name name, n int)
RETURNS VOID
LANGUAGE plpgsql
AS $function$
DECLARE trans agtype;
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

	PERFORM create_graph(graph_name);

	sql := format('SELECT * FROM cypher(''%s'', $$ CREATE', graph_name);

	FOR i IN 1..n LOOP
		FOR j IN i+1 .. n LOOP
			SELECT concat(sql, age_ml.create_path_part(i, j), ',')
			INTO sql;
		END LOOP; 
	END LOOP;



	SELECT CONCAT(LEFT(sql, length(sql)-1 ), '$$) AS (a agtype);')
	INTO sql;

	EXECUTE sql;

END
$function$;

