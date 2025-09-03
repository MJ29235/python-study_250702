db.createCollection("reviews",{
    capped:true,
    size: 5242880,
    max:5000
})
db.reviews.find()


db.reviews.insertMany( 
    [
     {customer_name:"희망",product:"롱기장슬랙스",rating:4.2,comment:"정말튼튼해요",date:ISODate("2025-09-01")},
     {customer_name:"소망",product:"여름한정반팔",rating:4.6,comment:"편하게입기좋아요",date:ISODate("2025-06-28")},
     {customer_name:"사랑",product:"롱기장슬랙스",rating:4.7,comment:"기장이딱맞아요",date:ISODate("2024-02-13")},
     {customer_name:"정의",product:"신상가방",rating:3.7,comment:"생각보다퀄리티가낮아요",date:ISODate("2025-05-30")},
     {customer_name:"평화",product:"롱기장슬랙스",rating:4.8,comment:"항상여기서만사요",date:ISODate("2024-08-22")},
     {customer_name:"행복",product:"뉴슈즈",rating:4.9,comment:"신상이이쁘게나왔네요",date:ISODate("2025-08-07")},
     {customer_name:"기쁨",product:"아디다스츄리닝",rating:5.0,comment:"러닝할때자주입어요",date:ISODate("2025-01-28")},
     {customer_name:"슬픔",product:"오버핏반팔",rating:3.9,comment:"애매한기장이네요",date:ISODate("2025-09-01")},
     {customer_name:"분노",product:"크롭티",rating:2.8,comment:"재질이형편없어요",date:ISODate("2024-07-02")},
     {customer_name:"두려움",product:"여름한정반팔",rating:5.0,comment:"깔끔하게입기좋아요",date:ISODate("2025-05-26")}
    ] 
)
db.reviews.find(
{rating : {$gte:4.5},product:"롱기장슬랙스"});

db.reviews.updateOne(
    {customer_name:"희망"},
    {$set :{comment:"배송이 빨라서 만족합니다"}})

db.reviews.updateMany(
{product:"크롭티"},{$inc:{rating:1}})

db.reviews.deleteMany(
{date: {$lt: ISODate("2024-09-03")}})
