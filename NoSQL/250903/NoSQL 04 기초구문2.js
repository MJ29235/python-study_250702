// ------------------특정 조건에 부합하는 경우 통으로 문서를 대체할 수 있는 구문 ------------
db.users.find()

db.users.updateOne(
    {name:"동현"},
    {$set :{name:"동현2세", age:31,hobbies:["축구","음악","영화"]}}
)

db.users.find(
    {name:"동현2"}
)

// --------------------특정 조건에 따라서 '필드를 제거'하는 문법(구문) --------------
db.users.updateOne(
    {name:"유진"},{$unset:{age:1}}
)
db.users.find()

// --------------------특정 조건을 '만족하지 않는 경우에 추가'하는 문법(구문) --------------
db.users.updateOne(
{name:"민준"} , {$set:{name:"민준",age:22,hobbies:["음악","여행"]}}
)
// -> 조건값에 충족되지 않아서 안나옴! 

db.users.updateOne(
{name:"민준"} , {$set:{name:"민준",age:22,hobbies:["음악","여행"]}},{upsert:true}
)
db.users.find()

db.users.updateOne(
{name:"유진"},{$set:{age:30}})

db.users.updateOne(
{name:"유진"},{$set:{hobbies:"운동"}}) // -> 날아가버림

db.users.updateOne(
{name:"유진"},{$set:{hobbies:["운동","요리"]}}) // -> 다시 배열로 바꿈

//-----------------특정 컬럼 내 배열 형태의 자료에서 값을 추가 : push ---------------------
db.users.updateOne(
{name:"유진"},{$push:{hobbies:"영화"}}) // -> 기존 배열을 놔두고 뒤에서부터 값을 추가! 영화가 추가됨!

db.users.find()
//-----------------특정 컬럼 내 배열 형태의 자료에서 값을 제거 : pull ---------------------
db.users.updateOne(
{name:"유진"},{$pull:{hobbies:"영화"}}) // -> 영화가 제거됨

//----------------- 문서 삭제 --------------------------
/*
특정 컬렉션 안에 값을 추가할 때에도 단일값 & 다중값 적용
값을 수정, 삭제 할 때에도 단일값 & 다중값 적용
*/
// 문서를 제거 할 때는 deleteOne(), deleteMany()
/*SQL 
DELETE FROM users WHERE address="서울";
DELETE FROM users;

NoSQL
db.users.deleteMany( -> 복수의 값을 제거
{adress:"서울"})

*/
db.users.deleteMany(
{adress:"서울"})

db.users.deleteMany( // -> 수원시를 가지고 있는 데이터 다 날아감 
{address:"수원시"})
db.users.find()
// 데이터 추가
db.users.insertMany(
    [
        {name:"David",age:45,address:"서울"},
        {name:"DaveLee",age:25,address:"경기도"},
        {name:"Andy",age:50,hobby:"골프",address:"경기도"},
        {name:"Kate",age:35,address:"수원시"}
    ]
)


db.users.deleteMany(
{age:{$lt:30}}

)
db.users.find()
// -----------> ISODate() '날짜 정의 함수', 이 함수를 써야지 문자열이 아닌 날짜로 인식 : 인자값에 "2025-08-15T10:00:00Z" 이런형식!(시간생략 가능)
db.users.insertMany(
    [
        {name:"A",age:20,address:"경기도",date:ISODate("2025-08-15T10:00:00Z")},
        {name:"B",age:30,address:"서울",date:ISODate("2025-06-15T10:00:00Z")} 
    ]
)

db.users.find()

//-------------- 일괄적으로 값을 증가시키는 방법(함수) 특정 조건에 부합했을때 상대되는 값을 얼만큼 증가시켜줄 것인가  --------------
db.users.updateMany(
{address:"경기도"},{$inc:{age:1}})

db.users.deleteMany(
{date: {$lt: ISODate("2025-09-01")}})  // -> 이 날짜보다 작은 날짜들을 날려버림! 