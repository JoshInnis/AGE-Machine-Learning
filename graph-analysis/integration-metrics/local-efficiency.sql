 CREATE OR REPLACE FUNCTION age_ml.local_efficiency(graph_name name, label text DEFAULT NULL::text, properties agtype DEFAULT NULL::agtype)
  RETURNS TABLE(vertex agtype, local_efficiency agtype)
  LANGUAGE plpgsql
 AS $function$
 DECLARE ge agtype;
         sql VARCHAR;
 BEGIN
         load 'age';
         SET search_path TO ag_catalog;

         sql := format('SELECT
                 p.start_vertex, ag_catalog.age_avg(shortest.efficiency)::agtype as local_efficiency
                 FROM cypher(''%s''::name, $$
                         MATCH (start_vertex)-[]->(end_vertex)
                         RETURN start_vertex, end_vertex
                 $$) as p(start_vertex agtype, end_vertex agtype)
                 JOIN age_ml.efficiency(''%s''::name%s%s) as shortest
                 ON p.end_vertex = shortest.start_vertex
                 GROUP BY p.start_vertex;',
                 graph_name,
                 graph_name,
                 CASE
                         WHEN label IS NULL THEN ''
                         ELSE CONCAT(', label=> ''', label, '''') END,
                 CASE
                         WHEN properties IS NULL THEN ''
                         ELSE CONCAT(', properties=>''', properties::varchar, '''::agtype')
                 END);
         RETURN QUERY EXECUTE sql;
 END
 $function$

