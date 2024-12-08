CALL gds.pageRank.stream('userGraph', {maxIterations: 20})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS user, score
ORDER BY score DESC
LIMIT 10;
