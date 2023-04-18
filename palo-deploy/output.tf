
locals {
  debug_output = {
    /* Json Definitions */
    # definitions_json = local.definitions_json
    # definitions_dataset_from_json = local.definitions_dataset_from_json
    # definitions_map_from_json = local.definitions_map_from_json
    palo_nva = local.palo_nva
    # resource_groups = local.resource_groups
    /* Market place agreement */
    palo_marketplace_agreements = local.palo_marketplace_agreements

  }
}


output "debug" {
  value = local.debug_output
}
