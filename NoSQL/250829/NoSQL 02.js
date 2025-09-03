db.createCollection("users")

// 값을 넣어보기 insertOne() -> 데이터를 행의 형식으로 넣겠다! 
db.users.insertOne(
    {subject:"coding",author:"david",views:50}
)
db.users.find()

