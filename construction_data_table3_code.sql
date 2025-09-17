#Tabel 3
 SELECT DISTINCT c.cost_id, c.description as cost_item, c.unit, c.qty, w.drawing_id, d.description
 FROM (costitem c JOIN workitem_costitem wc ON (c.cost_id = wc.cost_id)) JOIN workitem w ON 
(wc.work_id = w.work_id) JOIN drawing d ON(w.drawing_id = d.drawing_id)
 ORDER BY c.cost_id, w.drawing_id