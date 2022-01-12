module "example_service_quotas" {
  source = "../../"

  context = module.this.context

  service_quotas = var.service_quotas
}
