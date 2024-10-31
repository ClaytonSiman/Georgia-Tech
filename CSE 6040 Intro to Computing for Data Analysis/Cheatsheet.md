# Cheatsheet

## Useful packages
### Deepcopy
``` python
import copy
x_copy = copy.copy(x) #Shallow copy
x_deepcopy = copy.deepcopy(x) #Deep copy
```

### Default Dictionary
``` python
from collections import defaultdict
my_dict = defaultdict(list) #Create a defaultdict with a default value of an empty list
my_dict['fruits'].append('apple') #Add elements to the defaultdict
```

### Iterables
#### Permutations
``` python
from itertools import permutations 
perm = permutations([1, 2, 3], 2) #Get all pairs of permutations of [1, 2, 3] 
for i in list(perm): 
    print (i)
```

#### Combinations
``` python
from itertools import combinations
comb = combinations([1, 2, 3], 2) #Get all pairs of combinations of [1, 2, 3] 
for i in list(comb): 
    print (i)
```

## SQLite
### Setup
``` python
import sqlite3 as db

conn = db.connect('example.db') #Connect to a database (or create one if it doesn't exist)
c = conn.cursor() #Create a 'cursor' for executing commands
```

### Querying
``` python
c.executemany('INSERT INTO Students VALUES (?, ?)', more_students) #executing multiple times (inserting multiple rows here) '?' question marks are placeholders for the two columns in Students table

c.execute("SELECT * FROM Students") #execute query

query = '''
        SELECT Students.name, Takes.grade
        FROM Students, Takes
        WHERE Students.gtid = Takes.gtid
          AND Takes.course = 'CSE 6040'
'''
c.execute(query) #for longer queries

results = c.fetchall() #fetch query output into variable
conn.commit() #Commit your changes in the db (changes do not take effect until you commit)
```

## Pandas
### General functions
``` python
df.reset_index(drop=True)
df.sort_values(by=['col1', 'col2'], ascending=[True, False]) #sort by col1 ascending then col2 descending
df.drop(columns=['col1', 'col2'], axis=1) #axis=1 for columns
df['col'].astype(int)
df['col'].sum() #Aggregate functions (mean, max, min)
```
``` python
indexes = df.index #gets index
df.iloc[indexes] #gets only selected indexes
```
``` python
df.shift(periods=1) #lag by 1 row (i.e. row 1 becomes row 2)
df.apply(lambda x: x.iloc[0]) #df as x, apply lambda function df.iloc[0] on df
```

### If conditions
``` python
df = df[df['col'] == x] #Get only rows where df col == x
df['col'] = np.where(df['col'] == x, 'True_value', 'False_value') #Transform df col based on the where condition
```

### Merge, concat
``` python
df = df1.merge(df2, how='left', left_on='col', right_on='col', left_index=True, right_index=True)
df = pd.concat([df1, df2])
```

### Logical functions
> use ~ for inverse logical functions, e.g. df[~df['type'].isin(non_play_types)]
> .isin argument must be a list

### String manipulation
> use .str before string manipulation of df columns, e.g. df['col'].str.lower()
> use .contains for wildcard comparison, e.g. df['col'].str.contains('substr')

### Datetime functions
``` python
pd.to_datetime(df['datetime_col']).dt.hour #get hour from datetime column (can be minutes/seconds/etc)
pd.to_datetime(df['datetime_col']).strftime('%Y-%m-%d') #get datetime in specific string format 
pd.to_datetime(df['datetime_col']) + pd.Timedelta('-1 day') #adjusts datetime (Timedelta only allows +, you need to put the - in the arg for date sub)
```

### Partitions
``` python
groups = df.groupby('partition_name') #partition df by partition_name
for name, group in groups #iterate over groups, each group is a df for each partition
```

## Numpy/Scipy
``` python
#Numpy arrays are faster than native Python lists & dicts
np.zeros(row, col) #Zero matrix
np.ones(row, col) #One matrix
np.eye(row_col_size) #Identity matrix
np.diag([matrix, elements]) #Diagonal matrix with matrix elements in [matrix, elements]
```
> **Remember, numpy array slices are views and not copies!**

### Array Broadcasting
> Only works if the trailing dimensions of both arrays are matching or the second array dimension is 1
> (4, 3) (3,) #this works because for (3,), 3 from 0th position is broadcasted to 1st position & both trailing dimensions are 3
> (4, 3) (4,) #this does not work because the 4 from 0th position is broadcasted to 1st position & now trailing dimensions do not match (3 vs 4)
> (4, 3) (4, 1) #this works because now the second array trailing dimension is 1

### Matrix Product
#### Elementwise Product
> Given two multidimensional array objects with the same shape, the elementwise product is result of multiplying the corresponding elements.
#### Matrix Multiplication
> Given two matrices, A of size m×k and  B of size k×n, the matrix multiplication is matrix C of size m×n (k must match)
