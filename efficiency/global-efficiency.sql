CREATE OR REPLACE FUNCTION ag_catalog.age_global_efficiency(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
RETURNS agtype
LANGUAGE plpgsql
AS $function$
DECLARE ge agtype;
	sql VARCHAR;
BEGIN
	load 'age';
	SET search_path TO ag_catalog;
	SELECT 1/ag_catalog.age_avg(age_size(a.edges))
	INTO ge
	FROM age_shortest_path(graph_name, label, properties) as a;
	RETURN ge;
END
$function$                                                                                                           

