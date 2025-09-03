// 로컬 컴퓨터 내 db목록확인
show dbs

// 특정 db에 접속하고자할때
use funcoding
use nosql01

//특정 DB 안에 콜렉션 보기
show collections

// 특정 컬렉션 안에 데이터를 확인하고자 할때
db.test.find()
db.stats()
// 특정 db를 삭제하고자 할때
db.dropDatabase()

use funcoding

//특정 db안에 컬렉션을 삭제
db.test.drop()

// 컬렉션 생성 -> CLI(명령어)방식 vs GUI 방식
db.createCollection("test")

use funcoding

/*
1) 특정옵션없이 단순 컬렉션 생성 방식 
2) 별도의 옵션을 설정해서 컬랙션을 생성하는 방식!
옵션 목록
 - capped : true => 컬렉션의 구조의 설정을 감싸 안겠다. 고정된 크기의 컬렉션을 갖도록하겠다.
 - size : byte => capped의 사이즈를 설정해주는 옵션. byte의 단위로 입력하게끔 되어있음.
         컴퓨터는 2진수로 데이터를 처리, 2진법으로 데이터 처리. 저장 단위의 최소단위 bit
 - max => 해당 컬렉션 안에 저장할 수 있는 데이터 (= 문서), 몇개의 문서를 허용할 것인가를 의미 
 - autoIndexId : true => sql에서의 primary key 값이라고 보면됨! 모든 문서를 생성할 때 마다 _id 필드에 대한 값을 자동으로 설정할 것인가에 대한 여부
*/
db.createCollection("log",{
    capped : true,
    size : 5242880,
    max : 5000    
}, )

show collections

db.log.isCapped()
db.test.isCapped()

// 이미 생선된 컬렉션 이름을 수정
db.log.renameCollection("test01")

// ---------------- 문서에 들어오는 값을 정의해주는 함수 --------
//문서가 db안에 컬렉션에 생성되었을떄
/*
기존 SQL문법 :
INSERT INTO 테이블명(필드명) VALUES (밸류값);
NoSQL 문법 :
db.컬렉션명.옵션(){객체의 형태로 키 : "밸류" }
ex) db.collectionname.insertOne({
    name: "David",
    age : 20,
    status : "pending"
})

db.collectionname.insertMany(
    [
        {subject : "coffee", author :"abc", views:50},
        {subject : "shopping", author :"def", views:100},
    ]
)
*/

db.createCollection("users")
db.users.insertOne(
    {subject : "coding", author :"funcoding", views : 50}
)
// 해당 컬렉션 내부에 있는 값을 확인하고자 할 때 
db.users.find()

// 해당 컬렉션 내부에 여러개의 문서를 동시에 입력
db.users.insertMany(
    [
        {subject : "coffee", author :"xyz", views : 50},
        {subject : "Coffee Shopping", author :"efg", views : 5},
        {subject : "Baking", author :"avc", views : 90},
        {subject : "bake", author :"xyz", views : 100},
        {subject : "cafe", author :"abc", views : 200}        
    ]
)
// No-SQL 구문/문법은 SQL 대비 상대적으로 유연한 문법 체계를 가지고 있음 
// {subject : "bake", author :"xyz", views : "zyt"} -> 마지막의 views가 문자열로 넣어도 들어가긴함! But 나중에 값을 일괄처리할 때 오류..
// SQL내에서 schema를 정의했던 것처럼 NoSQL에서도 사전에 Schema Validation 유효성 기능설정 가능! (사실 그러면 NoSQL을 쓰는 의미가 없음)
// 키에 들어오는 값의 형태를 지정하는 방법!! 
db.createCollection("users2",{
    validator : {
        $jsonSchema : {
            bsonType: "object",
            required: ["subject","author","views"],
            properties:{
                subject : {
                    bsonType :"string",
                    description :"must be a string and is required"
                },
                author : {
                    bsonType :"string",
                    description :"must be a string and is required"
            },
            views : {
                    bsonType :"int",
                    description :"must be a integer and is required"
        },
    }
},
validationAction :"error"}
});

db.users.drop()

