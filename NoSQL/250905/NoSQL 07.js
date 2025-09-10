use sample_mplix
db.movies.find().limit(1)

db.movies.find(
    {year:{$gte: 2010},genres:"Action"},
    {_id:0,title:1,tear:1,genres:1}
)

db.movies.aggregate([
    {$match: {year:{$gte:2010},genres:"Action"}},
    {$project:{_id:0,title:1,year:1,genres:1}}
])