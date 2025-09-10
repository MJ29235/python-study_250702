use sample_mflix
db.movies.find()

db.movies.find()
db.comments.find()
// -------------------- aggregate 문법 써보기! ----------------
// $match
db.movies.aggregate(
    [
        {$match: {year: 1995}}
    ]
)
// $group {} 안에는 그룹으로 만들 요소! _id는 어떤 것을 그룹으로 묶을것인지 표시하는 속성! 
// "$movie_id"를 기준으로 그룹화! commentCount(필드명)를 sum으로 합해라(갯수로 표시해라)! -> $잊지말것!
db.comments.aggregate(
    [
        {$group:{
            _id:"$movie_id", commentCount:{$sum:1} 
        }},
        {$project :{year:"$_id",commentCount:1,_id:0}}
    ]
)
// 각 연도에 나온 영화의 갯수 보기
db.movies.aggregate(
    [
        {$group:{_id:"$year",OpenMovies:{$sum:1}}}
    ]
)
// 러닝타임 평균값구하기 avg : 무엇을 기준으로 평균을 낼것인지 알려줘야함!
db.movies.aggregate(
    [
        {$group:{_id:"$year",runtime:{$avg:"$runtime"}}}
    ]
)

// 연도별 평점찾기! rating이 imdb안에있기 때문에 온점표기법으로 가져오기!
db.movies.find().limit(2)
db.movies.aggregate(
[
    {$group:{_id: "$year", averageRating:{$avg:"$imdb.rating"}}}
]
)

// 연도별 평점의 최솟값, 최댓값, 
db.movies.aggregate(
[
    {$group:{_id: "$year", 
         minRating:{$min:"$imdb.rating"}, // min은 자동형변환이 되기때문에 표기 가능! 문자형을 실수형으로 바꿔서 보여줌
         maxRating:{$max:"$imdb.rating"}}} // max는 자동형변환이 안되어서 문자형과 실수형의 평균을 낼 수 없음!!
]
)
// 위 구문에서 비어있는 값 -> 문자열로 되어있어서 나오지 않음 
//"5.2" : 문자열 / 5.2 : 실수형
db.movies.find({"imdb.rating":""}).limit(5)
//해결방법
db.movies.aggregate([
  {
    $addFields: {
      ratingNum: {
        $convert: {
          input: "$imdb.rating",to: "double", // 실수자료형으로 자료의 값을 변경하는 역할
          onError: null, // "","abc" ->문자열이나 빈 값을 null로
          onNull: null // 진짜 null -> null로 놔둬라
        }
      }
    }
  },
  { $match: { ratingNum: { $ne: null } } },
  {
    $group: {
      _id: "$year",
      minRating: { $min: "$ratingNum" },
      maxRating: { $max: "$ratingNum" }
    }
  },
  { $sort: { _id: -1 } } // (선택) year 오름차순 정렬
])

//$push로 그룹에 있는 값을 목록화해서 각각의 배열로 변환
//각 연도의 영화 제목들을 그룹화해서 몇개의 요소가 있는지 보여짐! 
db.movies.aggregate(
[
    {$group :{_id:"$year", titles : {$push:"$title"}}}
]
)

// 장르, 감독(directors) 을 연도별로 가져오기
// 장르와 감독은 배열형태로 되어있음! $push를 사용하면 -> 안의 값을 끄집어내서 하나의 배열로 만들고 싶음!
db.movies.aggregate([
    {$group :{_id:"$year",directors:{$push:"$directors"}}} // 기존의 데이터가 배열일때, 이렇게 가져오면 다시 배열로 가져옴
])
// $addToSet : 동일한 중복값을 제거하고 하나로 가져오는 역할 -> 동일한 감독의 명이 있었을 경우 한번만 출력하게 한다!
db.movies.aggregate([
    {$group :{_id:"$year",directors:{$addToSet:"$directors"}}}
])

db.movies.aggregate([
    {$group: {_id:"$year",genres:{$addToSet:"$genres"}}} // 1932년 스포츠, 스포츠 -> 한번만 값을 가져옴! 스포츠
])

// 그룹핑되어진 요소들 정렬 $sort
db.movies.aggregate([
    {$group:{_id:"$year",firstMovie:{$first:"$title"},lastMovie:{$last:"$title"}}} // 연도를 기준으로 그룹으로 주고, 첫번째 영화값을 찾아와라!
])
db.movies.find()

//문자열의 길이를 반환해주는 구문
db.movies.aggregate([ 
    {$group:{_id:"$year",avgTitleLength:{$avg:{$strLenCP:{$toString:"$title"}}}}}  
    // 그룹화, 찾아온 문자열의 길이를 찾고, 그 평균값을 찾아서 avgTitleLength에 넣어라
])


