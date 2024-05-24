package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestImageBuilder(t *testing.T) {
	t.Parallel()

	terraformDir := "./unit-test"

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
	}

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform plan"
	terraform.InitAndPlan(t, terraformOptions)

	// Run "terraform init" and "terraform apply"
	// terraform.InitAndApply(t, terraformOptions)

	// Example assertions to check outputs
	amiID := terraform.Output(t, terraformOptions, "ami_id")
	assert.NotEmpty(t, amiID)
}
