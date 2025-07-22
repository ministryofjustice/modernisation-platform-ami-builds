
ami_name_prefix = "base"

image_pipeline = {
  schedule = {
    schedule_expression                = "cron(0 0 1 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

accounts_to_distribute_ami_by_branch = {
  # push to main branch
  main = [
    "core-shared-services-production"
  ]

  default = [
    "core-shared-services-production"
  ]

}

launch_permission_accounts_by_branch = {

  main = [
    "core-shared-services-production",
    "corporate-staff-rostering-development",
    "corporate-staff-rostering-preproduction",
    "corporate-staff-rostering-production",
    "corporate-staff-rostering-test",
    "hmpps-oem-development",
    "hmpps-oem-preproduction",
    "hmpps-oem-production",
    "hmpps-oem-test",
    "hmpps-domain-services-development",
    "hmpps-domain-services-test",
    "hmpps-domain-services-preproduction",
    "hmpps-domain-services-production",
    "nomis-combined-reporting-preproduction",
    "nomis-combined-reporting-production",
    "nomis-combined-reporting-test",
    "nomis-data-hub-development",
    "nomis-data-hub-preproduction",
    "nomis-data-hub-production",
    "nomis-data-hub-test",
    "nomis-development",
    "nomis-preproduction",
    "nomis-production",
    "nomis-test",
    "oasys-development",
    "oasys-preproduction",
    "oasys-production",
    "oasys-test",
    "oasys-national-reporting-preproduction",
    "oasys-national-reporting-production",
    "oasys-national-reporting-test",
    "planetfm-development",
    "planetfm-preproduction",
    "planetfm-production",
    "planetfm-test",
    "delius-core-development"
  ]

  default = [
    "core-shared-services-production",
  ]
}

