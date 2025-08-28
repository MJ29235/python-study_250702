# 영화 길이에 대한 백분위 순위와 누적분포 계산
USE sakila;
SELECT title, length FROM film;

## 백분위 순위보기
SELECT title, length,
	PERCENT_RANK() OVER (ORDER BY length) AS percent
FROM film;

## 누적분포 보기
SELECT title, length,
	CUME_DIST() OVER (ORDER BY length) AS cume -- 몇명이 몇%대에 얼만큼 있는가 볼 수 있음!
FROM film;

##
SELECT title, length,
	PERCENT_RANK() OVER (ORDER BY length) AS percent,
    CUME_DIST() OVER (ORDER BY length) AS cume
FROM film;

## NTILE()
SELECT customer_id,CONCAT(first_name," ", last_name) AS customer_name,
	NTILE(4) OVER (ORDER BY customer_id) AS customer_group -- 전체 행의 갯수를 4조각으로 나눔
FROM customer;

