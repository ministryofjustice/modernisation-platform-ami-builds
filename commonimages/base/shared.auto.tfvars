
ami_name_prefix = "base"

image_pipeline = {
  schedule = {
    schedule_expression = "cron(0 0 1 * ? *)"
    pipeline_execution_start_condition = "EXPRESSION_MATCH_ONLY"
  }
}

account_to_distribute_ami = "core-shared-services-production"

launch_permission_account_names = [
  "core-shared-services-production",
  "corporate-staff-rostering-development",
  "corporate-staff-rostering-preproduction",
  "corporate-staff-rostering-production",
  "corporate-staff-rostering-test",
  "hmpps-oem-development",
  "hmpps-oem-preproduction",
  "hmpps-oem-production",
  "hmpps-oem-test",
  "hmpps-domain-services-test",
  "nomis-combined-reporting-development",
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
  "planetfm-development",
  "planetfm-preproduction",
  "planetfm-production",
  "planetfm-test",
  "delius-core-development"
]
