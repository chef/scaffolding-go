package main

import "fmt"

var version string

func main() {
	msg := fmt.Sprintf("go-app: Hello Chef Friends! :) v.%s", version)
	fmt.Println(msg)
}
