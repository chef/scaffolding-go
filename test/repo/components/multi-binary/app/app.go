package app

import (
	"fmt"
	"time"

	"github.com/chef/scaffolding-go/test/repo/components/multi-binary/config"
	"github.com/chef/scaffolding-go/test/repo/libs"
)

func Start() {
	msg := fmt.Sprintf("multi-binary: Starting app. (v.%s)", config.VERSION)
	fmt.Println(msg)
	for {
		time.Sleep(1000 * time.Millisecond)
		libs.VeryUsefulFunction()
	}
}

func Run() {
	msg := fmt.Sprintf("multi-binary: Running app. (v.%s)", config.VERSION)
	fmt.Println(msg)
	libs.VeryUsefulFunction()
}
