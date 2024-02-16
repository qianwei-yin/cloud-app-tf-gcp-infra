# tf-gcp-infra

#### Using Terraform config files to setup Infrastructure

Change values in `terraform.tfvars`

1. `project_id` can be found in the GCP project dashboard page
2. `region` can be an area near you
3. `vpc_list` should be a list consists of VPC names. This is useful when you want to create multiple VPCs at the same time. If you only need one VPC, you can provide `["vpc-name"]`
4. `webapp_ip_cidr_range` and `db_ip_cidr_range` should have a `/24` CIDR address range. This is the requirement of this assignment.
