# Shortest Path

Algorithms used to computed the shortest path between 2 vertices where there is no weights on the edges.

## Shortest Paths for a Graph

This function will compute the shortest paths between to vertices for every pair of vertices in the given graph.

### Syntax

```
age_ml._shortest_path(graph_name, label, properties)
```

### Parameters

| name | type | required | default value | description |
| --- | --- | --- | --- | --- |
| graph_name | name  | yes | N/A | The name of the graph to run shortest path on | 
| label | text | no | NULL | When the field is not NULL, only edges of the specified label will be included in the search |
| properties | agtype | no | NULL | When the field is not NULL, the passed in Agtype map will be used to filter edges that have matching properties. Any non map agtype values will throw an error. |

### Returns

Function returns a Table consisting of three columns

| name | type | description |
| --- | --- |
| start_vertex | agtype | the start vertex for the given path |
| end_vertex | agtype | the end vertex for the given path |
| edges | agtype | A agtype list containing the edges for the shortest path between the two vertices

### Examples

#### Get Shortest Path for all Vertices

When all edges are acceptable, the label and properties fields can be excluded from the function call.

```
SELECT * 
FROM age_ml._shortest_path('reddit_hyperlinks');
```

## Shortest Path for a Single Path

This function will compute the shortest path between two vertices

