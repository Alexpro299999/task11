WITH date_spine AS (
  SELECT DATEADD(day, SEQ4(), '2000-01-01') AS date_day
  FROM TABLE(GENERATOR(ROWCOUNT => 11000))
)
SELECT
    date_day,
    YEAR(date_day) AS year,
    MONTH(date_day) AS month,
    MONTHNAME(date_day) AS month_name,
    DAY(date_day) AS day,
    QUARTER(date_day) AS quarter,
    DAYOFWEEK(date_day) AS day_of_week
FROM date_spine