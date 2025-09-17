#Table 1
 WITH temp(name, cost_id, unit, qty, start_date, finish_date, duration, price, cost) as
 (SELECT r.name, c.cost_id, r.unit, c.qty, MIN(w.start_date), MAX(w.finish_date), 
DATEDIFF(MAX(w.finish_date), MIN(w.start_date)) as duration, r.price, 
CAST(((rc.index_res*c.qty*r.price)) AS DECIMAL(14,2)) as cost
 FROM (((resource r JOIN resource_costitem rc USING(resource_id)) JOIN costitem c 
USING(cost_id)) JOIN workitem_costitem wc USING(cost_id)) JOIN workitem w USING(work_id)
 GROUP BY r.name, c.cost_id, rc.index_res, r.price, r.unit)
 SELECT name, cost_id, unit, qty, start_date, finish_date, duration, price, cost 
FROM temp
     UNION 
SELECT "~TOTAL", "-", "-", "-", MIN(start_date), MAX(finish_date), 
DATEDIFF(MAX(finish_date),MIN(start_date)), "-", SUM(cost)
 FROM temp
 ORDER BY name