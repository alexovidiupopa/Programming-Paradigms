package main

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
