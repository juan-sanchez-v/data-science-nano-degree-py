import time
import numpy as np

# helper method to print np array details
def np_array_details(np_array):
    d = "Numpy array details \n" \
        "Dimension:  {} \n" \
        "    Shape:  {} \n" \
        "     Size:  {} \n" \
        "Data Type:  {} ".format(np_array.ndim, np_array.shape, np_array.size, np_array.dtype)
    print(d)


x = np.random.random(1000000)

print("time it takes regular python code to calculate the mean of X")
start = time.time()
avg = sum(x) / len(x)
print(time.time() - start)

print("time it takes numpy to calculate the mean of X")
start = time.time()
np.mean(x)
print(time.time() - start)

# Creating Numpy ndarrays (n dimensional arrays)
x = np.array([1,2,3,4,5,6])  # 1 dimensional array
print(x)
print(type(x))
print(x.dtype)  # returns the data type in the x numpy array

print(x.shape)  # return the shape of the np array
print(x.ndim)  # return the n dimension of hte np array
print(x.size) # total number of elements in the array

# Two dimensional array
# We create a rank 2 ndarray that only contains integers
Y = np.array([[1,2,3],[4,5,6],[7,8,9], [10,11,12]])

# We print Y
print()
print('Y = \n', Y)
print()

# We print information about Y
print('Y has dimensions:', Y.shape)
print('Y has a total of', Y.size, 'elements')
print('Y is an object of type:', type(Y))
print('The elements in Y are of type:', Y.dtype)

# specify the data type in an array
s = np.array([1,2,3.4,5.5], dtype=int)
print(s)

# Save np array to the directory as int_array.npy
np.save('int_array', s)

# load the np array saved as int_array.npy from the directory
t = np.load('int_array.npy')
print("Array loaded into T from the directory \n", t)

s = np.array([[1,2,3], [6,5,4]])
print(s.shape)
print(s.size)

print("3-d Array")
three_d = np.array([[[1,2,3], [4,5,6]],
                   [[9,8,7], [10,11,12]]])
print(three_d)
print(three_d.shape)
print(three_d.size)

print('\nBuilt in functions')
# Useful built-in functions to create np arrays

# Zeros
x = np.zeros((3,4)) # creates an array of zeros of the given shape/dtype. etc.
np_array_details(x)
print(x)
print()
# Ones
y = np.ones((4,5))
print(y)
np_array_details(y)
print()
# full creates an array with fills it with a constant value
w = np.full((3,4), 5)
print(w)
np_array_details(w)
print()
# Identity creates an identity matrix (square matrix with 1 in the main diagonal and zeros everywhere else).

identity_matrix = np.eye(4)
np_array_details(identity_matrix)
print(identity_matrix)
print()


print("Numpy arange function")
print('\nCase#1: One param') # The stop argument is exclusive. This gives us an array from 0 to 10-1.
x = np.arange(10)
print(x)

print()
print('\nCase#2: two param')
y = np.arange(4,10) # Start, stop (exclusive)
print(y)


print()
print('\nCase#3: three param')
z = np.arange(1, 14, 3) # start, stop (exclusive), evenly spaced digit
print(z)

print()
print("Using linspace to get a better non integer evenly spaced array")
# Linspace requires at least two params. Start, Stop. The third param tells the function the number of evenly spaced element to create. Both start and stop are inclusive.
# If the number of evenly spaced items is not provided, linspace defaults to 50
# To exclude the endpoint, simply pass the endpoint=False to the linspace function.
xl = np.linspace(2,10, 3)
print(xl)

# Reshape function
# Allows you to reshape a numpy array into another shape
# You cannot reshape an array to one with more elements than the original array.
print("\nReshape function")
rx = np.array([range(10)])
print("rx: ",rx)
rx = np.reshape(rx, (2,5))
print("rx: ", rx)

# np array methods support dot notation
# this works with linspace as well
print("\nUsing dot notation on np array methods")
l = np.arange(20).reshape(5,4)
print(l)

# Creating Random np array
print("\nRandom Array creation")
ran = np.random.random((3,3))
print(ran)

# randint function
print("\nRand int Function")
# Upper bound is exclusive
ranint = np.random.randint(4, 15, (3,2))
print(ranint)

# Create np array with average mean = 0 and a given distribution
print("\nArray from a Normal Distribution")
normal = np.random.normal(0, 0.1, size=(10,2))
print(normal)
