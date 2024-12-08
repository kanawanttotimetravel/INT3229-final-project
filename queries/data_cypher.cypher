// Các bước đầu
// Tạo các ràng buộc
CREATE CONSTRAINT FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT FOR (t:Team) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT FOR (c:TeamChatSession) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT FOR (i:ChatItem) REQUIRE i.id IS UNIQUE;

// Tải dữ liệu từ chat_create_team_chat.csv
LOAD CSV FROM "file:///chat_create_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:Team {id: toInteger(row[1])})
MERGE (c:TeamChatSession {id: toInteger(row[2])})
MERGE (u)-[:CreatesSession {timeStamp: row[3]}]->(c)
MERGE (c)-[:OwnedBy {timeStamp: row[3]}]->(t);

// Tải dữ liệu từ chat_item_team_chat.csv
LOAD CSV FROM "file:///chat_item_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (t:TeamChatSession {id: toInteger(row[1])})
MERGE (c:ChatItem {id: toInteger(row[2])})
MERGE (u)-[:CreatesChat {timeStamp: row[3]}]->(c)
MERGE (c)-[:PartOf {timeStamp: row[3]}]->(t);

// Tải dữ liệu từ chat_join_team_chat.csv
LOAD CSV FROM "file:///chat_join_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Joins {timeStamp: row[2]}]->(c);

// Tải dữ liệu từ chat_leave_team_chat.csv
LOAD CSV FROM "file:///chat_leave_team_chat.csv" AS row
MERGE (u:User {id: toInteger(row[0])})
MERGE (c:TeamChatSession {id: toInteger(row[1])})
MERGE (u)-[:Leaves {timeStamp: row[2]}]->(c);

// Tải dữ liệu từ chat_mention_team_chat.csv
LOAD CSV FROM "file:///chat_mention_team_chat.csv" AS row
MERGE (c:ChatItem {id: toInteger(row[0])})
MERGE (u:User {id: toInteger(row[1])})
MERGE (c)-[:Mentioned {timeStamp: row[2]}]->(u);

// Tải dữ liệu từ chat_respond_team_chat.csv
LOAD CSV FROM "file:///chat_respond_team_chat.csv" AS row
MERGE (c1:ChatItem {id: toInteger(row[0])})
MERGE (c2:ChatItem {id: toInteger(row[1])})
MERGE (c1)-[:ResponseTo {timeStamp: row[2]}]->(c2);
