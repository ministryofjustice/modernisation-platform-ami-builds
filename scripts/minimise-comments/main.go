package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

// Create structure for returned JSON.
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
	// Query
	queryResult := postHttp(createQuery())
	printResults(queryResult)

// 	// Mutation
// 	postHttp(createMutation())
// 	printResults(httpPost)
}

// Assemble the GraphQL query to fetch comments on a PR.
func createQuery() []byte {
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

	return jsonValue
}

// Assemble the GraphQL mutation to minimise comments on a PR.
// func createMutation() {
// 	mutationData := map[string]string{
// 		"mutation": `
// 			mutation minimizeComment(IC_kwDOGDHVyM5Mh8d0: ID!) {
// 				minimizeComment(input: { classifier: OUTDATED, subjectId: IC_kwDOGDHVyM5Mh8d0 }) {
// 		  			clientMutationId
// 				}
// 	  	}
// `,
// 	}
// }

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



func printResults(results []byte) {
	var message GqlTop

	newerr := json.Unmarshal(results, &message)
	if newerr != nil {
		fmt.Println(newerr)
	}

	fmt.Println(message.Data.Repo.Pr.Comments.Node[0].Id)
}