// +build tag1 tag2 tag2 !secret

package main

// This file will be use only if we inject any of the tags above to
// the compiler, except for the 'secret' tag. When you specify that tag
// we will compile the file 'app_secret_tag.go' instead.

import (
	"fmt"

	"github.com/chef/scaffolding-go/test/repo/libs"
)

func main() {
	libs.VeryUsefulFunction()
	fmt.Println("single-binary: Hola, todo bien!")
}
