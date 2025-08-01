-- CREATE DATABASE customer_db;
-- USE customer_db;
-- CREATE TABLE customer (
-- 	No INT NOT NULL AUTO_INCREMENT,
--     Name CHAR(20) NOT NULL,
--     Age TINYINT,
--     phone VARCHAR(20),
--     Email VARCHAR(30) NOT NULL,
--     Address VARCHAR(50),
--     PRIMARY KEY(No) -- 총 6개의 속성을 만들어줌customer
-- );

-- 이미 생성된 특정 테이블 제거
-- DROP TABLE IF EXISTS customer;

-- 현재 보고 있는 데이터 베이스 안에 생성된 모든 테이블 확인하기
-- SHOW TABLES;
-- -- 특정 테이블 안에 생성된 구조 확인하기
-- DESC customer; 

-- 수정하기 1) 컬러 컬럼에 넣기!
-- ALTER TABLE customer ADD COLUMN Color VARCHAR(12);
-- DESC customer;

-- 컬럼의 타입변경, 필수 값으로 바꾸기
-- ALTER TABLE customer MODIFY COLUMN Color VARCHAR(20) NOT NULL;
-- DESC customer;

# 특정 테이블 내 속성명 & 속성 타입 변경하기
-- ALTER TABLE customer CHANGE COLUMN phone Mobile VARCHAR(20) NOT NULL;

#특정 테이블 내 속성 삭제하기
-- ALTER TABLE customer DROP COLUMN Color;
DESC customer;