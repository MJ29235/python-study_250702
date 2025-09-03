// 주석 가능!! -> // : 단문주석 여러줄 /* ~ */본문주석 
// 컬렉션 저장하기 (특정 옵션설정) 
db.createCollection(
    "log", {capped : true, size:5242880, max:5000}
)

// 구문이 종료되는 지점에서 ctrl + enter : 해당 구문 실행
// 전체구문 실행 : ctrl + shift + enter

show collections

db.log.isCapped() // true : 사이즈가 정해진 컬렉션이다!

db.log.renameCollection("test02")