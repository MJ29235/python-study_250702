

-- ---
USE sakila;

WITH PaymentInfo AS(
	SELECT
		customer_id, payment_date, amount, #total_customer_pay,
		SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS total_amount,
		LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS previous_amount,
		LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS next_amount,
		FIRST_VALUE(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date) AS first_payment_date,
		LAST_VALUE(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date
				ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_payment_date,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS group_row_number
	FROM payment
),
PaymentGap AS (
	SELECT customer_id, payment_date, amount,
		total_amount, previous_amount, next_amount, first_payment_date, last_payment_date,group_row_number,
        ABS(amount-previous_amount) AS next_payment_diff,
        ABS(next_amount-amount) AS prev_payment_diff,
        NTILE(5) OVER ( ORDER BY total_amount) AS partition_amount
	FROM PaymentInfo
)
SELECT PG.customer_id, PG.payment_date, PG.amount,
	PG.total_amount, PG.previous_amount, PG.next_amount, PG.first_payment_date, PG.last_payment_date,
    PG.next_payment_diff,PG.prev_payment_diff,PG.partition_amount,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS total_amount_rank,
    PERCENT_RANK() OVER (ORDER BY total_amount) AS payment_amount_pct_rank,
	CUME_DIST() OVER (ORDER BY total_amount) AS rental_cumulative_dist,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_amount) total_amount_group,
    PG.group_row_number
FROM PaymentGap PG
;
