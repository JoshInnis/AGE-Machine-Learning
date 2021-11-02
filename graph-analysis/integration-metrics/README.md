# Integration Analysis Metrics

Functions used to measure how interconnected the vertices in a graph are.

## Unweighted Average Shortest Path

Computes the average length of all shortest paths between all vertices in a graph.

### Syntax

```
ag_ml.average_shortest_path(graph_name, label, properties)
```

### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run efficiency on |
| label | text | true | Only edges of the specified label will be included in the analysis
| properties | agtype | true | The passed in Agtype map will be used to filter edges that have matching properties. Any non map agtype values will throw an error. |

### Returns
An Agtype Float or Integer


## Unweighted Efficiency

Efficiecy is the measure of how effectly a graph exchanges information. It is measured as the inverse of the shortest distance between two vertices.

### Syntax

```
age_ml.efficency(graph_name, label, properties)
```

### Parameters

| name | type | optional | description |
| --- | --- | --- | --- |
| graph_name | name  | false | The name of the graph to run efficiency on |
| label | text | true | Only edges of the specified label will be included in the analysis
| properties | agtype | true | The passed in Agtype map will be used to filter edges that have matching properties. Any non map agtype values will throw an error. |

### Returns

Function returns a Table consisting of three columns:

| name | type | description |
| --- | --- | --- |
| start_vertex | agtype | The start vertex for the given path. |
| end_vertex | agtype | The end vertex for the given path. |
| efficiency | agtype | A agtype numeric representing the efficiency of the two vertices. |

## Unweighted Local Efficiency

## Unweighted Global Efficiency

