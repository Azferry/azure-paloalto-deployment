locals {
  debug_output = {

    /* Tag Definitions */
    # tags = local.tags
    # pa_tags = local.pa_tags

    /* NAT Policys */
    # nat_policy_definitions_json = local.nat_policy_definitions_json
    # nat_policy_definitions_dataset_from_json = local.nat_policy_definitions_dataset_from_json
    # nat_policy_definitions_map_from_json = local.nat_policy_definitions_map_from_json
    # nat = local.nat
    # nat_config = local.nat_config
    # pa_nat_policy = local.pa_nat_policy

    /* Dynamic Address Groups */
    # dynaddrgrp_definitions_json = local.dynaddrgrp_definitions_json
    # dynaddrgrp_definitions_dataset_from_json = local.dynaddrgrp_definitions_dataset_from_json
    # dynaddrgrp_definitions_map_from_json = local.dynaddrgrp_definitions_map_from_json
    # dynaddrgrp = local.dynaddrgrp
    # pa_dynaddrgrp = local.pa_dynaddrgrp

    /* Sec Policy */
    # sec = local.sec
    # sec_config = local.sec_config
  }


}

output "debug" {
  value = local.debug_output
}