/*
미션
users 컬렉션 생성
컬렉션 사이즈는 10만 byte
다음과 같은 데이터를 삽입
name, age, address 키

David, 45 , "서울"
Dave, 25, "경기도"
Andy, 50, "골프", "경기도"
Cate, 35, "수원시"
Brown, 8 
*/

db.createCollection("users",{
    capped : true,
    size : 100000,
    max : 10000    
}, )

db.users.insertMany( [ 
    {name : "David",age:45,address :"서울" },
    {name : "Dave",age:25,address :"경기도" },
    {name : "Andy",age:50,address :"경기도" , hobby : "골프" },
    {name : "Cate",age:35,address :"수원시" },
    {name : "Brown",age:8 }
    ]
)


db.users.find()
// 특정 조건에 해당되는 값을 찾아오는 함수
/* 
해당 컬렉션(테이블)의 모든 값을 찾아오기
SQL 
SELECT * FROM users;
No-SQL
db.users.find()
{}는 
SQL 
SELECT _id, name, address FROM users
No-SQL
db.users.find({},{name :1,adress:1}) 1은 찾아오라는 의미! 트루시안 값

SQL 
SELECT _id, name, address FROM users
No-SQL
db.users.find({},{name :1, address :1, _id : 0}) 0은 찾아오지 말라는 의미! 펄시한 값

SQL 
SELECT * FROM users WHERE address = "서울";
No-SQL
db.users.find({address:"서울"})
*/ 


// findOne() : 최초에 검색, 매칭되어지는 한개의 document를 찾아온다.

// 어떤 쿼리의 조건을 의미하는 명칭 : query criteria(*기준)

/*
조건걸기
db.users.find(
    {age : {$GT:18}},
    {name: 1, address : 1,id_0}
).limit(5)
*/
db.users.find(
    {age : 18},
    {name: 1, address : 1}
).limit(5)


/*

users collection에서 Dave인 문서의 name, age, address,_id를 출력!

*/
db.users.find({name:"Dave"},{hobby : 0})

db.users.find(
{name:"Cate"},
{name:1,age:1}
)

// 비교연산자 
/*

$eq : -> 같다. 동일하다
$gt : -> ~보다 크다. 초과
$gte : -> ~보다 크거나 같다. 이상
$lt : -> ~보다 작다. 미만
$lte : -> ~보다 작거나 같다. 이하
$nin // $in -> not in 없음 / in 있음

SQL
SELECT * FROM users WHERE age >25;
NoSQL
db.users.find({age:{$gt: 25}})
SQL
SELECT * FROM users WHERE age <25;
NoSQL
db.users.find({age:{$lt: 25}})
SQL
SELECT * FROM users WHERE age >25 AND age <= 50;
NoSQL
db.users.find({age:{$lte: 50, $gt: 25}})


*/

