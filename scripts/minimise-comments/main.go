package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

// Create structs
type GqlTop struct {
	Data GqlData `json:"data"`
}

type GqlData struct {
	Repo GqlRepo `json:"repository"`
}

type GqlRepo struct {
	Pr GqlPR `json:"pullRequest"`
}

type GqlPR struct {
	Comments GqlComments `json:"comments"`
}

type GqlComments struct {
	Node []GqlNode `json:"nodes"`
}

type GqlNode struct {
	Id        string `json:"id"`
	Body      string `json:"body"`
	Minimized bool   `json:"isMinimized"`
}

func main() {

	getJSON()
}

func getJSON() {
	// Get environment variables
	token := os.Getenv("GITHUB_TOKEN")

	// GraphQL query
	jsonData := map[string]string{
		"query": `
			query {
				repository(owner: "ministryofjustice", name: "modernisation-platform-ami-builds") {
					pullRequest(number: 107) {
						comments(last: 100, orderBy: { field: UPDATED_AT, direction: DESC }) {
							nodes {
								id
								body
								isMinimized
							}
						}
					}
				}
			}
		`,
	}

	// Encode GraphQL query into JSON
	jsonValue, err := json.Marshal(jsonData)
	if err != nil {
		panic(err)
	}

	// HTTP request
	request, err := http.NewRequest("POST", "https://api.github.com/graphql", bytes.NewBuffer(jsonValue))
	if err != nil {
		panic(err)
	}

	client := &http.Client{}

	// HTTP headers
	tokenHeader := "bearer " + token
	request.Header.Add("content-type", "application/json")
	request.Header.Add("Authorization", tokenHeader)

	// HTTP response
	response, err := client.Do(request)
	if err != nil {
		panic(err)
	}

	defer response.Body.Close()

	// HTTP response data
	data, err := ioutil.ReadAll(response.Body)
	if err != nil {
		panic(err)
	}

	isValid := json.Valid(data)

	if isValid {
		fmt.Println("It's valid!")
	} else {
		fmt.Println("It's not valid")
	}

	var message GqlTop

	newerr := json.Unmarshal(data, &message)
	if newerr != nil {
		fmt.Println(newerr)
	}

	// Print results
	fmt.Println(message)
}