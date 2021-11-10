CREATE OR REPLACE FUNCTION age_ml.average_shortest_path
   (graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS agtype
LANGUAGE plpgsql
AS $function$                                                                                                        
DECLARE average_size numeric;                                                                                        
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

        SELECT avg(age_size(a.edges)::int8::numeric)
        INTO average_size
        FROM age_shortest_path(graph_name, label, properties) as a;
        RETURN average_size;
END
$function$;
