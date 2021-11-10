CREATE OR REPLACE FUNCTION age_ml.average_clustering
   (graph_name name)
RETURNS agtype
LANGUAGE plpgsql
AS $function$                                                                                                        
DECLARE average_size numeric;                                                                                        
        sql VARCHAR;
BEGIN
        load 'age';
        SET search_path TO ag_catalog;

        SELECT ag_catalog.age_avg(a.clustering_coefficient)
        INTO average_size
        FROM age_ml.clustering(graph_name) as a;
        RETURN average_size;
END
$function$;
