//1) 사용자-댓글 매칭 각 사용자 문서에 commentsCount 필드를 추가하여 댓글 개수를 계산하세요.us
use sample_mflix
db.comments.find()
db.users.find()
db.users.aggregate([
 {$lookup:{from:"comments",localField:"email",foreignField:"email",as:"userComments"}},
 {$addFields:{commentsCount:{$size:{ $ifNull:["$userComments",[]]}}}},
 {$project:{_id:0,name:1 ,email:1, commentsCount:1} }
])

//2) 댓글 길이 조건 처리/ 댓글(text) 길이를 기준으로 100자 이상 → "LONG COMMENT" 
// 100자 미만 → "SHORT COMMENT"라는 새 필드(commentType)를 $cond로 추가하세요.
db.comments.aggregate([
    {$addFields:{textLen:{$strLenCP:{$ifNull:["$text",""]}}}}
    ,{$addFields:{commentType:{$cond:[{$gte:["$textLen",100]},"LONG COMMENT","SHORT COMMENT"]}}}
    ,{$group:{_id:"$commentType",count:{$sum:1},avgLen:{$avg:"$textLen"}}},
    {$project:{_id:0,commentType:"$_id",count:1,avgLen:1}}
])


// 3) Facet 분석 :하나의 $facet으로 다음을 동시에 분석하세요. 최신 영화 TOP 5: year 내림차순 정렬 후 상위 5개
// 고평점 영화 개수: imdb.rating >= 8인 영화 수, 장르별 영화 분포: genres를 $unwind 후 장르별 영화 수 집계
db.movies.aggregate([
    {$facet:{top5:[{$match:{year:{$type:"number"}}},{$sort:{year:-1,title:1}},{$limit:5},{$project:{_id:0,title:1,year:1}}],
            highRate:[{$match:{"imdb.rating":{$type:"number",$gte:8}}},{$count:"count"}],
                genreDist:[{$unwind:"$genres"},{$group:{_id:"$genres",count:{$sum:1}}},{$sort:{count:-1}}]
            }}
])


