// Q2-a
// Phân tích mối quan hệ giữa 10 người dùng sôi nổi nhất và 10 nhóm trò chuyện sôi nổi nhất

// Người dùng sôi nổi nhất

// Truy vấn tìm 10 người dùng sôi nổi nhất
MATCH (u:User)-[:CreatesChat]->(c:ChatItem)
RETURN u.id AS userId, count(c) AS chatCount
ORDER BY chatCount DESC
LIMIT 10;

// Q2-b
// Các nhóm trò chuyện sôi nổi nhất

// Truy vấn tìm 10 nhóm trò chuyện sôi nổi nhất
MATCH (ci:ChatItem)-[:PartOf]->(tcs:TeamChatSession)-[:OwnedBy]->(t:Team)
RETURN t.id AS teamId, count(ci) AS chatCount
ORDER BY chatCount DESC
LIMIT 10;

// Q2-c
// Bước 1: Xác định 10 người dùng sôi nổi nhất
WITH [394, 2067, 1087, 209, 554, 1627, 516, 999, 668, 461] AS topChattiestUsers

// Bước 2: Xác định 10 nhóm trò chuyện sôi nổi nhất
WITH topChattiestUsers, [82, 185, 112, 18, 194, 129, 52, 136, 146, 81] AS topChattiestTeams

// Bước 3: Tìm người dùng thuộc các nhóm sôi nổi nhất
MATCH (u:User)-[:CreatesChat]->(:ChatItem)-[:PartOf]->(:TeamChatSession)-[:OwnedBy]->(t:Team)
WHERE u.id IN topChattiestUsers
AND t.id IN topChattiestTeams
RETURN DISTINCT u.id AS User, t.id AS Team
