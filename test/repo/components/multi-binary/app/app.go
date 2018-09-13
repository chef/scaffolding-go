package app

import (
	"fmt"
	"log"
	"net/http"

	"github.com/chef/scaffolding-go/test/repo/components/multi-binary/config"
	"github.com/chef/scaffolding-go/test/repo/libs"
)

func Start() {
	url := fmt.Sprintf(":%s", config.PORT)
	msg := fmt.Sprintf("multi-binary: Starting app listening on '%s'. (v.%s)", url, config.VERSION)
	fmt.Println(msg)

	http.HandleFunc("/", processRequest)
	err := http.ListenAndServe(url, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

func Run() {
	msg := fmt.Sprintf("multi-binary: Running app through the cli. (v.%s)", config.VERSION)
	fmt.Println(msg)
	libs.VeryUsefulFunction()
}

func processRequest(w http.ResponseWriter, r *http.Request) {
	libs.VeryUsefulFunction()
	config.REQUESTS++
	msg := fmt.Sprintf("{\"req_num\":%d,\"status\":\"processed\"}", config.REQUESTS)
	fmt.Fprintf(w, msg)
}
