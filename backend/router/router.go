package main

import (
	"fmt"
	"net/http"
)
func main(){
	_, err := http.Get("http://localhost:8080/a");
	if err!=nil{
        fmt.Print("sorry flutter server ma kehi gadbad cha.");
        return;
    }else{
		fmt.Print("thanks yaar");
	}
}