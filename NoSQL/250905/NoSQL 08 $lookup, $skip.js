use sample_mflix
db.comments.aggregate([ // comments는 'Join할 기준'!
    {
        $lookup:{
            from:"movies",           // 'Join할 대상'의 컬렉션 이름
            localField : "movie_id", // 현재 컬렉션(comments)에서 조인에 사용할 '필드'
            foreignField:"_id",      // Join할 컬렉션(movies)에서 Join에 사용할 '필드'
            as:"movie"               // join된 결과를 저장할 필드 이름
    }}/* // 매칭되어지는 값을 찾아옴
        {
            $match:{customerInfo:{$ne:[]}} // 빈배열이 아닌 값만 찾아와!
        }*/
])

// --------users에서 email을 기준으로 값을 합쳐보기 -------
db.users.find()
db.comments.find().limit(1)
db.users.aggregate([
    {$lookup:{from :"comments",localField:"email",foreignField:"email",as:"user_comments"}}
]) // email값에 기본적으로 찾아온 값은 무조건 배열의 형태를 띔!, 한 배열당 매칭되어지는 comments의 값을 가져옴!

// -------- $skip - 문서를 건너뛰고 값을 보여줌 (순서 : Sort->Skip->Limit)
db.movies.aggregate([
    {$match:{runtime:{$gte:100}}}, // 100분 이상의 상영시간을 가진영화를 찾아옴!
    {$sort:{year:-1}}
    ,{$skip:5} // 정렬된 값으로 부터 상위 5개를 넘기고 값을 보여줌
    ,{$limit:3}
])

//----------$facet
db.movies.aggregate([
    {
        $facet:{
            movieCountByYear:[
                {$group:{_id :"year",count:{$sum:1}}} // group은 원래 독립적으로 존재해야하지만, facet으로 파이프라인을 각각 돌리기 때문에 가능!
            ],        
            maxRatingByYear:[
                {$group:{_id:"$year", maxRating:{$max:"$imdb.rating"}}}
            ]
        }
    }
]) // 연도별 영화들의 최대 평점 값을추출! 

//--------- $redact, $cond {if, then, else} ----------
db.movies.aggregate([
    {$match:{year:{$gte:2010}}} // match는 조건값에 해당되는게 앞으로 나옴!
])
db.movies.aggregate([
    {
        $redact:{
            $cond: {
                if: {$gte:["$imdb.rating",7]},
                //조건식 - 평점이 7이상인 값을 찾아와! 필드명 필요 X -> then에서 쓸것
                then: "$$KEEP",
                // 조건식이 참이면 then 실행 ($$KEEP -> 사용자정의변수를 활용하고자 할떄, 우리의 메모리 공간에 보존하겠다)
                else: "$$PRUNE" 
                // 조건식이 거짓이면 else 실행 ("$$PRUNE"-> 버린다)
            }
        }
    }
])

