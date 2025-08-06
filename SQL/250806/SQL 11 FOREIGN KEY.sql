CREATE DATABASE IF NOT EXISTS sqlDB_v1;
USE sqlDB_v1;
# 원칙적으로는 값을 삭제했을 때 엮여있는 참조값이 없어지는건 안됨 BUT
SET FOREIGN_KEY_CHECKS = 1; -- 설정에서 꺼져있으면(0) 가능..! (1)로 설정하면 켜짐! foreign key 

CREATE TABLE userTbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height SMALLINT,
    mDate DATE
);

CREATE TABLE buyTbl (
	num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    prodName CHAR(4),
    groupName CHAR(4),
    price INT NOT NULL,
    amount SMALLINT NOT NULL,
    FOREIGN KEY(userID) REFERENCES userTbl(userID)
);

INSERT INTO userTbl (userID,name,birthYear,addr,mobile1,mobile2,height,mDate)
VALUES("DAVID","박세진",2000,"서울","010","12345678",182,'2000-12-31');
UPDATE userTbl
SET mDate = '2000-12-13'
WHERE userID = 'DAVID';

INSERT INTO buyTbl (userID,prodName,groupName,price,amount)
VALUES("DAVID","에어조던","패션잡화", 30, 2);

SELECT * FROM userTbl;

#user ID 값 제거
DELETE FROM usertbl WHERE userID = "DAVID";

SHOW CREATE TABLE buyTbl;
