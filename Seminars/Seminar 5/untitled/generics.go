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
