use sample_mflix
db.users.aggregate([{
    $lookup:{
        from:"comments",
        localField:"email",
        foreignField:"email",
        as: "C"
    }
},
    {
        $addFields:{commentsCount: {$size:"$C"}}
    }
])
// 2. 댓글 길이를 기준으로 100자 이상 => LONG COMMENT , 100자 미만 => SHORT COMMENT
db.users.aggregate([{
    $lookup:{
        from:"comments",
        localField:"email",
        foreignField:"email",
        as: "C"
    }
},
    {
        $addFields:{commentsCount: {$size:"$C"},
        commentsAnnotated: {
            $map:{
                input:"$C",
                as:"x",
                in:{
                    text:"$$x.text",
                    date:"$$x.date",
                    movie_id:"$$x.movie_id",
                    commentType:{
                        $cond:[
                        {$gte: [{$strLenCP:{$ifNull:["$$x.text",""]}},100]},"LONG COMMENT","SHORT COMMENT"
                        ]}
                    }
                }
            }
        }
    }
])
//Array -> 배열 -> list , iterable -> 반복순회 가능한 구조자료 javascript에서 iterable한 요소 값을 하나씩 뺴서
// 연산처리 후 다시 새로운 배열로 반환해주는 문법 => map
db.users.aggregate([{
    $lookup:{
        from:"comments",
        localField:"email",
        foreignField:"email",
        as: "C"
    }
},
    {
        $addFields:{commentsCount: {$size:"$C"},
        commentsAnnotated: {
            $map:{
                input:"$C",
                as:"x",
                in:{
                    text:"$$x.text",
                    date:"$$x.date",
                    movie_id:"$$x.movie_id",
                    commentType:{
                        $cond:[
                        {$gte: [{$strLenCP:{$ifNull:["$$x.text",""]}},100]},"LONG COMMENT","SHORT COMMENT"
                        ]}
                    }
                }
            }
        }
    }
])

//3.1) 최신영화 Top 5 2) 고평점 영화 갯수 (8점이상) 3) 장르별 영화 분포 1)-3)의 내용을 하나의 $facet으로 처리해라
// pipeline과 상관없이 동시 실행
db.movies.aggregate([
    {
        $facet:{
            latest5:[
            {$sort:{year:-1}},
            {$limit:5},
            {$project:{_id:0,title:1,year:1}}
            ],
            highRatedCount:[
                {$match:{"imdb.rating":{$gte:8}}},
                {$count:"count"}
            ],
            genresByCount:[
                {$unwind:"$genres"},
                {$group:{_id:"$genres",count:{$sum:1}}},
                {$sort:{count:-1}}
            ]
        }
    },
    {$project:{
        latest5:1,
        highRatedCount:{$ifNull:[{$arrayElemAt:["$highRatedCount.count",0]},0]},
        genresByCount:1
    }}
])