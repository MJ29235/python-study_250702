USE SQLDB_v1;

DESC userTbl;
# 클러스터형 인덱스 : userID

DESC buyTbl;
# 클러스터형 인덱스 : num

SHOW INDEX FROM buyTbl;
# userID -> FOREIGN KEY의 경우에도 클러스터 인덱스!!
SHOW INDEX FROM userTbl;
# 'name' -> UNIQUE

ALTER TABLE userTbl ADD CONSTRAINT TESTDate UNIQUE (mDate); # CONSTRAINT 규격화하다, 제약화하다
# 'mDate' -> 속성값을 unique로 바꾸면 클러스터형 인덱스 가능!

CREATE INDEX idx_birth ON userTbl(birthYear);
# userTbl -> key의 이름이 생성됨!!

# address 보조 인덱스 만들기
ALTER TABLE userTbl ADD INDEX idx_addr(addr);

# address 보조 인덱스 삭제하는 방법! only one 
ALTER TABLE userTbl DROP INDEX idx_addr;
