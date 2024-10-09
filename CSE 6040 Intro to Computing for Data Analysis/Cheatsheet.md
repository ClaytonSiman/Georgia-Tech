# Cheatsheet

## Useful packages
### Deepcopy
import copy
x_copy = copy.copy(x) #Shallow copy
x_deepcopy = copy.deepcopy(x) #Deep copy

### Default Dictionary
from collections import defaultdict
my_dict = defaultdict(list) #Create a defaultdict with a default value of an empty list
my_dict['fruits'].append('apple') #Add elements to the defaultdict

### Iterables
#### Permutations
from itertools import permutations 
perm = permutations([1, 2, 3], 2) #Get all pairs of permutations of [1, 2, 3] 
for i in list(perm): 
    print (i) 

#### Combinations
from itertools import combinations
comb = combinations([1, 2, 3], 2) #Get all pairs of combinations of [1, 2, 3] 
for i in list(comb): 
    print (i) 

## Numpy/Scipy
Numpy arrays are faster than native Python lists & dicts
np.zeros(row, col) #Zero matrix
np.ones(row, col) #One matrix
np.eye(row_col_size) #Identity matrix
np.diag([matrix, elements]) #Diagonal matrix with matrix elements in [matrix, elements]

#### Remember, numpy array slices are views and not copies!

### Array Broadcasting
Only works if the trailing dimensions of both arrays are matching or the second array dimension is 1
(4, 3) (3,) #this works because for (3,), 3 from 0th position is broadcasted to 1st position & both trailing dimensions are 3
(4, 3) (4,) #this does not work because the 4 from 0th position is broadcasted to 1st position & now trailing dimensions do not match (3 vs 4)
(4, 3) (4, 1) #this works because now the second array trailing dimension is 1

### Matrix Product
#### Elementwise Product
Given two multidimensional array objects with the same shape, the elementwise product is result of multiplying the corresponding elements.
#### Matrix Multiplication
Given two matrices, A of size m×k and  B of size k×n, the matrix multiplication is matrix C of size m×n (k must match)
