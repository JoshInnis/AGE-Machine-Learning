# Introduction


## Shortest Path

Algorithms used to computed the shortest path between 2 vertices where there is no weights on the edges.

### Shortest Paths for a Graph

This function will compute the shortest paths between to vertices for every pair of vertices in the given graph.

#### Syntax

```
age_ml.shortest_path(graph_name, label, properties)
```

#### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run shortest path on | 
| label | text | true | Only edges of the specified label will be included in the search. |
| properties | agtype | true | The passed in Agtype map will be used to filter edges that have matching properties. Any non map agtype values will throw an error. |

#### Returns

Function returns a Table consisting of three columns:

| name | type | description |
| --- | --- | --- |
| start_vertex | agtype | the start vertex for the given path |
| end_vertex | agtype | the end vertex for the given path |
| edges | agtype | A agtype list containing the edges for the shortest path between the two vertices

#### Examples

##### Get Shortest Path for all Vertices

When all edges are acceptable, the label and properties fields can be excluded from the function call.

```
SELECT * 
FROM age_ml.shortest_path('reddit_hyperlinks');
```

### Shortest Path for a Single Path

This function will compute the shortest path between two vertices


## Neighborhood

#### Syntax
```
age_ml.neighborhood(graph_name)
```
#### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run neighborhood on |

#### Returns

Function returns a Table consisting of two columns:

| name | type | description |
| --- | --- | --- |
| vertex | agtype | the vertex that the neighborhood is for |
| neighborhood | agtype | An agtype list of vertices that are the vertex's neighboor |


## Triangles

### Directed Triangles

#### Syntax
```
age_ml.directed_triangles(graph_name)
```
#### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run shortest path on |

#### Returns

Function returns a Table consisting of three columns:

| name | type | description |
| --- | --- | --- |
| a | agtype | the first vertex for the triangle |
| b | agtype | the second vertex for the triangle |
| c | agtype | the third vertex for the triangle |



### Undirected Triangles

#### Syntax
```
age_ml.undirected_triangles(graph_name)
```
#### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run shortest path on |

#### Returns

Function returns a Table consisting of three columns:

| name | type | description |
| --- | --- | --- |
| a | agtype | the first vertex for the triangle |
| b | agtype | the second vertex for the triangle |
| c | agtype | the third vertex for the triangle |



