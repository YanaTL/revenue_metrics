# I'd like to introduce you to the Revenue metrics project
Its main idea is to analyze cash flow by calculating revenue metrics and their visualization on a dashboard.

The **first stage of the project** was to prepare the data in SQL, using a sample, preliminary calculations, and merging two tables with user data.
The first table consists of the following data: 
- user_id,
- game_name,
- payment_date,
- revenue_amount_usd.

I created the first CTE, in which I extracted the month of payment from the payment date using the date_trunc function to extract the month of payment (this information is needed for future calculations), selected the game_name, user_id, and calculated the revenue_amount_usd using the sum function and finally grouped it by month, game, and user.

After receiving the results from the first one, I form the **next CTE** and, based on the information about payment_month, make calculations: previous_calendar_month and next_calendar_month. Then, using the lag and lead window functions, I display: previous_month_revenue, previous_month, next_month. This data is needed for the next CTE, which calculates several key metrics related to user revenue:
New MRR, Expansion Revenue, Contraction Revenue, Churned Revenue, Churn Month.

The main query selects from the previous CTEs:
- Information about users, their income, and metrics for each month.
- Additional fields from the project.games_paid_users table are added: language, has_older_device_model, age.

The result is **sorted by user_id, game_name, and payment_month** for easy viewing.

# After preparing the data using SQL, I downloaded the csv file and transferred it to Tableau.
There, using the Calculated field, I calculated ARPPU, New Paid Users, Churned Users, Churn Rate, Revenue Churn Rate, LT, LTV.
And now I present the final calculations on the dashboard: [Tableau Dashboard](https://public.tableau.com/views/FinalProject_17344587814450/Finalinformation?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

It consists of **7 visualizations** that display revenue metrics by month.
* The 1st visualization shows the relationship between the total revenue of **Monthly Recurring Revenue (MRR)** and the number of paid users over time.
* 2nd visualization - The graph **Average Revenue Per Paid User (ARPPU)** shows the average revenue per paid user for different months
* The 3rd visualization shows the relationship between **New MRR** and the number of new paid users in different months.
* The 4th visualization shows the trend of **Churned Revenue and Churned Users**.
* 5th visualization  - This graph shows the development of **Churn Rate and Revenue Churn Rate.**
* 6th visualization - This graph shows the dynamics of **Expansion MRR and Contraction MRR** by month.
* The 7th visualization shows the trend of **Customer LifeTime Value (CLTV) and Customer LifeTime (LT).**

To interact with the visualization in more detail, there are 3 filters on the right side for age, language, and month of the year. By selecting one of the filters, for example, age, you can see how all visualizations pull up the data for this particular parameter.

# Conclusion:
While doing this work, I learned how to separate data at the initial stages to facilitate work in the future. By creating a SQL query, I honed my code construction and the use of functions. I dove deeper into working with Tableau, practiced the principles of visualization and building dashboards.

