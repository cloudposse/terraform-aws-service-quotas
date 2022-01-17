region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "service-quotas"

service_quotas = [
  {
    quota_code   = "L-93826ACB" # aka `Routes per route table`
    service_code = "vpc"
    value        = 100 # since this is non-null, the module should try to create a service quota for this value
  },
  {
    quota_name   = "Subnets per VPC" # aka `L-44499CD2`
    service_code = "vpc"
    value        = 250 # since this is non-null, the module will find the `quota_code` and try to create a service quota for this value
  },
  {
    quota_code   = "L-F678F1CE" # aka `VPC per Region`
    service_code = "vpc"
    value        = null # since this is null, the module should try to lookup the value of this service quota, it should be default
  },
  {
    quota_name   = "VPC security groups per Region" # aka `L-E79EC296`
    service_code = "vpc"
    value        = null # since this is null, the module should try to lookup the value of this service quota, it should be default
  }
]
