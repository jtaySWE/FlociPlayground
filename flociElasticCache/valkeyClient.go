package main

import (
	"context"
	"fmt"

	"github.com/valkey-io/valkey-go"
)

func main() {
	// Initialize the client
	client, err := valkey.NewClient(valkey.ClientOption{
		InitAddress: []string{"127.0.0.1:6379"},
	})
	if err != nil {
		panic(err)
	}
	defer client.Close()

	ctx := context.Background()

	// Writing a value using the Developer-friendly command builder
	err = client.Do(ctx, client.B().Set().Key("mykey").Value("Hello Valkey").Build()).Error()
	if err != nil {
		panic(err)
	}

	// Reading the value back
	val, err := client.Do(ctx, client.B().Get().Key("mykey").Build()).ToString()
	if err != nil {
		panic(err)
	}

	fmt.Printf("Key value: %s\n", val)
}
