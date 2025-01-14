package main

import "fmt"

func PrintSlice[T any](items []T) {
	for _, item := range items {
		fmt.Println(item)
	}
}

func Find[T comparable](slice []T, value T) bool {
	for _, v := range slice {
		if v == value {
			return true
		}
	}
	return false
}

func SumInts(numbers []int) int {
	total := 0
	for _, num := range numbers {
		total += num
	}
	return total
}

func SumFloats(numbers []float64) float64 {
	total := 0.0
	for _, num := range numbers {
		total += num
	}
	return total
}

func SumGeneric[T int | float64](numbers []T) T {
	var total T
	for _, num := range numbers {
		total += num
	}
	return total
}

type Number interface {
	int | float64
}

func SumWithCustomInterface[T Number](numbers []T) T {
	var total T
	for _, num := range numbers {
		total += num
	}
	return total
}

func Multiply[T Number](a, b T) T {
	return a * b
}

type Stack[T any] struct {
	elements []T
}

func (s *Stack[T]) Push(value T) {
	s.elements = append(s.elements, value)
}

func (s *Stack[T]) Pop() (T, bool) {
	if len(s.elements) == 0 {
		var zeroValue T
		return zeroValue, false
	}
	value := s.elements[len(s.elements)-1]
	s.elements = s.elements[:len(s.elements)-1]
	return value, true
}

func main() {
	// Example usage of PrintSlice
	intSlice := []int{1, 2, 3, 4, 5}
	PrintSlice(intSlice)

	stringSlice := []string{"a", "b", "c"}
	PrintSlice(stringSlice)

	// Example usage of Find
	fmt.Println(Find(intSlice, 3))      // true
	fmt.Println(Find(stringSlice, "d")) // false

	// Example usage of SumInts and SumFloats
	ints := []int{1, 2, 3, 4, 5}
	floats := []float64{1.1, 2.2, 3.3}
	fmt.Println(SumInts(ints))     // 15
	fmt.Println(SumFloats(floats)) // 6.6

	// Example usage of SumGeneric
	fmt.Println(SumGeneric(ints))   // 15
	fmt.Println(SumGeneric(floats)) // 6.6

	// Example usage of SumWithCustomInterface
	fmt.Println(SumWithCustomInterface(ints))   // 15
	fmt.Println(SumWithCustomInterface(floats)) // 6.6

	// Example usage of Multiply
	fmt.Println(Multiply(2, 3))     // 6
	fmt.Println(Multiply(2.5, 4.0)) // 10.0

	// Example usage of Stack
	stack := Stack[int]{}
	stack.Push(10)
	stack.Push(20)
	fmt.Println(stack.Pop()) // 20, true
	fmt.Println(stack.Pop()) // 10, true
	fmt.Println(stack.Pop()) // 0, false
}