db.movies.aggregate([
    {$match:{"year":{$gte:2000}}}, // 2000년도 이후의 영화만 찾아와
    {$count:"movies_since_2000"} // 위의 것의 이름을 정의하고 개수를 세!
])

// 메서드 체이닝 기법 : 프레임워크인 aggregate에서는 독특한 형식으로 써야함!
db.movies.aggregate([
    {$sort:{"year":1,"title":1}},
    {$limit:10} // 안쪽으로 메서드 체이닝 묶어주기 
]) //.limit(10) // 라이브러리에서 쓰는 방식으로 하면 error! 

// 
db.movies.aggregate([
    {$sort:{"year":1,"title":1}},
    {$limit:5}
])
//$unwind : 중첩배열의 값을 하나로 합쳐주는 역할
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group: {_id:"$year",genres:{$addToSet:"$genres"}}} // 1932년 스포츠, 스포츠 -> 한번만 값을 가져옴! 스포츠
])

//
db.movies.aggregate([
    {$sort:{"imdb.rating":1}},
    {$limit:5}
])


//-----------문제1, 2000년 이후로 출시된 영화의 수는? --------
db.movies.aggregate([
    {$match:{"year":{$gte:2000}}}, 
    {$count:"movies_since_2000"}])

// 선생님 해설
db.movies.aggregate([
    {$match:{"year":{$gte :2000}}},
    {$count:"total_movies"}
])

//-----------문제2, 각 연도별로 출시된 영화의 개수는 몇개일까요--------
db.movies.aggregate([
    {$group:{
            _id:"year", commentCount:{$sum:1}}},
    {$count:"yearsMovie"}
])
// 선생님해설
db.movies.aggregate([
    {$group:{_id:"$year",count:{$sum:1}}}
])

//필드명 작성 순서
//정렬
db.movies.aggregate([
    {$group:{_id:"$year",count:{$sum:1}}}, // year를 기준으로 그룹화하고, 집계를 함!
    {$sort:{_id:1}}
])

//-----------문제3, 가장많은 영화가 출시된 연도 ---------
db.movies.aggregate([
    {$group:{_id:"$year",count:{$sum:1}}},
    {$sort:{count:-1}},{$limit:1}
])

//-----------문제4, 각 연도별 평균영화러닝타임
db.movie.aggregate([
    {$group:{_id:"$year",avgRun:{$avg:"$runtime"}}}
])
// 선생님해설
db.movies.aggregate([
    {$group:{_id:"$year", avgRuntime:{$avg:"$runtime"}}},
    {$sort:{avgRuntime:-1}}
])

//-----------문제5, 러닝타임이 가장 긴 영화는?
db.movies.aggregate([
    {$group:{_id:"$title", runtime:{$max:"$runtime"}}},
    {$sort:{runtime:-1}},{$limit:1}
])

//-----------문제6, 각 영화 장르별 평균 평점
db.movies.aggregate([
    {$group:{_id:"$genres",avgRev:{$avg:"$imdb.rating"}}}
])
//선생님 해설
db.movies.aggregate([
    {$unwind:"$genres"}, //배열을 없애고 문자열인 상태로 만들고 중복된 값을 제거! -> 그룹화
    {$group:{_id:"$genres",avgRating:{$avg:"$imdb.rating"}}},
    {$sort:{avgRating:1}} // 오름차순까지 추가!
])

//-----------문제7,각 연도별 영화 제목의 평균 길이를 구해주세요!
db.movies.aggregate([
    {$group:{_id:"$year",avgTitleLength:{$avg:{$strLenCP:{$toString:"$title"}}}}},
    {$sort:{avgTitleLength:1}}
])

//-----------문제8, 각 연도별 가장 먼저 출시된 영화의 제목은 무엇인가요?
db.movies.aggregate([
    {$group:{_id:"$year",firstMovie:{$first:"$year"}}},
    {"$title":{$sort:{firstMovie:1}}}
])
// 선생님해설
db.movies.aggregate([
    {$sort:{"year":1,"released":1}}, // 연도 안에 있는 값의 오름차순
    {$group:{_id:"$year",firstMovie:{$first:"$title"}}},
    {$sort:{id:1}}
])

//-----------문제9, 각 연도별 개봉된 영화의 장르들을 출력해주세요. 단, 장르는 한번씩만 출력되어야합니다.
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$year", uniqeGenres:{$addToSet:"$genres"}}},
    {$sort:{_id:1}}
])
