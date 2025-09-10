// --------------------- project
// 1. 출력값 정하기
use sample_mflix
db.movies.aggregate([
    {$project:{title:1,year:1}}, // 기본 : _id, 선택 : title, year 을 가져옴! -> 출력값을 선택한다고 봐도 되는거야?
    {$limit:5}
])

// 2. 서로다른 컬럼에 존재하는 문자열을 가져와서 하나의 문자열로 만들어내는것
db.movies.aggregate([
    {$project:{title:1,year:1,_id:0,releasedIn:{$concat:["$title"," / ",{$toString:"$year"}]}}}, 
    // releasedIn이라는 필드 생성-> $title의 값을 각각 목록별로 찾아오겠다. year는 실수니까 문자열로 변환시키고 가운데 /를 넣어 출력! 
])

