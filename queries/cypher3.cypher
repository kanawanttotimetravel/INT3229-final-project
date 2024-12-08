// Q3-a
// Tạo mối quan hệ InteractsWith dựa trên việc đề cập (Mentioned)
MATCH (u1:User)-[:CreatesChat]->(:ChatItem)-[:Mentioned]->(u2:User)
CREATE (u1)-[:InteractsWith]->(u2);

// Tạo mối quan hệ InteractsWith dựa trên việc phản hồi (ResponseTo)
MATCH (u1:User)-[:CreatesChat]->(:ChatItem)-[:ResponseTo]->(:ChatItem)<-[:CreatesChat]-(u2:User)
CREATE (u1)-[:InteractsWith]->(u2);

// Xóa các vòng lặp tự (self-loops) trong mối quan hệ InteractsWith
MATCH (u:User)-[r:InteractsWith]->(u)
DELETE r;

// Q3-b
MATCH (u:User)-[c:CreatesChat]->()
WITH u, COUNT(c) as Chats
ORDER BY Chats DESC LIMIT 10 WITH [u] as ChattiestUsers

// Lấy các hàng xóm của tất cả người dùng và đếm số lượng
MATCH (u1:User)-[:InteractsWith]->(u2:User)
WHERE u1 IN ChattiestUsers
WITH u1.id AS UserID, COLLECT(DISTINCT u2.id) AS Neighbours
RETURN UserID, Neighbours, SIZE(Neighbours) AS k

// Q3-c
// Lấy top 10 người dùng sôi nổi nhất
MATCH (u:User)-[c:CreatesChat]->()
WITH u, COUNT(c) AS Chats
ORDER BY Chats DESC
LIMIT 10
WITH COLLECT(u) AS ChattiestUsers

// Lấy hàng xóm của 10 người dùng sôi nổi nhất và đếm số lượng
MATCH (u1:User)-[:InteractsWith]->(u2:User)
WHERE u1 IN ChattiestUsers
WITH u1.id AS UserID, COLLECT(DISTINCT u2.id) AS Neighbours, SIZE(COLLECT(DISTINCT u2.id)) AS k

// Tìm các người dùng giao thoa (Intersecting Users)
MATCH (u1:User)-[:InteractsWith]->(u2:User)
// Đảm bảo rằng cả hai người dùng đều thuộc danh sách hàng xóm
WHERE u1.id IN Neighbours AND u2.id IN Neighbours
// Đối với mỗi kết hợp hợp lệ của người dùng và hai hàng xóm của họ,
// Giá trị bằng 1 nếu các hàng xóm đã tương tác ít nhất một lần, k là số lượng hàng xóm
WITH DISTINCT UserID, u1.id AS N1, u2.id AS N2, CASE WHEN (u1)-[:InteractsWith]->(u2) THEN 1 ELSE 0 END AS VALUE, k
WITH UserID, SUM(VALUE) AS NUM, k, k*(k-1) AS DENUM
RETURN UserID, NUM, DENUM, NUM/(DENUM*1.0) AS ClusteringCoefficient
ORDER BY ClusteringCoefficient DESC

