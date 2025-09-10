// ----------- 문제 1. 
// 각 영화의 제목과 해당 영화에 달린 댓글을 출력해주세요
db.movies.aggregate([
    {$lookup:{from:"comments",localField:"title",foreignField:"text",as:"title_review"}}
    //,{$project: {_id:0, title: 1, text : 1, title_review:1}}
])
// 선생님 해설
db.movies.find()
db.comments.find()
db.movies.aggregate([
    {$lookup:{from:"comments",localField:"_id",foreignField:"movie_id",as:"movie_comments"}},
    {$project : { _id:0,title:1,   // $project로 특정한 요소만 출력
        movie_comments:1
    //    movie_comments:{$map:{input:"$movie_comments",as : "comment",in:"$$comment.text"}}}
    }}
        // $map : 배열에 있는 값을 반복시키고 '출력' (!=for in 문 : 반복만함(출력X)) , 배열만 사용가능!
])

// ------------ 배열의 뭉쳐져있는 객체의 한 값만 뽑아내고 싶을때 $in .$map을 사용해서
db.movies.aggregate([
    {$lookup:{from:"comments",localField:"_id",foreignField:"movie_id",as:"movie_comments"}},
    {$project : { _id:0,title:1,   // $project로 특정한 요소만 출력
        movie_comments:{$map:{input:"$movie_comments",as : "comment",in:"$$comment.text"}}
    }}
        // $map : 배열에 있는 값을 반복시키고 '출력' (!=for in 문 : 반복만함(출력X)) , 배열만 사용가능!
])


// -------문제 2. 평점이 가장 높은 영화의 제목, 평점을 출력
db.movie.aggregate([
    {$match:{maxRating:{$max:"$imdb.rating"}}},
    {$project:{title:1,maxRating:1}}
])
// 선생님 해설
db.movies.aggregate([
    {$match:{"imdb.rating":{$ne:""}}}, // 1, 문자만들어올 수 있도록
    {$sort:{"imdb.rating":-1}}, //2,평점을 내림차순으로 만들어주고
    {$limit:1},
    {$project:{_id:0,title:1,"imdb.rating":1}}
])

//------- 문제 3, 각 장르별로 평균 평점이 가장 높은 장르와 평균 평점을 출력해주세요
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$genres", avgHigh:{$max:{$avg:"$imdb.rating"},avgRate:{$avg:"$imdb.rating"}}}}
])
//선생님 해설
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$genres",avgRating:{$avg:"$imdb.rating"}}},
    {$sort:{avgRating:-1}},
    {$limit:1},
    {$project:{_id:0,avgRating:1}}
])


// --------- 문제 4, 개봉연도 별 평균 러닝타임이 제일 짧은 영화의 개봉연도와 평균 러닝타임을 출력해주세요
db.movies.aggregate([
    {$group:{_id:"$year",avgRun:{$avg:"$runtime"}}},
    {$sort:{avgRun:1}},
    {$limit:1},
    {$project:{_id:0, year:"$_id",avgRun:1}}
])

// --------- 문제 5, 국가별로 가장 많은 영화를 제작한 감독, 그 감독의 영화 갯수를 출력 "directors" 
db.movies.find()
db.movies.aggregate([
    {$unwind:"$countries"},
    {$unwind:"$directors"},
    {$group:{_id:{country:"$countries",director:"$directors"},countMovie:{$sum:1}}},
    {$sort:{countMovie:-1}},{$limit: 1},
    {$project:{country:"$_id",countMovie:1,_id:0}}
])
//선생님 해설
db.movies.find()
db.movies.aggregate([
    {$unwind:"$countries"},
    {$unwind:"$directors"},
    {$group:{_id:{country:"$countries",director:"$directors"},count:{$sum:1}}}, // id를 중첩시킴!!!
    {$sort:{count:-1}},
    {$group:{_id:"$_id.country",topDirector:{$first:"$_id.director"},movieCount:{$first:"$count"}}} 
    // id의 자식요소인 country!를 가져옴. 이를 기준으로 director에서 첫번쨰 값: first
])

//
db.movies.aggregate([
    {$unwind:"$countries"},
    {$unwind:"$directors"},
    {$group:{_id:{country:"$countries",director:"$directors"},count:{$sum:1}}},
    {$group: {_id:"$_id.country",
        top:{$topN:{n:1,sortBy:{count:-1},output:{director:"$_id.director",movieCount:{"$count"}}}}}},
    //sort와 group 한번에 주기 ; $topN → 상위 N개를 가져와라
    {$project:{_id:0,country:"$_id",topDirector:{"$top.director"}, movieCount: "$top.count"}}
])


//--------- 문제 6, 각연도별로 가장 많은 평점을 받은 영화의 제목과 평점을 출력하세요.
db.movies.aggregate([
    {$group:{_id:"$year", maxRate:{$max:"$imdb.rating"}}},
    {$sort:{maxRate:-1}},
    {$},
    {$limit:1}
])
//선생님해설
db.movies.aggregate([
    {$sort:{"year":1,"imdb.rating":-1}}
    ,{$group:{_id:"$year", title:{$first:"$title"},maxRating:{$first:"$imdb.rating"}}}
    ,{$project:{_id:0,year:"$_id",title:1,maxRating:1}}
])

// -------- 문제7, 각 장르별 영화갯수를 출력하세요
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$genres",count:{$sum:1}}},
    {$sort:{count:-1}},
    {$project:{_id:0,genre:"$_id",movieCount:"$count"}} // 상단의 필드명을 식별할 수 있게 바꿔주는 함수
])


//----------- 문제8, 평균 평점이 가장높은 감독과 해당 감독의 평점을 출력해주세요
db.movies.aggregate([
    {$unwind:"$directors"},
    {$group:{_id:"$directors", avgRating:{$avg:"$imdb.rating"}}},
    {$sort:{avgRating:-1}},{$limit:1},
    // 선생님 +
    {$project:{_id:0,dirctor:"$_id",avgRating:1}}
])


//----------- 문제9, 장르별/ 평균 러닝타임이 가장 긴 장르와/ 해당 장르의 평균러닝타임을 출력
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$genres",avgTime:{$avg:"$runtime"}}},
    {$sort:{avgTime:-1}},{$limit:1},
    {$project:{_id:0, genres:"$_id", avgTime:1}}
])

//----------- 문제10, 각영화의 제목과 해당 영화에 대해 댓글을 남긴 사용자들을 출력해주세요
db.comments.aggregate([
    {$lookup:{from :"movies",localField:"movie_id",foreignField:"_id",as:"movie"}},
    {$unwind:"$movie"}, // lookup으로 배열이 된것을 풀어줌
    {$project:{_id:0,title:"$movie.title",user:"$name",email:"$email",text:"$text"}}
])
// 선생님 해설
db.movies.aggregate([
    {$lookup:{from :"comments",localField:"_id",foreignField:"movie_id",as:"movie"}}
    ,{$project:{_id:0,title:1,users:"$movie.name"}}
])