SELECT SUM(columns_my_dude.num_columns) as total_columns
FROM 
       (
       SELECT COUNT(table_name) as num_columns,
       table_name
FROM information_schema.columns
GROUP BY table_name
)  
       as  columns_my_dude