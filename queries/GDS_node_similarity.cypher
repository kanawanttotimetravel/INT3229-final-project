// Tính độ tương đồng
CALL gds.nodeSimilarity.stream('userGraph')
YIELD node1, node2, similarity
WHERE node1 <> node2 AND similarity < 1  // Loại trừ similarity = 1 và các cặp nút giống nhau
RETURN gds.util.asNode(node1).id AS user1, gds.util.asNode(node2).id AS user2, similarity
ORDER BY similarity DESC
LIMIT 10;