CREATE OR REPLACE FUNCTION age_ml.create_directed_path_part(a int, b int)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $function$
DECLARE sql VARCHAR;
BEGIN
        sql := format(' (a_%s)-[:edge]->(a_%s),', a, b);
        RETURN sql;
END
$function$;

CREATE OR REPLACE FUNCTION age_ml.create_watts_strogatz_graph(graph_name name, n int, k int, b float)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $function$
DECLARE complete_graph agtype;
        sql VARCHAR;
        ridx INT;
        lst INT[];
BEGIN
        load 'age';
        SET search_path TO ag_catalog;


        sql := format('SELECT * FROM cypher(''%s'', $$ CREATE ', graph_name);

        FOR i IN 1..n LOOP

            lst := ARRAY[i];
            FOR idx in 1..CEIL(k/2) LOOP
                lst := lst || ARRAY[idx] || ARRAY[(-1 * idx)];

            END LOOP;

            FOR j in 0..(CEIL(k/2) - 1) LOOP

                IF random() <= b::float THEN
                    ridx := i;
                    WHILE ARRAY[ridx] <@ lst LOOP
                        ridx := CEIL(n * random());
                    END LOOP;

		    lst := lst || ARRAY[ridx];	
                    SELECT CONCAT(sql, age_ml.create_directed_path_part(i, ridx))
                    INTO sql;

                ELSE
                    SELECT CONCAT(sql, age_ml.create_directed_path_part(i,
                        CASE WHEN i + j = n THEN 1 WHEN i + j > n THEN 1 + j ELSE 1 + (i + j) END))
                    INTO sql;
                END IF;

                IF random() <= b::float THEN
                    ridx := i;
                    WHILE ARRAY[ridx] <@ lst LOOP
                        ridx := CEIL(n * random());
                    END LOOP;

		    lst := lst || ARRAY[ridx];	
                    --//ridx := CEIL(n * random()); 
                    SELECT CONCAT(sql, age_ml.create_directed_path_part(i, ridx))
                    INTO sql;

                ELSE
                SELECT CONCAT(sql, age_ml.create_directed_path_part(
                    CASE WHEN i - (1 + j) = 0 THEN n WHEN i - (1 + j) < 0 THEN n - j ELSE i  - (1 + j) END,
                    i
                    ))
                INTO sql;
                END IF;

            END LOOP;
        END LOOP;

        SELECT CONCAT(LEFT(sql, length(sql) - 1), '$$) AS (a agtype);')
        INTO sql;

        EXECUTE sql;
        RETURN sql;
END
$function$;