db.users.find(
    {age:{$lte:10}};
    
db.users.find(
    {age:{$in:[45,50]}}
)

db.users.find({age:{$lte: 50, $gt: 40}})


db.users.find(
    {age:{$nin:[45,50]}}
)
db.users.find(
    {age:{$ne:45}}
)

/*

1) age가 20보다 큰 문서의 name만 출력,
2) age 가 50이고 address 가 경기도인 문서의 name만 출력
3) age가 30보다 작은 문서의 namer과 age 출력

*/
explain()
db.users.find(
    {age :{$gt:20}},
    {name:1,_id:0}
)
db.users.find(
    {age :50, address:"경기도"},
    {name:1,_id:0}
)
db.users.find(
    {age :{$eq:50}, address:"경기도"},
    {name:1,_id:0}
)
db.users.find(
    {age :{$lt:30}},
    {name:1,age:1,_id:0}
)

// --------------------------------------- 논리연산 문법 -------------------------
/*

SELECT * FORM users WHERE address = "서울" AND age = 45; - 두가지 조건을 다 충족해야함
db.users.find(
    {$and : [{address:"서울"},{age: 45}]}
)
db.users.find(
    {$or : [{address:"경기도"},{age: 45}]}
)

SELECT * FROM users WHERE age != 45;

db.users.find(
    {{age: {$not :{$eq:45}}} -- 이퀄(eq) 생략 불가!
)db.users.find(
    {{age: {$ne:45}}
)
*/

db.users.find(
    {$and:[{address:"서울"},{age:{$eq:45}}]}
)

// name이 Brown이거나 age가 35인 모든 값을 출력
db.users.find(
    {$or :[{name:"Brown"},{age:{$eq:35}}]}
)
db.users.find(
    {$or :[{name:"Brown"},{age:35}]}
)

//정규표현식 -> 어떤 특정 문자열을 찾아오도록 설정 => 패턴
//해당 패턴에 부가적으로 옵션 설정 가능 -> 플래그 
db.users.find({name:{$regex:/Da/}})
// = SQL SELECT * FROM users WHERE name like "%Da%"

/*

정규표현식
name 키(필드명) > 값이 "DA"로 시작하는 모든 문서를 찾아라!
db.users.find(
    {name:{$regex:/^Da/}} - Da로 시작
)
db.users.find(
    {name:/^Da/}} - Da로 시작 축약문
)

*/


// ----------------------------------------------정렬 (sort) -------------------------------
/*SQL
SELECT * FROM users WHERE address = "경기도" ORDER BY ASC;
db.users.find(
    {address:"경기도"}
).sort({age:1}) -- ASC이 기본적인 디폴트 값
db.users.find(
    {address:"경기도"}
).sort({age:-1}) -- DESC이 기본적인 디폴트 값

*/
db.users.find(
    {address:"경기도"}
).sort({age:1})
db.users.find(
    {address:"경기도"}
).sort({age:-1})

// 현재 컬렉션 내 문서의 갯수를 확인하고자 할때, 사용하는 함수 count()
// 정석 구문
db.users.find().count()
// 예외 축약문
db.users.count()

// 현재 컬렉션 1,(조건) 내 필드 존재 여부로 2, 문서의 갯수를 확인 : $exists => 속성
// $가 있다는 것은 NoSQL에서 예약어로 사용되고 있다는 의미! (연산자다! X)
// $가 붙어있는 예약어 中에서 연산자인 속성이 있는것

// 정석
db.users.find({address:{$exists:true}}).count()
// 축약문
db.users.count({address:{$exists:true}}) // address가 있는 문서의 갯수를 찾아옴!
db.users.count({address:{$exists:false}}) // address가 없는 brown 1개를 찾아옴

// ------------ 중복제거 : distinct ------------
/*
SQL
SELECT DISTINCT(address) FROM users;

NoSQL
db.users.distinct("address")
*/
/*
-------------- 결과 값이 같은 비슷한 구문
db.users.findOne()
= db.users.find().limit(1)
*/

db.users.distinct("address")
db.users.find().limit(2)

//----------------------  데이터 수정!!! ----------------------- 
//이미 생성된 컬렉션 안에 신규 값을 추가!!! -> [] 사용. 배열 안에 각각의 값은 객체형태({})
db.users.insertMany(
    [
        {name:"유진",age:25,hobbies:["독서","영화","요리"]},
        {name:"동현",age:30,hobbies:["축구","음악","영화"]},
        {name:"해진",age:35,hobbies:["요리","여행","독서"]}
    ]
)


// 추가된 컬럼값을 필터링없이 다 받아줌!
db.users.find()

// hobbies 에서 중복된 값을 찾기
// $all : 배열 자료구조를 갖고있는 필드에서 조건에 충족되는 '모든 값을 포함'하는 문서를 찾아올 떄
db.users.find(
{hobbies:{$all :["축구","음악"]}}) 
// [,] -> and!

/* SQL 구문
SELECT * FROM users WHERE hobbies LIKE "%축구%" AND "%음악%"
*/

// ------ document 수정 ------
/*
1) updateOne (*정석) / update (*축약) 
 - 매칭되는 1개의 문서를 업데이트 할 때 사용
2) updateMany
 - 매칭되는 모든 문서를 업데이트 할 때 사용
*/


db.users.updateMany(
{age:{$gt:25}},{$set: {address:"서울"}}
)
/* SQL 구문
UPDATE users SET address = "서울" WHERE age >25;
*/

db.users.updateMany(
{age:{$gt:40}},{$set: {address:"수원시"}}
)
db.users.find()

db.users.updateOne(
    {name:"유진"},{$set:{age:25}}
)

// NEXT ->->->-> "NoSQL 04 기초구문2.js"
