# Bigquery advanced functions
## Query Evaluation Order
* FROM
* WHERE
* GROUP BY and aggregation
* HAVING
* WINDOW
* QUALIFY
* DISTINCT
* ORDER BY
* LIMIT

## Qualify
The QUALIFY clause filters the results of window functions. A window function is required to be present in the QUALIFY clause or the SELECT list.
``` SQL
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY
    grouping_col1,
    grouping_col2
  ORDER BY
    ordering_col
) = 1 #get first row of window
```

## Window Functions
``` SQL
PERCENTILE_CONT(column, percentile) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS percentile_50_of_num_col
PERCENTILE_DISC(column, percentile) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS percentile_50_of_cat_col
FIRST_VALUE/LAST_VALUE(column) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS first/last_row_of_window
NTH_VALUE(column, position) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS nth_row_of_window
LAG(column, offset) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS col_move_down_by_offset
LEAD(column, offset) OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS col_move_up_by_offset
ROW_NUMBER() OVER (PARTITION BY grouping_col1, grouping_col2 ORDER BY ordering_col) AS row_number_of_current_row_in_window

### With window frame clause
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS includes_all_rows_in_window,
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
) AS includes_all_rows_before_and_including_current_row,
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN x PRECEDING AND CURRENT ROW 
) AS includes_only_x_rows_before_and_including_current_row,
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN x PRECEDING AND y FOLLOWING
) AS includes_only_rows_between_x_before_and_y_after_current_row,
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN CURRENT ROW AND y FOLLOWING
) AS includes_only_y_rows_after_and_including_current_row,
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY ordering_col
  RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
) AS includes_all_rows_after_and_including_current_row

### Window frame clause with dates
PERCENTILE_CONT(column, percentile) OVER (
  PARTITION BY grouping_col
  ORDER BY UNIX_DATE(date_col)
  RANGE BETWEEN 27 PRECEDING AND CURRENT ROW
) AS includes_last_28_days_of_rows
#good if you have missing dates, this will always ensure your window only has 28 days and not 28 rows
```

## Grouping Sets
``` SQL
GROUP BY ROLLUP (
  group_product,
  group_subproduct
) #Group by product & product+subproduct (hierarchical), NULLs in product & subproduct are included
GROUP BY CUBE (
  group_product,
  group_subproduct
) #Group by product & subproduct & product+subproduct (permutations), NULLs in product & subproduct are included
GROUP BY GROUPING SETS (
  group_product,
  group_subproduct
) #Group by product & subproduct separately, with non-groups having NULL values

# These can be combined
GROUP BY GROUPING SETS (
  group_product,
  ROLLUP (group_product, group_subproduct)
) #Group by product (from sets) & product (from rollup) & product+subproduct (from rollup), duplicate groups of products are created, NULLs from rollup are included too
GROUP BY GROUPING SETS (
  group_product,
  CUBE (group_product, group_subproduct)
) #Group by product (from sets) & product (from cube) & subproduct (from cube) & product+subproduct (from cube), duplicate groups of products are created, NULLs from cube are included too
```

## Pivot
``` SQL
SELECT group_col, agg_col, pivot_col
FROM table
PIVOT (SUM(agg_col) FOR pivot_col IN (x, y, z)) #selected columns that are not in pivot clause will be grouped, this will give group_col & pivot_col, with SUM(agg_col) as values

SELECT group_col, x, y, z
FROM pivot_table
UNPIVOT (agg_col FOR pivot_col IN (x, y, z)) #selected columns that are not in pivot clause will be ungrouped, new agg_col will be created with values as values of pivot table, pivot_col will be created with values of x,y,z, this will give group_col, agg_col & pivot_col as table
```
