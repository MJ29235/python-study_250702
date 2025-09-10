use sample_mflix
db.movies.aggregate([
    {}
])
// 1.
db.movies.find(
    {year :{$gte:2010},genres:"Action"},
    {title:1,year:1,genres:1,_id:0}
)
// 2.
db.comments.find()
db.comments.insertOne(
        {name:"홍길동",email:["hong@test.com","mailto:hong@test.com"],interest:["Action","Comedy",]})
// 3.

db.comments.updateOne(
    { name: "홍길동" },
    { $set: { text: "Action 영화 최고!" }}
)
db.comments.updateOne(
    {text:"Action 영화 최고!" },
    {$set:{text:"Action 영화 진짜 재밌다!"}}
)
db.comments.find({name:"홍길동"})
//4.
db.movies.aggregate([
    {$unwind:"$genres"},
    {$group:{_id:"$genres",countGenres:{$sum:1}}},
    {$sort:{countGenres:-1}},{$limit:3}
])
//5.
db.movies.find()
db.movies.aggregate([
    //{$addFields:{ratingnum:{$convert:{input:"$imdb.rating",to:"double",onError:null,onNull:null}}}},
    {$match:{"imdb.rating":{$gte:8.5}}},
    {$project:{title:1,"imdb.rating":1,year:1,_id:0}},
    {$sort:{"year":-1}}
])


//6.
db.comments.aggregate([
    {$group:{_id:"$email",countComments:{$sum:1},
        avgTextLength:{$avg:{$strLenCP:{$ifNull:[{$toString:"$text"},""]}}}}},
    {$sort:{ countComments: -1},$sort:{ avgTextLength: -1}}, {$limit:5}
])