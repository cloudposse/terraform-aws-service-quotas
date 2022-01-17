package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// struct to handle complex output of module
type ServiceQuota struct {
	Adjustable   bool    `json:"adjustable"`
	ARN          string  `json:"arn"`
	DefaultValue string  `json:"default_value"`
	GlobalQuota  bool    `json:"global_quota"`
	ID           string  `json:"id"`
	ServiceName  string  `json:"service_name"`
	Value        float64 `json:"value"`
	QuotaCode    string  `json:"quota_code"`
	QuotaName    string  `json:"quota_name"`
	ServiceCode  string  `json:"service_code"`
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	// see https://docs.aws.amazon.com/general/latest/gr/vpc-service.html#vpc-quotas
	defaultVpcsPerRegion := 50

	// see output of `aws service-quotas list-service-quotas --service-code vpc`
	expectedVpcPerRegionQuotaCode := "L-F678F1CE"
	expectedVpcRoutesPerTableQuotaCode := "L-93826ACB"
	expectedVpcSecurityGroupsPerRegionQuotaCode := "L-E79EC296"
	expectedVpcSubnetsSharedWithAccountCode := "L-44499CD2"

	// these are set in `fixtures.us-east-2.tfvars`
	expectedVpcRoutesPerTableValue := 100
	expectedVpcSecurityGroupsPerRegionName := "VPC security groups per Region"
	expectedVpcSubnetsSharedWithAccountName := "Subnets per VPC"
	expectedVpcSubnetsSharedWithAccountValue := 250

	// this is defined in `fixtures.us-east-2.tfvars`
	expectedServiceCode := "vpc"

	// initialize slice for outputs
	serviceQuotas := []ServiceQuota{}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output of a struct
	terraform.OutputStruct(t, terraformOptions, "service_quotas", serviceQuotas)

	// verify outputs
	for _, quota := range serviceQuotas {
		// all quotas should be for `vpc`
		assert.Equal(t, expectedServiceCode, quota.ServiceCode)

		switch quota.QuotaCode {
		case expectedVpcRoutesPerTableQuotaCode:
			assert.Equal(t, expectedVpcRoutesPerTableQuotaCode, quota.QuotaCode)
			assert.Equal(t, expectedVpcRoutesPerTableValue, quota.Value)
		case expectedVpcPerRegionQuotaCode:
			assert.Equal(t, expectedVpcRoutesPerTableQuotaCode, quota.QuotaCode)
			assert.Equal(t, expectedVpcRoutesPerTableValue, quota.Value)
		case expectedVpcPerRegionQuotaCode:
			assert.Equal(t, defaultVpcsPerRegion, quota.Value)
		case expectedVpcSecurityGroupsPerRegionQuotaCode:
			assert.Equal(t, expectedVpcSecurityGroupsPerRegionName, quota.QuotaName)

		case expectedVpcSubnetsSharedWithAccountCode:
			assert.Equal(t, expectedVpcSubnetsSharedWithAccountName, quota.QuotaName)
			assert.Equal(t, expectedVpcSubnetsSharedWithAccountValue, quota.Value)
		}
	}
}

// Test the Terraform module in examples/complete doesn't attempt to create resources with enabled=false
func TestExamplesAccountSettingsDisabled(t *testing.T) {
	testNoChanges(t, "../../examples/complete")
}
