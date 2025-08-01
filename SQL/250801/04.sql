USE MYSQL;
DESC user;
SELECT host, user FROM user; -- 계정정보를 담당하는 속성 
# localhost => 127.0.0.1 => DNS

CREATE USER 'david7'@'localhost' -- localhost에 david7 이라는 로컬파일을 만들겠다!
IDENTIFIED BY 'david1234'; -- 비밀번호

CREATE USER 'david8'@'%' -- 다른 공간에서 접속이 가능하게 만들어주는 방법. 로컬호스트가 아니어도(회사 내 망이 아니어도) 사용가능!
IDENTIFIED BY 'david1234'; -- 비밀번호

#패스워드 변경
SET PASSWORD FOR 'david8'@ '%' ='david5678';

#삭제하기
DROP user 'david7'@'%';
DROP user 'david7'@'localhost';
# 로컬호스트 사용 권한 알아보기
SHOW GRANTS FOR 'root'@'localhost'; -- root라는 사용자의 권한 획득

#특정테이블에만 접근하고 기능을 사용하되, 다른 DB는 건들지 못하게끔 하는것
GRANT SELECT ON school.students TO 'david7'@'localhost'; -- david7의 로컬호스트에서 school이라는 DB에 students에만 접근하게
SHOW GRANTS FOR 'david7'@'localhost';
#school 내에서 모든 테이블을 보여줄 수 있게하는것.
GRANT ALL ON school.* TO 'david7'@'localhost';
SHOW GRANTS FOR 'david7'@'localhost';