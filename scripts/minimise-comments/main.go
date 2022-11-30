package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

// JSON reponse structure from GraphQL query
type graphqlQuery struct {
	Data graphqlQueryData `json:"data"`
}

type graphqlQueryData struct {
	Repo graphqlQueryRepo `json:"repository"`
}

type graphqlQueryRepo struct {
	Pr graphqlQueryPr `json:"pullRequest"`
}

type graphqlQueryPr struct {
	Comments graphqlQueryComments `json:"comments"`
}

type graphqlQueryComments struct {
	Node []graphqlQueryNode `json:"nodes"`
}

type graphqlQueryNode struct {
	Id        string `json:"id"`
	Body      string `json:"body"`
	Minimized bool   `json:"isMinimized"`
}

// JSON response structure from GraphQL mutation
type graphqlMutation struct {
	Data graphqlMutationData `json:"data"`
}

type graphqlMutationData struct {
	Comment graphqlMutationComment `json:"minimizeComment"`
}

type graphqlMutationComment struct {
	Id string `json:"clientMutationId"`
}

func main() {
	// GraphQL query
	queryResult := postHttp(createQuery())
	printQueryResults(queryResult)

	// GraphQL mutation
	mutationResult := postHttp(createMutation())
	printMutationResults(mutationResult)
}

// Assemble GraphQL query
func createQuery() []byte {
	queryData := map[string]string{
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

	// Encode into JSON
	jsonValue, err := json.Marshal(queryData)
	if err != nil {
		panic(err)
	}

	return jsonValue
}

// Assemble GraphQL mutation
func createMutation() []byte {
	mutationData := map[string]string{
		"mutation": `
			mutation {
				minimizeComment(input: {classifier: OUTDATED, subjectId: "IC_kwDOGDHVyM5Mh8d0"}) {
			  		clientMutationId
				}
		  	}

		`,
	}

	// Encode into JSON
	jsonValue, err := json.Marshal(mutationData)
	if err != nil {
		panic(err)
	}

	return jsonValue
}

func postHttp(postData []byte) []byte {
	// Get environment variables
	githubToken := os.Getenv("GITHUB_TOKEN")

	// HTTP request
	request, err := http.NewRequest("POST", "https://api.github.com/graphql", bytes.NewBuffer(postData))
	if err != nil {
		panic(err)
	}

	client := &http.Client{}

	// HTTP headers
	tokenHeader := "bearer " + githubToken
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

	return data
}

func printQueryResults(results []byte) {
	var response graphqlQuery

	err := json.Unmarshal(results, &response)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Query:", response.Data.Repo.Pr.Comments.Node[0].Id)
}

func printMutationResults(results []byte) {
	var response graphqlMutation

	err := json.Unmarshal(results, &response)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Mutation:", response)
}
