// Đếm số cạnh
MATCH ()-[r]->()
RETURN count(r) AS numberOfEdges;