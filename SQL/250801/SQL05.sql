CREATE DATABASE IF NOT EXISTS interparkmkt;
USE interparkmkt;
CREATE TABLE IF NOT EXISTS performance(
	id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    date_range VARCHAR(100), -- DATE 형식이 아니라서 VARCHAR
    place VARCHAR(100)
);
DESC performance;
SELECT * FROM performance;