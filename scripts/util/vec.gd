## Util functions for operations on arrays
extends Node


## Returns the sum of an array
func sum(array: Array[float]) -> float:
	var total = 0.0
	for element in array:
		total += element
	return total


## Returns the average (mean) of an array
func avg(array: Array[float]) -> float:
	return sum(array) / float(array.size())


## Returns the sum of two arrays, added element-wise
func add(array1: Array[float], array2: Array[float]) -> Array[float]:
	var total := array1.duplicate()
	for i in array2.size():
		total[i] += array2[i]
	return total


## Returns the product of two arrays, multiplied element-wise
func mult(array1: Array[float], array2: Array[float]) -> Array[float]:
	var prod := array1.duplicate()
	for i in array2.size():
		prod[i] *= array2[i]
	return prod


## Returns the variance of an array
func vari(array: Array[float]) -> float:
	return avg(mult(array, array)) - avg(array) ** 2


## Returns the standard deviation of an array
func sdev(array: Array[float]) -> float:
	return sqrt(vari(array))


## Returns the covariance of two arrays
func cov(arr1: Array[float], arr2: Array[float]) -> float:
	return avg(mult(arr1, arr2)) - avg(arr1) * avg(arr2)


## Returns the correlation coefficient of two arrays
func rho(arr1: Array[float], arr2: Array[float]) -> float:
	return cov(arr1, arr2) / (sdev(arr1) * sdev(arr2))
