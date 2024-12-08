// Q1-a
// Tìm chuỗi hội thoại dài nhất trong dữ liệu chat sử dụng nhãn mối quan hệ "ResponseTo". Câu hỏi này có hai phần:
// Bao nhiêu tin nhắn tham gia vào chuỗi hội thoại này?
MATCH p=(start:ChatItem)-[:ResponseTo*]->(end:ChatItem)
RETURN p, length(p) AS longestChainLength
ORDER BY longestChainLength DESC
LIMIT 1;

// Q1-b
// Có bao nhiêu người dùng tham gia vào chuỗi này?
// Lấy độ dài của chuỗi dài nhất
MATCH p=(start:ChatItem)-[:ResponseTo*]->(end:ChatItem)
WITH length(p) AS longestChainLength
ORDER BY longestChainLength DESC
LIMIT 1

// Tìm tất cả các đường đi có độ dài này
MATCH p=(start:ChatItem)-[:ResponseTo*]->(end:ChatItem)
WHERE length(p) = longestChainLength
WITH p

// Lấy người dùng tham gia vào các đường đi này
MATCH (u:User)-[:CreatesChat]->(ci:ChatItem)
WHERE ci IN nodes(p)
RETURN count(distinct u) AS numberOfUsers;