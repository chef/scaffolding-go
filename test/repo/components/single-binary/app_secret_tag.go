// +build secret

package main

// This file will be use only if we inject any of the tags above to the compiler

import (
	"fmt"

	"github.com/chef/scaffolding-go/test/repo/libs"
)

func main() {
	libs.VeryUsefulFunction()
	fmt.Println("single-binary: Hola! This is a secret file. You wont see it unless you inject the secret tag.")
}
