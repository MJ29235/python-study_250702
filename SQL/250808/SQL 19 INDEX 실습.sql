CREATE DATABASE IF NOT EXISTS index_demo_v1;
USE index_demo_v1;

# 내 엔진 상태 확인하기
SHOW VARIABLES LIKE 'default_storage_engine'; # 'InnoDB'면 OK!

CREATE TABLE IF NOT EXISTS customers(
	id INT AUTO_INCREMENT PRIMARY KEY, -- 클러스트 인덱스로 작동시킬 것이다!
    name VARCHAR(100),
    email VARCHAR(100),
    age INT,
    city VARCHAR(100)
); #ENGINE=InnoDB; #속도에 대한 효율성을 극대화한다.

# 클러스터형 인덱스, 보조형 인덱스가 다른 필드값 안에 있는 요소들을 사용할 때보다 연산처리속도가 빠르다는 것을 확인하려는 것!!!
# 우선, 클러스형 인덱스가 작동하는지 확인해야함. 설정 및 설치 엔진 -> Storage Engine
# Engine=InnoDB 이렇게 설정해야 클러스터형 인덱스가 빨리 돌것!!
# MY SQL의 8.0이상 버전부터는 기본 default값! BUT 다른 ENGINE 쓰고있으면 안됨! ex) MyISAM (X)

DESC customers;

# 데이터를 추가하는 방식
# INSERT INTO customers (name, email, age, city) VALUES (); -> 이전에 수동으로 값을 넣을때 사용하는 방식
INSERT INTO customers (name, email, age, city) 
SELECT
	-- 이름 만들기
	CONCAT('USER', LPAD(FLOOR(RAND() * 100000), 5, '0')) ,
    #서로다른 객체지향언어를 같이 사용할때 RAND 100000개의 확률 중 하나의 랜덤값으로 숫자를 도출 : 0-1 사이에서 실수의 형태로 난수를 도출
    #소수점 아래로 버리기 바닥에 있는 숫자 버리기 = 'FLOOR'
    # 정렬 왼쪽 or 오른쪽 기준 두기 : 왼쪽 여백을 기준(-LPAD)으로 남은공간을 '0' 으로 줘!
    -- email만들기
    CONCAT('USER', FLOOR(RAND() * 100000), '@test.com') ,
    -- 18세 이상, 정수로 나이 만들기 
    FLOOR(18 + (RAND() * 50)),
    -- city 서울 인천 부산 
    ELT(FLOOR(1+(RAND()*5)),'Seoul' , 'Busan', "Incheon", 'Daegu', 'Daejeon') ################????????????????????/
    # 위 5도시 중에서 랜덤으로 찾아오는 문법!!
FROM information_schema.tables LIMIT 1000; 
# -> information_schema.tables 
#현재 내가 사용 중인 MYSQL 워크벤치 안에 전체 테이블 정보 값을 가지고 있는 시스템 테이블 = 메타 테이블
#  MYSQL 워크벤치 -> 대략적인 테이블 수의 정보를 기준으로 (DB 워크벤치에서 사용하고 있는 메모리 값만큼 가용할 수 있는 메모리 만큼)

SELECT COUNT(*) FROM customers; -- 더미데이터 (쓰레기)
SELECT * FROM customers;

#인덱스 보기
SHOW INDEX FROM customers;

# 보조 인덱스 만들기
CREATE INDEX idx_email ON customers(email); # 보조인덱스 이름 : idx_email
CREATE INDEX idx_age ON customers(age);

SELECT * FROM customers;
EXPLAIN SELECT * FROM customers; # EXPLAIN : 설명해라 - 이 값을 찾아오는데 걸리는 시간 등 운영체제에 관련된 것을 찾아와라!
# type : ALL -> 전체 데이터를 읽어보았고, rows -> 379번의 반환값을 돌고왔다!
EXPLAIN SELECT * FROM customers WHERE id = 300;  
# type : const : 고정값을 찾아와라! 1번만에 찾아옴 반복하지 않음, 클러스터 인덱스 이기 떄문에 제일 빨리 찾아옴!
EXPLAIN SELECT * FROM customers WHERE email = 'user62544@test.com';
# type : ref reference -> 보조한다! 한번밖에 안돈 것은 같지만(빠르지만, id 보다는 느림! 보조 인덱스이기 떄문에!
EXPLAIN SELECT * FROM customers WHERE city = 'Busan';
# type : ALL -> 인덱스가 지정이 안되어있어서 그냥 다 돌고 옴. 