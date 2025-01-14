WITH payment_summary AS (
  SELECT
    date(date_trunc('month', payment_date)) AS payment_month,  -- витягуємо місяць з дати платежу
    game_name,
    user_id,
    sum(revenue_amount_usd) as total_revenue 
  FROM
    project.games_payments
    group by 1,2,3
),
payment_with_months AS (
  SELECT
    user_id,
    game_name,
    payment_month,
    total_revenue,
   date(payment_month - interval '1' month) as previous_calendar_month,
		date(payment_month + interval '1' month) as next_calendar_month,
		lag(total_revenue) over(partition by user_id order by payment_month) as previous_month_revenue,
		lag(payment_month) over(partition by user_id order by payment_month) as previous_month,
		lead(payment_month) over(partition by user_id order by payment_month) as next_month
  FROM
    payment_summary
),
metrics AS (
  SELECT
    user_id,
    game_name,
    payment_month,
    total_revenue,
    previous_calendar_month,
    next_calendar_month,
    previous_month,
    next_month,
    previous_month_revenue,
    -- 1.New MRR 
    CASE
      WHEN previous_month IS NULL THEN total_revenue
    END AS new_mrr,
    -- 2. Expantion Revenue 
    CASE
      WHEN previous_month = previous_calendar_month AND total_revenue > previous_month_revenue THEN total_revenue - previous_month_revenue
    END AS expantion_revenue,
    -- 3. Contraction Revenue
    CASE
      WHEN previous_month = previous_calendar_month AND total_revenue < previous_month_revenue THEN total_revenue - previous_month_revenue
    END AS contraction_revenue,
    -- 4. Churned Revenue 
    CASE
      WHEN next_month IS NULL OR next_month != next_calendar_month THEN total_revenue
    END AS churned_revenue,
    -- 5. Churn month 
    CASE
      WHEN next_month IS NULL OR next_month != next_calendar_month THEN next_calendar_month
    END AS churn_month
  FROM 
    payment_with_months
)
SELECT 
  m.user_id,
  m.game_name,
  m.payment_month,
  m.total_revenue,
  m.new_mrr,  
  m.expantion_revenue,  
  m.contraction_revenue,  
  m.churned_revenue,  
  m.churn_month,  
  p.language,
  p.has_older_device_model,
  p.age
FROM 
  metrics m
JOIN 
  project.games_paid_users p 
  ON m.user_id = p.user_id
ORDER BY
  m.user_id, m.game_name, m.payment_month;
     
     
 