 #Table 2
 WITH temp1(cost_id, cost_item, unit, qty, price, total_price, start_date, finish_date, duration) as
 (WITH temp2(cost_id, cost_item, resource, unit, qty, price, start_date, finish_date) as
 (SELECT c.cost_id, c.description, r.name, c.unit, c.qty, (rc.index_res*r.price), MIN(w.start_date), 
MAX(w.finish_date)
 FROM (((costitem c JOIN resource_costitem rc USING (cost_id)) JOIN resource r USING (re
source_id)) JOIN workitem_costitem wc USING(cost_id)) JOIN workitem w USING(work_id)
     GROUP BY c.cost_id, r.name, rc.index_res, r.price
 ORDER BY c.cost_id)
 SELECT cost_id, cost_item, unit, qty, CAST(SUM(price) AS DECIMAL(14,2)) as price, 
CAST((qty*SUM(price)) AS DECIMAL(14,2)) as total_price, MIN(start_date) as start_date, 
MAX(finish_date) as finish_date, DATEDIFF(MAX(finish_date), MIN(start_date)) AS duration
    FROM temp2
    GROUP BY cost_id)
 SELECT cost_id, cost_item, unit, qty, price, total_price, CAST((total_price/(SELECT 
SUM(total_price) FROM temp1)*100) AS DECIMAL(3,2)) as "weight (%)", start_date, finish_date, dura
tion  
FROM temp1
  UNION 
SELECT "TOTAL", "-", "-", "-", "-", SUM(total_price), "100", MIN(start_date), MAX(finish_date), 
DATEDIFF(MAX(finish_date),MIN(start_date)) 
FROM temp1