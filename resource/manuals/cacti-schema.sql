-- Reference only; not an installation or upgrade script.
CREATE TABLE `aggregate_graph_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `graph_template_id` int(10) unsigned NOT NULL,
  `gprint_prefix` varchar(64) NOT NULL,
  `gprint_format` char(2) default '',
  `graph_type` int(10) unsigned NOT NULL,
  `total` int(10) unsigned NOT NULL,
  `total_type` int(10) unsigned NOT NULL,
  `total_prefix` varchar(64) NOT NULL,
  `order_type` int(10) unsigned NOT NULL,
  `created` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `user_id` int(10) unsigned NOT NULL,
  `graphs` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `graph_template_id` (`graph_template_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Template Definitions for Aggregate Graphs';

CREATE TABLE `aggregate_graph_templates_graph` (
  `aggregate_template_id` int(10) unsigned NOT NULL,
  `t_image_format_id` char(2) default '',
  `image_format_id` tinyint(3) unsigned NOT NULL default '0',
  `t_height` char(2) default '',
  `height` mediumint(8) NOT NULL default '0',
  `t_width` char(2) default '',
  `width` mediumint(8) NOT NULL default '0',
  `t_upper_limit` char(2) default '',
  `upper_limit` varchar(20) NOT NULL default '0',
  `t_lower_limit` char(2) default '',
  `lower_limit` varchar(20) NOT NULL default '0',
  `t_vertical_label` char(2) default '',
  `vertical_label` varchar(200) default '',
  t_vertical_label_angle char(2) default '',
  vertical_label_angle varchar(3) NOT NULL default '',
  t_right_axis_label_angle char(2) default '',
  right_axis_label_angle varchar(3) NOT NULL default '',
  t_right_axis_range char(2) default '',
  right_axis_range varchar(64) NOT NULL default '',
  `t_slope_mode` char(2) default '',
  `slope_mode` char(2) default 'on',
  `t_auto_scale` char(2) default '',
  `auto_scale` char(2) default '',
  `t_auto_scale_opts` char(2) default '',
  `auto_scale_opts` tinyint(3) unsigned NOT NULL default '0',
  `t_auto_scale_log` char(2) default '',
  `auto_scale_log` char(2) default '',
  `t_scale_log_units` char(2) default '',
  `scale_log_units` char(2) default '',
  `t_auto_scale_rigid` char(2) default '',
  `auto_scale_rigid` char(2) default '',
  `t_auto_padding` char(2) default '',
  `auto_padding` char(2) default '',
  `t_base_value` char(2) default '',
  `base_value` mediumint(8) NOT NULL default '0',
  `t_grouping` char(2) default '',
  `grouping` char(2) NOT NULL default '',
  `t_unit_value` char(2) default '',
  `unit_value` varchar(20) default '',
  `t_unit_exponent_value` char(2) default '',
  `unit_exponent_value` varchar(5) NOT NULL default '',
  t_alt_y_grid char(2) default '',
  alt_y_grid char(2) default NULL,
  t_right_axis char(2) default '',
  right_axis varchar(20) default NULL,
  t_right_axis_label char(2) default '',
  right_axis_label varchar(200) default NULL,
  t_right_axis_format char(2) default '',
  right_axis_format mediumint(8) default NULL,
  t_right_axis_formatter char(2) default '',
  right_axis_formatter varchar(10) default NULL,
  t_left_axis_format char(2) default '',
  left_axis_format mediumint(8) default NULL,
  t_left_axis_formatter char(2) default '',
  left_axis_formatter varchar(10) default NULL,
  t_no_gridfit char(2) default '',
  no_gridfit char(2) default NULL,
  t_unit_length char(2) default '',
  unit_length varchar(10) default NULL,
  t_tab_width char(2) default '',
  tab_width varchar(20) default '30',
  t_dynamic_labels char(2) default '',
  dynamic_labels char(2) default NULL,
  t_force_rules_legend char(2) default '',
  force_rules_legend char(2) default NULL,
  t_legend_position char(2) default '',
  legend_position varchar(10) default NULL,
  t_legend_direction char(2) default '',
  legend_direction varchar(10) default NULL,
  PRIMARY KEY (`aggregate_template_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Aggregate Template Graph Data';

CREATE TABLE `aggregate_graph_templates_item` (
  `aggregate_template_id` int(10) unsigned NOT NULL,
  `graph_templates_item_id` int(10) unsigned NOT NULL,
  `sequence` mediumint(8) unsigned NOT NULL default '0',
  `color_template` int(10) unsigned NOT NULL,
  `t_graph_type_id` char(2) default '',
  `graph_type_id` tinyint(3) unsigned NOT NULL default '0',
  `t_cdef_id` char(2) default '',
  `cdef_id` mediumint(8) unsigned default NULL,
  `item_skip` char(2) NOT NULL,
  `item_total` char(2) NOT NULL,
  PRIMARY KEY (`aggregate_template_id`,`graph_templates_item_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Aggregate Template Graph Items';

CREATE TABLE `aggregate_graphs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aggregate_template_id` int(10) unsigned NOT NULL,
  `template_propogation` char(2) NOT NULL default '',
  `local_graph_id` int(10) unsigned NOT NULL,
  `title_format` varchar(128) NOT NULL,
  `graph_template_id` int(10) unsigned NOT NULL,
  `gprint_prefix` varchar(64) NOT NULL,
  `gprint_format` char(2) default '',
  `graph_type` int(10) unsigned NOT NULL,
  `total` int(10) unsigned NOT NULL,
  `total_type` int(10) unsigned NOT NULL,
  `total_prefix` varchar(64) NOT NULL,
  `order_type` int(10) unsigned NOT NULL,
  `created` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aggregate_template_id` (`aggregate_template_id`),
  KEY `local_graph_id` (`local_graph_id`),
  KEY `title_format` (`title_format`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Aggregate Graph Definitions';

CREATE TABLE `aggregate_graphs_graph_item` (
  `aggregate_graph_id` int(10) unsigned NOT NULL,
  `graph_templates_item_id` int(10) unsigned NOT NULL,
  `sequence` mediumint(8) unsigned NOT NULL default '0',
  `color_template` int(10) unsigned NOT NULL,
  `t_graph_type_id` char(2) default '',
  `graph_type_id` tinyint(3) unsigned NOT NULL default '0',
  `t_cdef_id` char(2) default '',
  `cdef_id` mediumint(8) unsigned default NULL,
  `item_skip` char(2) NOT NULL,
  `item_total` char(2) NOT NULL,
  PRIMARY KEY (`aggregate_graph_id`,`graph_templates_item_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Aggregate Graph Graph Items';

CREATE TABLE `aggregate_graphs_items` (
  `aggregate_graph_id` int(10) unsigned NOT NULL,
  `local_graph_id` int(10) unsigned NOT NULL,
  `sequence` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (`aggregate_graph_id`,`local_graph_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Aggregate Graph Items';

CREATE TABLE `automation_devices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `network_id` int(10) unsigned NOT NULL default '0',
  `host_id` int(10) unsigned NOT NULL default '0',
  `hostname` varchar(100) NOT NULL default '',
  `ip` varchar(17) NOT NULL default '',
  `snmp_community` varchar(100) NOT NULL default '',
  `snmp_version` tinyint(3) unsigned NOT NULL default '1',
  `snmp_port` mediumint(8) unsigned NOT NULL default '161',
  `snmp_username` varchar(50) default NULL,
  `snmp_password` varchar(50) default NULL,
  `snmp_auth_protocol` char(6) default '',
  `snmp_priv_passphrase` varchar(200) default '',
  `snmp_priv_protocol` char(7) default '',
  `snmp_context` varchar(64) default '',
  `snmp_engine_id` varchar(64) default '',
  `sysName` varchar(100) NOT NULL default '',
  `sysLocation` varchar(255) NOT NULL default '',
  `sysContact` varchar(255) NOT NULL default '',
  `sysDescr` varchar(255) NOT NULL default '',
  `sysUptime` bigint(20) unsigned NOT NULL default '0',
  `os` varchar(64) NOT NULL default '',
  `snmp` tinyint(3) unsigned NOT NULL default '0',
  `known` tinyint(3) unsigned NOT NULL default '0',
  `up` tinyint(3) unsigned NOT NULL default '0',
  `time` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`),
  KEY `hostname` (`hostname`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table of Discovered Devices';

CREATE TABLE `automation_graph_rule_items` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `rule_id` mediumint(8) unsigned NOT NULL default '0',
  `sequence` smallint(3) unsigned NOT NULL default '0',
  `operation` smallint(3) unsigned NOT NULL default '0',
  `field` varchar(255) NOT NULL default '',
  `operator` smallint(3) unsigned NOT NULL default '0',
  `pattern` varchar(255) NOT NULL default '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Automation Graph Rule Items';

CREATE TABLE `automation_graph_rules` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `snmp_query_id` smallint(3) unsigned NOT NULL default '0',
  `graph_type_id` smallint(3) unsigned NOT NULL default '0',
  `enabled` char(2) default '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Automation Graph Rules';

CREATE TABLE `automation_ips` (
  `ip_address` varchar(20) NOT NULL default '',
  `hostname` varchar(100) default NULL,
  `network_id` int(10) unsigned default NULL,
  `pid` int(10) unsigned default NULL,
  `status` int(10) unsigned default NULL,
  `thread` int(10) unsigned default NULL,
  PRIMARY KEY (`ip_address`),
  KEY `pid` (`pid`)
) ENGINE=MEMORY COMMENT='List of discoverable ip addresses used for scanning';

CREATE TABLE `automation_match_rule_items` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `rule_id` mediumint(8) unsigned NOT NULL default '0',
  `rule_type` smallint(3) unsigned NOT NULL default '0',
  `sequence` smallint(3) unsigned NOT NULL default '0',
  `operation` smallint(3) unsigned NOT NULL default '0',
  `field` varchar(255) NOT NULL default '',
  `operator` smallint(3) unsigned NOT NULL default '0',
  `pattern` varchar(255) NOT NULL default '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Automation Match Rule Items';

CREATE TABLE `automation_networks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `poller_id` int(10) unsigned default '1',
  `site_id` int(10) unsigned default '1',
  `name` varchar(128) NOT NULL default '',
  `subnet_range` varchar(1024) NOT NULL default '',
  `ignore_ips` varchar(1024) NOT NULL default '',
  `dns_servers` varchar(128) NOT NULL default '',
  `enabled` char(2) default '',
  `notification_enabled` char(2) default '',
  `notification_email` varchar(255) default '',
  `notification_fromname` varchar(32) default '',
  `notification_fromemail` varchar(128) default '',
  `snmp_id` int(10) unsigned default NULL,
  `enable_netbios` char(2) default '',
  `add_to_cacti` char(2) default '',
  `same_sysname` char(2) default '',
  `total_ips` int(10) unsigned default '0',
  `up_hosts` int(10) unsigned NOT NULL default '0',
  `snmp_hosts` int(10) unsigned NOT NULL default '0',
  `ping_method` int(10) unsigned NOT NULL default '0',
  `ping_port` int(10) unsigned NOT NULL default '0',
  `ping_timeout` int(10) unsigned NOT NULL default '0',
  `ping_retries` int(10) unsigned default '0',
  `sched_type` int(10) unsigned NOT NULL default '0',
  `threads` int(10) unsigned default '2',
  `run_limit` int(10) unsigned default '0',
  `start_at` varchar(20) default NULL,
  `next_start` timestamp NOT NULL default '0000-00-00 00:00:00',
  `recur_every` int(10) unsigned default '1',
  `day_of_week` varchar(45) default NULL,
  `month` varchar(45) default NULL,
  `day_of_month` varchar(45) default NULL,
  `monthly_week` varchar(45) default NULL,
  `monthly_day` varchar(45) default NULL,
  `last_runtime` double NOT NULL default '0',
  `last_started` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_status` varchar(128) NOT NULL default '',
  `rerun_data_queries` char(2) default NULL,
  PRIMARY KEY (`id`),
  KEY `poller_id` (`poller_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores scanning subnet definitions';

CREATE TABLE `automation_processes` (
  `pid` int(10) unsigned NOT NULL,
  `poller_id` int(10) unsigned default '1',
  `network_id` int(10) unsigned NOT NULL default '0',
  `task` varchar(20) default '',
  `status` varchar(20) default NULL,
  `command` varchar(20) default NULL,
  `up_hosts` int(10) unsigned default '0',
  `snmp_hosts` int(10) unsigned default '0',
  `heartbeat` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY (`pid`,`network_id`)
) ENGINE=MEMORY COMMENT='Table tracking active poller processes';

CREATE TABLE `automation_snmp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Group of SNMP Option Sets';

CREATE TABLE `automation_snmp_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `snmp_id` int(10) unsigned NOT NULL default '0',
  `sequence` int(10) unsigned NOT NULL default '0',
  `snmp_version` tinyint(3) unsigned NOT NULL default '1',
  `snmp_community` varchar(100) NOT NULL,
  `snmp_port` mediumint(8) unsigned NOT NULL default '161',
  `snmp_timeout` int(10) unsigned NOT NULL default '500',
  `snmp_retries` tinyint(3) unsigned NOT NULL default '3',
  `max_oids` int(10) unsigned default '10',
  `bulk_walk_size` int(11) default '-1',
  `snmp_username` varchar(50) default NULL,
  `snmp_password` varchar(50) default NULL,
  `snmp_auth_protocol` char(6) default '',
  `snmp_priv_passphrase` varchar(200) default '',
  `snmp_priv_protocol` char(7) default '',
  `snmp_context` varchar(64) default '',
  `snmp_engine_id` varchar(64) default '',
  PRIMARY KEY (`id`,`snmp_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Set of SNMP Options';

CREATE TABLE `automation_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `host_template` int(10) unsigned NOT NULL default '0',
  `availability_method` int(10) unsigned default '2',
  `sysDescr` varchar(255) default '',
  `sysName` varchar(255) default '',
  `sysOid` varchar(60) default '',
  `description_pattern` varchar(128) default '',
  `populate_location` char(2) default '',
  `sequence` int(10) unsigned default '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Templates of SNMP Sys variables used for automation';

CREATE TABLE `automation_templates_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `template_id` int(10) unsigned NOT NULL default 0,
  `rule_type` tinyint(3) unsigned NOT NULL default 0,
  `rule_id` int(10) unsigned NOT NULL default 0,
  `sequence` tinyint(3) unsigned NOT NULL default 1,
  `exit_rules` char(2) NOT NULL default '',
  PRIMARY KEY (`template_id`,`rule_type`,`rule_id`),
  KEY `id` (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Holds mappings of Automation Templates to Rules';

CREATE TABLE `automation_tree_rule_items` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `rule_id` mediumint(8) unsigned NOT NULL default '0',
  `sequence` smallint(3) unsigned NOT NULL default '0',
  `field` varchar(255) NOT NULL default '',
  `sort_type` smallint(3) unsigned NOT NULL default '0',
  `propagate_changes` char(2) default '',
  `search_pattern` varchar(255) NOT NULL default '',
  `replace_pattern` varchar(255) NOT NULL default '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Automation Tree Rule Items';

CREATE TABLE `automation_tree_rules` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `tree_id` smallint(3) unsigned NOT NULL default '0',
  `tree_item_id` mediumint(8) unsigned NOT NULL default '0',
  `leaf_type` smallint(3) unsigned NOT NULL default '0',
  `host_grouping_type` smallint(3) unsigned NOT NULL default '0',
  `enabled` char(2) default '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Automation Tree Rules';

CREATE TABLE `cdef` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `system` mediumint(8) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `hash` (`hash`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `cdef_items` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  cdef_id mediumint(8) unsigned NOT NULL default '0',
  sequence mediumint(8) unsigned NOT NULL default '0',
  type tinyint(3) unsigned NOT NULL default '0',
  value varchar(150) NOT NULL default '',
  PRIMARY KEY (id),
  KEY cdef_id_sequence (`cdef_id`,`sequence`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `color_templates` (
  `color_template_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL default '',
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`color_template_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Color Templates';

CREATE TABLE `color_template_items` (
  `color_template_item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `color_template_id` mediumint(8) unsigned NOT NULL default '0',
  `color_id` mediumint(8) unsigned NOT NULL default '0',
  `sequence` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (`color_template_item_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Color Items for Color Templates';

CREATE TABLE `colors` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `name` varchar(40) default '',
  `hex` varchar(6) NOT NULL default '',
  `read_only` char(2) default '',
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  UNIQUE KEY hex (hex)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_input` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(200) NOT NULL default '',
  `input_string` varchar(512) default NULL,
  `type_id` tinyint(3) unsigned NOT NULL default '0',
  `data_sources` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `name_type_id` (`name`(171), `type_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_input_data` (
  data_input_field_id mediumint(8) unsigned NOT NULL default '0',
  data_template_data_id int(10) unsigned NOT NULL default '0',
  data_template_id int(10) unsigned NOT NULL default '0',
  local_data_id int(10) unsigned NOT NULL default '0',
  host_id int(10) unsigned NOT NULL default '0',
  t_value char(2) default NULL,
  value text,
  PRIMARY KEY (data_input_field_id,data_template_data_id),
  KEY data_template_data_id (data_template_data_id),
  KEY t_value (t_value),
  KEY data_template_id (data_template_id),
  KEY local_data_id (local_data_id),
  KEY host_id (host_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_input_fields` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  data_input_id mediumint(8) unsigned NOT NULL default '0',
  name varchar(200) NOT NULL default '',
  data_name varchar(50) NOT NULL default '',
  input_output char(3) NOT NULL default '',
  update_rra char(2) default '0',
  sequence smallint(5) NOT NULL default '0',
  type_code varchar(40) default NULL,
  regexp_match varchar(200) default NULL,
  allow_nulls char(2) default NULL,
  PRIMARY KEY (id),
  KEY data_input_id (data_input_id),
  KEY input_output (input_output),
  KEY type_code_data_input_id (type_code, data_input_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_local` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `data_template_id` mediumint(8) unsigned NOT NULL default 0,
  `host_id` mediumint(8) unsigned NOT NULL default 0,
  `snmp_query_id` mediumint(8) NOT NULL default 0,
  `snmp_index` varchar(255) NOT NULL default '',
  `orphan` tinyint(3) unsigned NOT NULL default 0,
  `errored` tinyint(3) unsigned NOT NULL default 0,
  PRIMARY KEY (`id`),
  KEY `host_id_snmp_query_id` (`host_id`,`snmp_query_id`),
  KEY `snmp_index` (`snmp_index`),
  KEY `data_template_id` (`data_template_id`),
  KEY `snmp_query_id` (`snmp_query_id`),
  KEY `orphan` (`orphan`),
  KEY `errored` (`errored`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_debug` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `started` int(10) unsigned NOT NULL default '0',
  `done` int(10) unsigned NOT NULL default '0',
  `user` int(10) unsigned NOT NULL default '0',
  `datasource` int(10) unsigned NOT NULL default '0',
  `info` text NOT NULL,
  `issue` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `done` (`done`),
  KEY `datasource` (`datasource`),
  KEY `started` (`started`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Datasource Debugger Information';

CREATE TABLE `data_source_profiles` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `step` int(10) unsigned NOT NULL default '300',
  `heartbeat` int(10) unsigned NOT NULL default '600',
  `x_files_factor` double default '0.5',
  `default` char(2) default '',
  `data_sources` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores Data Source Profiles';

CREATE TABLE `data_source_profiles_cf` (
  `data_source_profile_id` mediumint(8) unsigned NOT NULL default '0',
  `consolidation_function_id` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY (`data_source_profile_id`,`consolidation_function_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Maps the Data Source Profile Consolidation Functions';

CREATE TABLE `data_source_profiles_rra` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `data_source_profile_id` mediumint(8) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `steps` int(10) unsigned default '1',
  `rows` int(10) unsigned NOT NULL default '700',
  `timespan` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `data_source_profile_id` (`data_source_profile_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores RRA Definitions for Data Source Profiles';

CREATE TABLE `data_source_purge_action` (
  `id` integer UNSIGNED auto_increment,
  `name` varchar(128) NOT NULL default '',
  `local_data_id` int(10) unsigned NOT NULL default '0',
  `action` tinyint(3) unsigned NOT NULL default 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY name (`name`))
  ENGINE=InnoDB
  ROW_FORMAT=Dynamic
  COMMENT='RRD Cleaner File Actions';

CREATE TABLE `data_source_purge_temp` (
  `id` integer UNSIGNED auto_increment,
  `name_cache` varchar(255) NOT NULL default '',
  `local_data_id` int(10) unsigned NOT NULL default '0',
  `name` varchar(128) NOT NULL default '',
  `size` integer UNSIGNED NOT NULL default '0',
  `last_mod` TIMESTAMP NOT NULL default '0000-00-00 00:00:00',
  `in_cacti` tinyint(3) unsigned NOT NULL default '0',
  `data_template_id` mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY name (`name`),
  KEY local_data_id (`local_data_id`),
  KEY in_cacti (`in_cacti`),
  KEY data_template_id (`data_template_id`))
  ENGINE=InnoDB
  ROW_FORMAT=Dynamic
  COMMENT='RRD Cleaner File Repository';

CREATE TABLE `data_source_stats_command_cache` (
  `local_data_id` int(10) unsigned NOT NULL default 0,
  `stats_command` BLOB NOT NULL default '',
  PRIMARY KEY (`local_data_id`))
  ENGINE=InnoDB
  ROW_FORMAT=DYNAMIC
  COMMENT='Holds the RRDfile Stats Commands';

CREATE TABLE `data_source_stats_daily` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `cf` tinyint(3) unsigned NOT NULL default 0,
  `average` double default NULL,
  `peak` double default NULL,
  `p95n` double default NULL,
  `p90n` double default NULL,
  `p75n` double default NULL,
  `p50n` double default NULL,
  `p25n` double default NULL,
  `sum` double default NULL,
  `stddev` double default NULL,
  `lslslope` double default NULL,
  `lslint` double default NULL,
  `lslcorrel` double default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`,`cf`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_source_stats_hourly` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `cf` tinyint(3) unsigned NOT NULL default 0,
  `average` double default NULL,
  `peak` double default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`,`cf`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_source_stats_hourly_cache` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `value` DOUBLE default NULL,
  PRIMARY KEY (`local_data_id`,`time`,`rrd_name`),
  KEY `time` USING BTREE (`time`)
  ) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_source_stats_hourly_last` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `value` DOUBLE default NULL,
  `calculated` DOUBLE default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`)
  ) ENGINE=MEMORY;

CREATE TABLE `data_source_stats_monthly` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `cf` tinyint(3) unsigned NOT NULL default 0,
  `average` double default NULL,
  `peak` double default NULL,
  `p95n` double default NULL,
  `p90n` double default NULL,
  `p75n` double default NULL,
  `p50n` double default NULL,
  `p25n` double default NULL,
  `sum` double default NULL,
  `stddev` double default NULL,
  `lslslope` double default NULL,
  `lslint` double default NULL,
  `lslcorrel` double default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`,`cf`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_source_stats_weekly` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `cf` tinyint(3) unsigned NOT NULL default 0,
  `average` double default NULL,
  `peak` double default NULL,
  `p95n` double default NULL,
  `p90n` double default NULL,
  `p75n` double default NULL,
  `p50n` double default NULL,
  `p25n` double default NULL,
  `sum` double default NULL,
  `stddev` double default NULL,
  `lslslope` double default NULL,
  `lslint` double default NULL,
  `lslcorrel` double default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`,`cf`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_source_stats_yearly` (
  `local_data_id` int(10) unsigned NOT NULL,
  `rrd_name` varchar(19) NOT NULL,
  `cf` tinyint(3) unsigned NOT NULL default 0,
  `average` double default NULL,
  `peak` double default NULL,
  `p95n` double default NULL,
  `p90n` double default NULL,
  `p75n` double default NULL,
  `p50n` double default NULL,
  `p25n` double default NULL,
  `sum` double default NULL,
  `stddev` double default NULL,
  `lslslope` double default NULL,
  `lslint` double default NULL,
  `lslcorrel` double default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`,`cf`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `data_template` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(150) NOT NULL default '',
  `data_sources` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  `last_updated` timestamp default CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY `name` (`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_template_data` (
  id int(10) unsigned NOT NULL auto_increment,
  local_data_template_data_id int(10) unsigned NOT NULL default '0',
  local_data_id int(10) unsigned NOT NULL default '0',
  data_template_id mediumint(8) unsigned NOT NULL default '0',
  data_input_id mediumint(8) unsigned NOT NULL default '0',
  t_name char(2) default NULL,
  name varchar(250) NOT NULL default '',
  name_cache varchar(255) NOT NULL default '',
  data_source_path varchar(255) default '',
  t_active char(2) default '',
  active char(2) default NULL,
  t_rrd_step char(2) default '',
  rrd_step mediumint(8) unsigned NOT NULL default '0',
  t_data_source_profile_id char(2) default '',
  data_source_profile_id mediumint(8) unsigned NOT NULL default '1',
  PRIMARY KEY (id),
  KEY local_data_id (local_data_id),
  KEY data_template_id (data_template_id),
  KEY data_input_id (data_input_id),
  KEY name_cache (name_cache)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `data_template_rrd` (
  id int(10) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  local_data_template_rrd_id int(10) unsigned NOT NULL default '0',
  local_data_id int(10) unsigned NOT NULL default '0',
  data_template_id mediumint(8) unsigned NOT NULL default '0',
  t_rrd_maximum char(2) default NULL,
  rrd_maximum varchar(20) NOT NULL default '0',
  t_rrd_minimum char(2) default NULL,
  rrd_minimum varchar(20) NOT NULL default '0',
  t_rrd_heartbeat char(2) default NULL,
  rrd_heartbeat mediumint(6) NOT NULL default '0',
  t_data_source_type_id char(2) default NULL,
  data_source_type_id smallint(5) NOT NULL default '0',
  t_data_source_name char(2) default NULL,
  data_source_name varchar(19) NOT NULL default '',
  t_data_input_field_id char(2) default NULL,
  data_input_field_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  UNIQUE KEY `duplicate_dsname_contraint` (`local_data_id`,`data_source_name`,`data_template_id`),
  KEY data_template_id (data_template_id),
  KEY local_data_template_rrd_id (local_data_template_rrd_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `external_links` (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sortorder int(10) unsigned NOT NULL default '0',
  enabled char(2) default 'on',
  contentfile varchar(255) NOT NULL default '',
  title varchar(20) NOT NULL default '',
  style varchar(10) NOT NULL default '',
  extendedstyle varchar(50) NOT NULL default '',
  refresh int unsigned default NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Contains external links that are embedded into Cacti';

CREATE TABLE `graph_local` (
  id int(10) unsigned NOT NULL auto_increment,
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  host_id mediumint(8) unsigned NOT NULL default '0',
  snmp_query_id mediumint(8) NOT NULL default '0',
  snmp_query_graph_id mediumint(8) NOT NULL default '0',
  snmp_index varchar(255) NOT NULL default '',
  PRIMARY KEY (id),
  KEY host_id (host_id),
  KEY graph_template_id (graph_template_id),
  KEY snmp_query_id (snmp_query_id),
  KEY snmp_query_graph_id (snmp_query_graph_id),
  KEY snmp_index (snmp_index)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Creates a relationship for each item in a custom graph.';

CREATE TABLE `graph_template_input` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  name varchar(255) NOT NULL default '',
  description text,
  column_name varchar(50) NOT NULL default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores the names for graph item input groups.';

CREATE TABLE `graph_template_input_defs` (
  graph_template_input_id int(10) unsigned NOT NULL default '0',
  graph_template_item_id int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (graph_template_input_id,graph_template_item_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores the relationship for what graph items are associated';

CREATE TABLE `graph_templates` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` char(32) NOT NULL default '',
  `name` char(255) NOT NULL default '',
  `class` varchar(40) NOT NULL default '',
  `version` varchar(10) NOT NULL default '',
  `multiple` char(2) NOT NULL default '',
  `test_source` char(2) NOT NULL default '',
  `graphs` int(10) unsigned NOT NULL default '0',
  `last_updated` timestamp default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `multiple_name` (`multiple`, `name`),
  KEY `name` (`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Contains each graph template name.';

CREATE TABLE `graph_templates_gprint` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `gprint_text` varchar(255) default NULL,
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `name` (`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `graph_templates_graph` (
  id int(10) unsigned NOT NULL auto_increment,
  local_graph_template_graph_id int(10) unsigned NOT NULL default '0',
  local_graph_id int(10) unsigned NOT NULL default '0',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  t_image_format_id char(2) default '',
  image_format_id tinyint(3) unsigned NOT NULL default '0',
  t_title char(2) default '',
  title varchar(255) NOT NULL default '',
  title_cache varchar(255) NOT NULL default '',
  t_height char(2) default '',
  height mediumint(8) NOT NULL default '0',
  t_width char(2) default '',
  width mediumint(8) NOT NULL default '0',
  t_upper_limit char(2) default '',
  upper_limit varchar(20) NOT NULL default '0',
  t_lower_limit char(2) default '',
  lower_limit varchar(20) NOT NULL default '0',
  t_vertical_label char(2) default '',
  vertical_label varchar(200) default NULL,
  t_vertical_label_angle char(2) default '',
  vertical_label_angle varchar(3) NOT NULL default '',
  t_right_axis_label_angle char(2) default '',
  right_axis_label_angle varchar(3) NOT NULL default '',
  t_right_axis_range char(2) default '',
  right_axis_range varchar(64) NOT NULL default '',
  t_slope_mode char(2) default '',
  slope_mode char(2) default 'on',
  t_auto_scale char(2) default '',
  auto_scale char(2) default NULL,
  t_auto_scale_opts char(2) default '',
  auto_scale_opts tinyint(3) unsigned NOT NULL default '0',
  t_auto_scale_log char(2) default '',
  auto_scale_log char(2) default NULL,
  t_scale_log_units char(2) default '',
  scale_log_units char(2) default NULL,
  t_auto_scale_rigid char(2) default '',
  auto_scale_rigid char(2) default NULL,
  t_auto_padding char(2) default '',
  auto_padding char(2) default NULL,
  t_base_value char(2) default '',
  base_value mediumint(8) NOT NULL default '0',
  `t_grouping` char(2) default '',
  `grouping` char(2) NOT NULL default '',
  t_unit_value char(2) default '',
  unit_value varchar(20) default NULL,
  t_unit_exponent_value char(2) default '',
  unit_exponent_value varchar(5) NOT NULL default '',
  t_alt_y_grid char(2) default '',
  alt_y_grid char(2) default NULL,
  t_right_axis char(2) default '',
  right_axis varchar(20) default NULL,
  t_right_axis_label char(2) default '',
  right_axis_label varchar(200) default NULL,
  t_right_axis_format char(2) default '',
  right_axis_format mediumint(8) default NULL,
  t_right_axis_formatter char(2) default '',
  right_axis_formatter varchar(10) default NULL,
  t_left_axis_format char(2) default '',
  left_axis_format mediumint(8) default NULL,
  t_left_axis_formatter char(2) default '',
  left_axis_formatter varchar(10) default NULL,
  t_no_gridfit char(2) default '',
  no_gridfit char(2) default NULL,
  t_unit_length char(2) default '',
  unit_length varchar(10) default NULL,
  t_tab_width char(2) default '',
  tab_width varchar(20) default '30',
  t_dynamic_labels char(2) default '',
  dynamic_labels char(2) default NULL,
  t_force_rules_legend char(2) default '',
  force_rules_legend char(2) default NULL,
  t_legend_position char(2) default '',
  legend_position varchar(10) default NULL,
  t_legend_direction char(2) default '',
  legend_direction varchar(10) default NULL,
  PRIMARY KEY (id),
  KEY local_graph_id (local_graph_id),
  KEY graph_template_id (graph_template_id),
  KEY title_cache (title_cache)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores the actual graph data.';

CREATE TABLE `graph_templates_item` (
  id int(10) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  local_graph_template_item_id int(10) unsigned NOT NULL default '0',
  local_graph_id int(10) unsigned NOT NULL default '0',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  task_item_id int(10) unsigned NOT NULL default '0',
  color_id mediumint(8) unsigned NOT NULL default '0',
  alpha char(2) default 'FF',
  color2_id mediumint(8) unsigned NOT NULL default '0',
  alpha2 char(2) default 'FF',
  gradheight tinyint(4) NOT NULL default '50',
  graph_type_id tinyint(3) unsigned NOT NULL default '0',
  line_width DECIMAL(4,2) default 0,
  dashes varchar(20) default NULL,
  dash_offset mediumint(4) default NULL,
  cdef_id mediumint(8) unsigned NOT NULL default '0',
  vdef_id mediumint(8) unsigned NOT NULL default '0',
  shift char(2) default NULL,
  consolidation_function_id tinyint(3) unsigned NOT NULL default '0',
  textalign varchar(10) default NULL,
  text_format varchar(255) default NULL,
  legend varchar(30) default NULL,
  value varchar(255) default NULL,
  hard_return char(2) default NULL,
  gprint_id mediumint(8) unsigned NOT NULL default '0',
  sequence mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY graph_template_id (graph_template_id),
  KEY local_graph_id_sequence (local_graph_id, sequence),
  KEY local_graph_template_item_id (local_graph_template_item_id),
  KEY task_item_id (task_item_id),
  KEY cdef_id (cdef_id),
  KEY vdef_id (vdef_id),
  KEY color_id (color_id),
  KEY gprint_id (gprint_id),
  KEY `lgi_gti` (`local_graph_id`,`graph_template_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores the actual graph item data.';

CREATE TABLE `graph_tree` (
  `id` smallint(5) unsigned NOT NULL auto_increment,
  `enabled` char(2) default 'on',
  `locked` tinyint(3) unsigned default '0',
  `locked_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `sort_type` tinyint(3) unsigned NOT NULL default '1',
  `name` varchar(255) NOT NULL default '',
  `sequence` int(10) unsigned default '1',
  `user_id` int(10) unsigned default '1',
  `last_modified` timestamp NOT NULL default '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned default '1',
  PRIMARY KEY (`id`),
  KEY `sequence` (`sequence`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `graph_tree_items` (
  id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  parent bigint(20) unsigned default NULL,
  position int(10) unsigned default NULL,
  graph_tree_id smallint(5) unsigned NOT NULL default '0',
  local_graph_id int(10) unsigned NOT NULL default '0',
  title varchar(255) default NULL,
  host_id mediumint(8) unsigned NOT NULL default '0',
  site_id int unsigned default '0',
  host_grouping_type tinyint(3) unsigned NOT NULL default '1',
  sort_children_type tinyint(3) unsigned NOT NULL default '0',
  graph_regex varchar(60) default '',
  host_regex varchar(60) default '',
  PRIMARY KEY (`id`),
  KEY `graph_tree_id` (`graph_tree_id`),
  KEY `host_id` (`host_id`),
  KEY `site_id` (`site_id`),
  KEY `local_graph_id` (`local_graph_id`),
  KEY `parent_position`(`parent`, `position`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  poller_id int(10) unsigned NOT NULL default '1',
  site_id int(10) unsigned NOT NULL default '1',
  host_template_id mediumint(8) unsigned NOT NULL default '0',
  description varchar(150) NOT NULL default '',
  hostname varchar(100) default NULL,
  location varchar(40) default NULL,
  notes text,
  external_id varchar(40) default NULL,
  snmp_options tinyint(3) unsigned NOT NULL default '0',
  snmp_community varchar(100) default NULL,
  snmp_version tinyint(3) unsigned NOT NULL default '1',
  snmp_username varchar(50) default NULL,
  snmp_password varchar(50) default NULL,
  snmp_auth_protocol char(6) default '',
  snmp_priv_passphrase varchar(200) default '',
  snmp_priv_protocol char(7) default '',
  snmp_context varchar(64) default '',
  snmp_engine_id varchar(64) default '',
  snmp_port mediumint(8) unsigned NOT NULL default '161',
  snmp_timeout mediumint(8) unsigned NOT NULL default '500',
  snmp_retries tinyint(3) unsigned NOT NULL default '3',
  snmp_sysDescr varchar(300) NOT NULL default '',
  snmp_sysObjectID varchar(128) NOT NULL default '',
  snmp_sysUpTimeInstance bigint(20) unsigned NOT NULL default '0',
  snmp_sysContact varchar(300) NOT NULL default '',
  snmp_sysName varchar(300) NOT NULL default '',
  snmp_sysLocation varchar(300) NOT NULL default '',
  availability_method smallint(5) unsigned NOT NULL default '1',
  ping_method smallint(5) unsigned default '0',
  ping_port int(10) unsigned default '0',
  ping_timeout int(10) unsigned default '500',
  ping_retries int(10) unsigned default '2',
  max_oids int(10) unsigned default '10',
  bulk_walk_size int(11) default '-1',
  device_threads tinyint(3) unsigned NOT NULL default '1',
  deleted char(2) NOT NULL default '',
  disabled char(2) NOT NULL default '',
  graphs int(10) unsigned NOT NULL default '0',
  data_sources int(10) unsigned NOT NULL default '0',
  status tinyint(3) unsigned NOT NULL default '0',
  status_event_count mediumint(8) unsigned NOT NULL default '0',
  status_fail_date timestamp NOT NULL default '0000-00-00 00:00:00',
  status_rec_date timestamp NOT NULL default '0000-00-00 00:00:00',
  status_options_date timestamp NOT NULL default '0000-00-00 00:00:00',
  status_last_error varchar(255) default '',
  min_time decimal(10,5) default '9.99999',
  max_time decimal(10,5) default '0.00000',
  cur_time decimal(10,5) default '0.00000',
  avg_time decimal(10,5) default '0.00000',
  polling_time DOUBLE default '0',
  current_errors int(10) unsigned NOT NULL default '0',
  total_polls int(10) unsigned default '0',
  failed_polls int(10) unsigned default '0',
  availability decimal(8,5) NOT NULL default '100.00000',
  last_updated timestamp default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created timestamp default CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY poller_id_disabled (poller_id, disabled),
  KEY host_template_id (host_template_id),
  KEY external_id (external_id),
  KEY disabled (disabled),
  KEY status (status),
  KEY current_errors (current_errors),
  KEY site_id_location (site_id, location),
  KEY hostname (hostname),
  KEY poller_id_last_updated (poller_id, last_updated)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_errors` (
  `host_id` mediumint(8) unsigned NOT NULL default 0,
  `poller_id` int(10) unsigned NOT NULL default 1,
  `errors` mediumint(8) unsigned NOT NULL default 0,
  `local_data_ids` text default NULL,
  PRIMARY KEY (`host_id`),
  KEY `poller_id` (`poller_id`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='Holds Device Error buffer for Spine';

CREATE TABLE `host_graph` (
  host_id mediumint(8) unsigned NOT NULL default '0',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (host_id,graph_template_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_snmp_cache` (
  host_id mediumint(8) unsigned NOT NULL default '0',
  snmp_query_id mediumint(8) unsigned NOT NULL default '0',
  field_name varchar(50) NOT NULL default '',
  field_value varchar(512) default NULL,
  snmp_index varchar(255) NOT NULL default '',
  oid TEXT NOT NULL,
  present tinyint(3) unsigned NOT NULL default '1',
  last_updated timestamp default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (host_id, snmp_query_id, field_name, snmp_index),
  KEY host_id (host_id, field_name),
  KEY snmp_index (snmp_index),
  KEY field_name (field_name),
  KEY field_value (field_value),
  KEY snmp_query_id (snmp_query_id),
  KEY last_updated (last_updated),
  KEY present (present)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_snmp_query` (
  host_id mediumint(8) unsigned NOT NULL default '0',
  snmp_query_id mediumint(8) unsigned NOT NULL default '0',
  sort_field varchar(50) NOT NULL default '',
  title_format varchar(50) NOT NULL default '',
  reindex_method tinyint(3) unsigned NOT NULL default '0',
  reindex_last_runtime timestamp NOT NULL default current_timestamp(), 
  reindex_last_duration double unsigned NOT NULL default '0',
  PRIMARY KEY (host_id,snmp_query_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_value_cache` (
  host_id mediumint(8) unsigned NOT NULL default '0',
  dimension varchar(40) NOT NULL default '',
  value varchar(8192) NOT NULL default '',
  time_to_live int(11) NOT NULL default '-1',
  last_updated TIMESTAMP default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (host_id, dimension)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_template` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `version` varchar(20) NOT NULL default '',
  `class` varchar(40) NOT NULL default '',
  `tags` varchar(128) NOT NULL default '',
  `author` varchar(40) NOT NULL default '',
  `email` varchar(60) NOT NULL default '',
  `homepage` varchar(128) NOT NULL default '',
  `copyright` varchar(40) NOT NULL default '',
  `installation` varchar(1024) NOT NULL default '',
  `devices` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `name` (`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_template_archive` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `host_template_id` mediumint(8) unsigned NOT NULL default '0',
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `version` varchar(20) NOT NULL default '',
  `class` varchar(40) NOT NULL default '',
  `tags` varchar(128) NOT NULL default '',
  `author` varchar(40) NOT NULL default '',
  `email` varchar(60) NOT NULL default '',
  `homepage` varchar(128) NOT NULL default '',
  `copyright` varchar(40) NOT NULL default '',
  `installation` varchar(1024) NOT NULL default '',
  `archive_note` varchar(256) NOT NULL default '',
  `archive_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `archive_md5sum` varchar(32) NOT NULL default '',
  `archive` longblob,
  PRIMARY KEY (id),
  KEY `host_template_id` (`host_template_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_template_graph` (
  host_template_id mediumint(8) unsigned NOT NULL default '0',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (host_template_id,graph_template_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `host_template_snmp_query` (
  host_template_id mediumint(8) unsigned NOT NULL default '0',
  snmp_query_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (host_template_id, snmp_query_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `package_public_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `md5sum` varchar(32) NOT NULL default '',
  `author` varchar(40) NOT NULL default '',
  `homepage` varchar(128) NOT NULL default '',
  `email_address` varchar(60) NOT NULL default '',
  `public_key` varchar(1024) default '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `md5sum` (`md5sum`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='Hold Trusted Package Public Keys';

CREATE TABLE `package_repositories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL default '',
  `enabled` char(2) NOT NULL default 'on',
  `default` char(2) NOT NULL default '',
  `repo_type` tinyint(3) unsigned NOT NULL default 0,
  `repo_location` varchar(128) NOT NULL default '',
  `repo_branch` varchar(20) NOT NULL default '',
  `repo_api_key` varchar(100) NOT NULL default '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `location_branch` (`repo_location`,`repo_branch`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='Holds Repository Locations that hold Packages';

CREATE TABLE `plugin_archive` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `plugin` varchar(32) NOT NULL default '',
  `description` varchar(64) NOT NULL default '',
  `author` varchar(64) NOT NULL default '',
  `webpage` varchar(255) NOT NULL default '',
  `user_id` int(10) unsigned NOT NULL default 0,
  `version` varchar(10) NOT NULL default '',
  `requires` varchar(128) default '',
  `compat` varchar(20) NOT NULL default '',
  `dir_md5sum` varchar(32) NOT NULL default '',
  `last_updated` timestamp NULL default NULL,
  `archive_note` varchar(256) NOT NULL default '',
  `archive` longblob default NULL,
  PRIMARY KEY (`id`),
  KEY `directory` (`plugin`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `plugin_available` (
  `plugin` varchar(32) NOT NULL default '',
  `description` varchar(128) NOT NULL default '',
  `author` varchar(40) NOT NULL default '',
  `webpage` varchar(128) NOT NULL default '',
  `tag_name` varchar(20) NOT NULL default '',
  `published_at` timestamp NULL default NULL,
  `compat` varchar(20) NOT NULL default '',
  `requires` varchar(128) NOT NULL default '',
  `body` blob default NULL,
  `info` blob default NULL,
  `readme` blob default NULL,
  `changelog` blob default NULL,
  `archive` longblob default NULL,
  `last_updated` timestamp NULL default current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`plugin`,`tag_name`)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

CREATE TABLE `plugin_config` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `directory` varchar(32) NOT NULL default '',
  `name` varchar(64) NOT NULL default '',
  `status` tinyint(3) unsigned NOT NULL default '0',
  `author` varchar(64) NOT NULL default '',
  `webpage` varchar(255) NOT NULL default '',
  `version` varchar(10) NOT NULL default '',
  `last_updated` timestamp NOT NULL default CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `directory` (`directory`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `plugin_hooks` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `name` varchar(32) NOT NULL default '',
  `hook` varchar(64) NOT NULL default '',
  `file` varchar(255) NOT NULL default '',
  `function` varchar(128) NOT NULL default '',
  `status` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `hook` (`hook`),
  KEY `status` (`status`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `plugin_realms` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `plugin` varchar(32) NOT NULL default '',
  `file` text NOT NULL,
  `display` varchar(64) NOT NULL default '',
  PRIMARY KEY (`id`),
  KEY `plugin` (`plugin`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `plugin_db_changes` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `plugin` varchar(16) NOT NULL default '',
  `table` varchar(64) NOT NULL default '',
  `column` varchar(64) NOT NULL,
  `method` varchar(16) NOT NULL default '',
  PRIMARY KEY (`id`),
  KEY `plugin` (`plugin`),
  KEY `method` (`method`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `disabled` char(2) default '',
  `name` varchar(30) default NULL,
  `notes` varchar(1024) default '',
  `status` int(10) unsigned NOT NULL default '0',
  `log_level` int(10) NOT NULL default '-1',
  `timezone` varchar(40) default '',
  `hostname` varchar(100) NOT NULL default '',
  `dbdefault` varchar(20) NOT NULL default '',
  `dbhost` varchar(64) NOT NULL default '',
  `dbuser` varchar(20) NOT NULL default '',
  `dbpass` varchar(64) NOT NULL default '',
  `dbport` int(10) unsigned default '3306',
  `dbretries` int(10) unsigned default '2',
  `dbssl` char(3) default '',
  `dbsslkey` varchar(255) default NULL,
  `dbsslcert` varchar(255) default NULL,
  `dbsslca` varchar(255) default NULL,
  `dbsslcapath` varchar(255) default NULL,
  `dbsslverifyservercert` char(3) default 'on',
  `total_time` double default '0',
  `max_time` double default NULL,
  `min_time` double default NULL,
  `avg_time` double default NULL,
  `total_polls` int(10) unsigned default '0',
  `processes` int(10) unsigned default '2',
  `threads` int(10) unsigned default '2',
  `sync_interval` int(10) unsigned default '7200',
  `devices` int(10) unsigned NOT NULL default '0',
  `snmp` mediumint(8) unsigned default '0',
  `script` mediumint(8) unsigned default '0',
  `server` mediumint(8) unsigned default '0',
  `last_update` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_status` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_sync` timestamp NOT NULL default '0000-00-00 00:00:00',
  `requires_sync` char(2) default '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `disabled` (`disabled`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Pollers for Cacti';

CREATE TABLE `poller_command` (
  poller_id smallint(5) unsigned NOT NULL default '1',
  time timestamp NOT NULL default '0000-00-00 00:00:00',
  action tinyint(3) unsigned NOT NULL default '0',
  command varchar(191) NOT NULL default '',
  last_updated timestamp default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (poller_id, action, command),
  KEY poller_id_last_updated (poller_id, last_updated)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_data_template_field_mappings` (
  `data_template_id` int(10) unsigned NOT NULL default '0',
  `data_name` varchar(40) NOT NULL default '',
  `data_source_names` varchar(125) NOT NULL default '',
  `last_updated` timestamp NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`data_template_id`, `data_name`, `data_source_names`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Tracks mapping of Data Templates to their Data Source Names';

CREATE TABLE `poller_item` (
  `local_data_id` int(10) unsigned NOT NULL default '0',
  `poller_id` int(10) unsigned NOT NULL default '1',
  `host_id` mediumint(8) unsigned NOT NULL default '0',
  `action` tinyint(3) unsigned NOT NULL default '1',
  `present` tinyint(3) unsigned NOT NULL default '1',
  `last_updated` timestamp default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `hostname` varchar(100) NOT NULL default '',
  `snmp_community` varchar(100) NOT NULL default '',
  `snmp_version` tinyint(3) unsigned NOT NULL default '0',
  `snmp_username` varchar(50) NOT NULL default '',
  `snmp_password` varchar(50) NOT NULL default '',
  `snmp_auth_protocol` char(6) NOT NULL default '',
  `snmp_priv_passphrase` varchar(200) NOT NULL default '',
  `snmp_priv_protocol` char(7) NOT NULL default '',
  `snmp_context` varchar(64) default '',
  `snmp_engine_id` varchar(64) default '',
  `snmp_port` mediumint(8) unsigned NOT NULL default '161',
  `snmp_timeout` mediumint(8) unsigned NOT NULL default '0',
  `snmp_retries` tinyint(3) unsigned NOT NULL default '3',
  `rrd_name` varchar(19) NOT NULL default '',
  `rrd_path` varchar(255) NOT NULL default '',
  `rrd_num` tinyint(3) unsigned NOT NULL default '0',
  `rrd_step` mediumint(8) NOT NULL default '300',
  `rrd_next_step` mediumint(8) NOT NULL default '0',
  `arg1` TEXT,
  `arg2` varchar(255) default NULL,
  `arg3` varchar(255) default NULL,
  PRIMARY KEY (`local_data_id`,`rrd_name`),
  KEY `host_id` (`host_id`),
  KEY `action` (`action`),
  KEY `present` (`present`),
  KEY `poller_id_host_id` (`poller_id`,`host_id`),
  KEY `poller_id_rrd_next_step` (`poller_id`,`rrd_next_step`),
  KEY `poller_id_action` (`poller_id`,`action`),
  KEY `poller_id_last_updated` (`poller_id`, `last_updated`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_output` (
  local_data_id int(10) unsigned NOT NULL default '0',
  rrd_name varchar(19) NOT NULL default '',
  time timestamp NOT NULL default '0000-00-00 00:00:00',
  output varchar(512) NOT NULL default '',
  PRIMARY KEY (local_data_id, rrd_name, time) /*!50060 USING BTREE */
) ENGINE=MEMORY;

CREATE TABLE `poller_output_boost` (
  `local_data_id` int(10) unsigned NOT NULL default '0',
  `rrd_name` varchar(19) NOT NULL default '',
  `time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `output` varchar(512) NOT NULL,
  `last_updated` timestamp NOT NULL default current_timestamp,
  PRIMARY KEY USING BTREE (`local_data_id`, `time`, `rrd_name`),
  KEY `last_updated` (`last_updated`),
  KEY `time` (`time`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_output_boost_local_data_ids` (
  `local_data_id` int(10) unsigned NOT NULL default 0,
  `process_handler` int(10) unsigned default 0,
  PRIMARY KEY USING BTREE (`local_data_id`),
  KEY `process_handler` USING BTREE (`process_handler`)
) ENGINE=MEMORY;

CREATE TABLE `poller_output_boost_processes` (
  `sock_int_value` bigint(20) unsigned NOT NULL auto_increment,
  `run_id` char(32) NOT NULL default '',
  `child_id` int(10) unsigned NOT NULL default 0,
  `status` varchar(255) default NULL,
  PRIMARY KEY (`sock_int_value`),
  UNIQUE KEY `run_child` (`run_id`,`child_id`)
) ENGINE=MEMORY;

CREATE TABLE `poller_output_realtime` (
  local_data_id int(10) unsigned NOT NULL default '0',
  rrd_name varchar(19) NOT NULL default '',
  `time` timestamp NOT NULL default '0000-00-00 00:00:00',
  output text NOT NULL,
  poller_id varchar(256) NOT NULL default '1',
  PRIMARY KEY (local_data_id, rrd_name, time, poller_id),
  KEY poller_id (poller_id(191)),
  KEY `time` (`time`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_reindex` (
  host_id mediumint(8) unsigned NOT NULL default '0',
  data_query_id mediumint(8) unsigned NOT NULL default '0',
  action tinyint(3) unsigned NOT NULL default '0',
  present tinyint(3) unsigned NOT NULL default '1',
  op char(1) NOT NULL default '',
  assert_value varchar(100) NOT NULL default '',
  arg1 varchar(255) NOT NULL default '',
  PRIMARY KEY (host_id, data_query_id, arg1(187)),
  KEY present (present)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_resource_cache` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `resource_type` varchar(20) default NULL,
  `md5sum` varchar(32) default NULL,
  `path` varchar(191) default NULL,
  `update_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `contents` longblob,
  `attributes` INT unsigned default '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `path` (`path`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Caches all scripts, resources files, and plugins';

CREATE TABLE `poller_time` (
  id bigint(20) unsigned NOT NULL auto_increment,
  pid int(10) unsigned NOT NULL default '0',
  poller_id int(10) unsigned NOT NULL default '1',
  start_time timestamp NOT NULL default '0000-00-00 00:00:00',
  end_time timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY `poller_id_end_time` (`poller_id`, `end_time`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `poller_time_stats` (
  id bigint(20) unsigned NOT NULL auto_increment,
  poller_id int(10) unsigned NOT NULL default '1',
  total_time double default NULL,
  `time` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY (id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `processes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL default 0,
  `tasktype` varchar(20) NOT NULL default '',
  `taskname` varchar(40) NOT NULL default '',
  `taskid` int(10) unsigned NOT NULL default 0,
  `timeout` int(10) unsigned default 300,
  `started` timestamp NOT NULL default current_timestamp(),
  `last_update` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY (`pid`,`tasktype`,`taskname`,`taskid`),
  KEY `tasktype` (`tasktype`),
  KEY `id` (`id`)
) ENGINE=MEMORY COMMENT='Stores Process Status for Cacti Background Processes';

CREATE TABLE `process_locks` (
  `key_id` varchar(64) NOT NULL,
  `key_token` varchar(44) NOT NULL,
  `key_expiration` int(10) unsigned NOT NULL,
  PRIMARY KEY (`key_id`)
) ENGINE=InnoDB COMMENT='Serializes Cacti Process Registry Mutations';

CREATE TABLE `reports` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` mediumint(8) unsigned NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `enabled` char(2) default '',
  `sched_type` int(10) unsigned NOT NULL default '0',
  `run_limit` int(10) unsigned default '0',
  `start_at` varchar(20) default NULL,
  `next_start` timestamp NOT NULL default '0000-00-00 00:00:00',
  `recur_every` int(10) unsigned default '1',
  `day_of_week` varchar(45) default NULL,
  `month` varchar(45) default NULL,
  `day_of_month` varchar(45) default NULL,
  `monthly_week` varchar(45) default NULL,
  `monthly_day` varchar(45) default NULL,
  `last_runtime` double NOT NULL default '0',
  `last_started` timestamp NOT NULL default '0000-00-00 00:00:00',
  `last_status` varchar(128) NOT NULL default '',
  `cformat` char(2) NOT NULL default '',
  `format_file` varchar(255) NOT NULL default '',
  `font_size` smallint(2) unsigned NOT NULL default '0',
  `alignment` smallint(2) unsigned NOT NULL default '0',
  `graph_linked` char(2) NOT NULL default '',
  `subject` varchar(64) NOT NULL default '',
  `from_name` varchar(40) NOT NULL,
  `from_email` text NOT NULL,
  `email` text NOT NULL,
  `bcc` text NOT NULL,
  `notify_list` int(10) unsigned NOT NULL default '0',
  `attachment_type` smallint(2) unsigned NOT NULL default '1',
  `graph_height` smallint(2) unsigned NOT NULL default '0',
  `graph_width` smallint(2) unsigned NOT NULL default '0',
  `graph_columns` smallint(2) unsigned NOT NULL default '0',
  `thumbnails` char(2) NOT NULL default '',
  PRIMARY KEY (`id`),
  KEY `next_start` (`next_start`),
  KEY `last_started` (`last_started`))
  ENGINE=InnoDB
  ROW_FORMAT=Dynamic
  COMMENT='Cacti Reporting Reports';

CREATE TABLE `reports_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` int(10) unsigned NOT NULL default '0',
  `item_type` tinyint(3) unsigned NOT NULL default '1',
  `tree_id` int(10) unsigned NOT NULL default '0',
  `branch_id` int(10) unsigned NOT NULL default '0',
  `tree_cascade` char(2) NOT NULL default '',
  `graph_name_regexp` varchar(128) NOT NULL default '',
  `site_id` int(11) NOT NULL default '-1',
  `host_template_id` int(11) NOT NULL default '-1',
  `host_id` int(11) NOT NULL default '-1',
  `graph_template_id` int(11) NOT NULL default '-1',
  `local_graph_id` int(10) unsigned NOT NULL default '0',
  `timespan` int(10) unsigned NOT NULL default '0',
  `align` tinyint(3) unsigned NOT NULL default '1',
  `item_text` text NOT NULL,
  `font_size` smallint(2) unsigned NOT NULL default '10',
  `sequence` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `report_id` (`report_id`))
  ENGINE=InnoDB
  ROW_FORMAT=Dynamic
  COMMENT='Cacti Reporting Items';

CREATE TABLE `reports_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL default '',
  `source` varchar(20) NOT NULL default '',
  `source_id` int(10) unsigned NOT NULL default 0,
  `report_output_type` varchar(5) NOT NULL default '',
  `report_raw_data` longblob default NULL,
  `report_raw_output` longblob default NULL,
  `report_txt_output` longblob default NULL,
  `report_html_output` longblob default NULL,
  `report_attachments` longblob default NULL,
  `notification` blob NOT NULL default '',
  `send_type` int(10) unsigned NOT NULL default 0,
  `send_time` timestamp NOT NULL default current_timestamp(),
  `run_time` double NOT NULL default 0,
  `sent_by` varchar(20) NOT NULL default '',
  `sent_id` int(11) NOT NULL default -1,
  PRIMARY KEY (`id`),
  KEY `source` (`source`),
  KEY `source_id` (`source_id`)
) ENGINE=InnoDB COMMENT='Holds All Cacti Report Output';

CREATE TABLE `reports_queued` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL default '',
  `source` varchar(20) NOT NULL default '',
  `source_id` int(10) unsigned NOT NULL default 0,
  `status` varchar(10) NOT NULL default 'pending',
  `scheduled_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `start_time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `run_command` varchar(512) NOT NULL default '',
  `run_timeout` int(11) NOT NULL default 60,
  `notification` blob NOT NULL default '',
  `request_type` int(10) unsigned NOT NULL default 0,
  `requested_by` varchar(20) NOT NULL default '',
  `requested_id` int(11) NOT NULL default -1,
  PRIMARY KEY (`id`),
  KEY `source` (`source`),
  KEY `source_id` (`source_id`)
) ENGINE=InnoDB COMMENT='Holds Scheduled Reports';

CREATE TABLE `settings` (
  name varchar(255) NOT NULL default '',
  value varchar(4096) NOT NULL default '',
  PRIMARY KEY (name)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `settings_user` (
  user_id smallint(8) unsigned NOT NULL default '0',
  name varchar(255) NOT NULL default '',
  value varchar(4096) NOT NULL default '',
  PRIMARY KEY (user_id, name)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `settings_user_group` (
  group_id smallint(8) unsigned NOT NULL default '0',
  name varchar(50) NOT NULL default '',
  value varchar(2048) NOT NULL default '',
  PRIMARY KEY (group_id, name)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores the Default User Group Graph Settings';

CREATE TABLE `settings_tree` (
  user_id mediumint(8) unsigned NOT NULL default '0',
  graph_tree_item_id int(10) unsigned NOT NULL default '0',
  status tinyint(4) NOT NULL default '0',
  PRIMARY KEY (user_id, graph_tree_item_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `snmp_query` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `xml_path` varchar(255) NOT NULL default '',
  `name` varchar(100) NOT NULL default '',
  `description` varchar(255) default NULL,
  `graph_template_id` mediumint(8) unsigned NOT NULL default '0',
  `data_input_id` mediumint(8) unsigned NOT NULL default '0',
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  `last_updated` timestamp default CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY name (name)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `snmp_query_graph` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  snmp_query_id mediumint(8) unsigned NOT NULL default '0',
  name varchar(100) NOT NULL default '',
  graph_template_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `graph_template_id_name` (`graph_template_id`, `name`),
  KEY `snmp_query_id_name` (`snmp_query_id`, `name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `snmp_query_graph_rrd` (
  snmp_query_graph_id mediumint(8) unsigned NOT NULL default '0',
  data_template_id mediumint(8) unsigned NOT NULL default '0',
  data_template_rrd_id int(10) unsigned NOT NULL default '0',
  snmp_field_name varchar(50) NOT NULL default '0',
  PRIMARY KEY (snmp_query_graph_id,data_template_id,data_template_rrd_id),
  KEY data_template_rrd_id (data_template_rrd_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `snmp_query_graph_rrd_sv` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  snmp_query_graph_id mediumint(8) unsigned NOT NULL default '0',
  data_template_id mediumint(8) unsigned NOT NULL default '0',
  sequence mediumint(8) unsigned NOT NULL default '0',
  field_name varchar(100) NOT NULL default '',
  text varchar(255) NOT NULL default '',
  PRIMARY KEY (id),
  KEY snmp_query_graph_id (snmp_query_graph_id),
  KEY data_template_id (data_template_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `snmp_query_graph_sv` (
  id mediumint(8) unsigned NOT NULL auto_increment,
  hash varchar(32) NOT NULL default '',
  snmp_query_graph_id mediumint(8) unsigned NOT NULL default '0',
  sequence mediumint(8) unsigned NOT NULL default '0',
  field_name varchar(100) NOT NULL default '',
  text varchar(255) NOT NULL default '',
  PRIMARY KEY (id),
  KEY snmp_query_graph_id (snmp_query_graph_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `user_auth` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `username` varchar(50) NOT NULL default '0',
  `password` varchar(256) NOT NULL default '',
  `realm` mediumint(8) NOT NULL default '0',
  `full_name` varchar(100) default '0',
  `email_address` varchar(128) NULL,
  `must_change_password` char(2) default NULL,
  `password_change` char(2) default 'on',
  `show_tree` char(2) default 'on',
  `show_list` char(2) default 'on',
  `show_preview` char(2) NOT NULL default 'on',
  `graph_settings` char(2) default NULL,
  `login_opts` tinyint(3) unsigned NOT NULL default '1',
  `policy_graphs` tinyint(3) unsigned NOT NULL default '1',
  `policy_trees` tinyint(3) unsigned NOT NULL default '1',
  `policy_hosts` tinyint(3) unsigned NOT NULL default '1',
  `policy_graph_templates` tinyint(3) unsigned NOT NULL default '1',
  `enabled` char(2) NOT NULL default 'on',
  `lastchange` int(11) NOT NULL default '-1',
  `lastlogin` int(11) NOT NULL default '-1',
  `password_history` varchar(4096) NOT NULL default '-1',
  `locked` varchar(3) NOT NULL default '',
  `failed_attempts` int(5) NOT NULL default '0',
  `lastfail` int(10) unsigned NOT NULL default '0',
  `reset_perms` int(10) unsigned NOT NULL default '0',
  `tfa_enabled` char(3) NOT NULL default '',
  `tfa_secret` char(50) NOT NULL default '',
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `realm` (`realm`),
  KEY `enabled` (`enabled`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `user_auth_cache` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL default '0',
  `hostname` varchar(100) NOT NULL default '',
  `last_update` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `token` varchar(191) NOT NULL default '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokenkey` (`token`),
  KEY `hostname` (`hostname`),
  KEY `user_id` (`user_id`),
  KEY `last_update` (`last_update`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Caches Remember Me Details';

CREATE TABLE `user_auth_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL default '',
  `graph_settings` varchar(2) default NULL,
  `login_opts` tinyint(3) unsigned NOT NULL default '1',
  `show_tree` varchar(2) default 'on',
  `show_list` varchar(2) default 'on',
  `show_preview` varchar(2) NOT NULL default 'on',
  `policy_graphs` tinyint(3) unsigned NOT NULL default '1',
  `policy_trees` tinyint(3) unsigned NOT NULL default '1',
  `policy_hosts` tinyint(3) unsigned NOT NULL default '1',
  `policy_graph_templates` tinyint(3) unsigned NOT NULL default '1',
  `enabled` char(2) NOT NULL default 'on',
  `auto_assignments` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table that Contains User Groups';

CREATE TABLE `user_auth_group_members` (
  `group_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`user_id`),
  KEY `realm_id` (`user_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table that Contains User Group Members';

CREATE TABLE `user_auth_group_perms` (
  `group_id` mediumint(8) unsigned NOT NULL default '0',
  `item_id` mediumint(8) unsigned NOT NULL default '0',
  `type` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY (`group_id`,`item_id`,`type`),
  KEY `group_id` (`group_id`,`type`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table that Contains User Group Permissions';

CREATE TABLE `user_auth_reset_hashes` (
  `user_id` int(10) unsigned NOT NULL default '0',
  `hash` varchar(100) NOT NULL default '',
  `expiry` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY (`user_id`,`expiry`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table that Contains User Password Reset Hashes';

CREATE TABLE `user_auth_group_realm` (
  `group_id` int(10) unsigned NOT NULL,
  `realm_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`group_id`,`realm_id`),
  KEY `realm_id` (`realm_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table that Contains User Group Realm Permissions';

CREATE TABLE `user_auth_perms` (
  user_id mediumint(8) unsigned NOT NULL default '0',
  item_id mediumint(8) unsigned NOT NULL default '0',
  type tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY (user_id,item_id,type),
  KEY user_id (user_id,type)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `user_auth_realm` (
  realm_id mediumint(8) unsigned NOT NULL default '0',
  user_id mediumint(8) unsigned NOT NULL default '0',
  PRIMARY KEY (realm_id,user_id),
  KEY user_id (user_id)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `user_auth_row_cache` (
  `user_id` mediumint(8) NOT NULL default '0',
  `class` varchar(20) NOT NULL default '',
  `hash` varchar(32) NOT NULL default '0',
  `total_rows` int(10) unsigned NOT NULL default '0',
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`class`,`hash`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `user_layouts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL default '0',
  `page` varchar(64) NOT NULL default '',
  `name` varchar(128) NOT NULL default '',
  `data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `page` (`page`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Stores user defined and published filter layouts';

CREATE TABLE `user_log` (
  `username` varchar(50) NOT NULL default '0',
  `user_id` mediumint(8) NOT NULL default '0',
  `time` timestamp NOT NULL default '0000-00-00 00:00:00',
  `result` tinyint(3) unsigned NOT NULL default '0',
  `ip` varchar(40) NOT NULL default '',
  PRIMARY KEY (`username`,`user_id`,`time`),
  KEY user_id (`user_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;

CREATE TABLE `login_providers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL default '',
  `description` varchar(255) NOT NULL default '',
  `type` tinyint(3) unsigned NOT NULL default '1',
  `button_label` varchar(50) NOT NULL default '',
  `enabled` char(2) NOT NULL default 'on',
  `debug` char(2) NOT NULL default '',
  `is_default` tinyint(3) unsigned NOT NULL default '0',
  `allow_auth_cookies` char(2) NOT NULL default 'on',
  `user_id` int(10) unsigned NOT NULL default '0',
  `parameters` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Table to Hold Login Providers (LDAP/AD/SAML2/OpenID)';

CREATE TABLE `sessions` (
  `id` varchar(32) NOT NULL,
  `remote_addr` varchar(25) NOT NULL default '',
  `access` int(10) unsigned default NULL,
  `data` mediumblob,
  `user_id` int(10) unsigned NOT NULL default '0',
  `user_agent` varchar(128) NOT NULL default '',
  `start_time` timestamp NOT NULL default current_timestamp,
  `transactions` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `access` (`access`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Used for Database based Session Storage';

CREATE TABLE `sites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL default '',
  `disabled` char(2) NOT NULL default '',
  `address1` varchar(100) default '',
  `address2` varchar(100) default '',
  `city` varchar(50) default '',
  `state` varchar(20) default NULL,
  `postal_code` varchar(20) default '',
  `country` varchar(30) default '',
  `region` varchar(30) default '',
  `timezone` varchar(40) default '',
  `latitude` decimal(13,10) NOT NULL default '0.0000000000',
  `longitude` decimal(13,10) NOT NULL default '0.0000000000',
  `zoom` tinyint(3) unsigned default NULL,
  `alternate_id` varchar(30) default '',
  `notes` varchar(1024),
  `devices` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `city` (`city`),
  KEY `state` (`state`),
  KEY `postal_code` (`postal_code`),
  KEY `country` (`country`),
  KEY `alternate_id` (`alternate_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Contains information about customer sites';

CREATE TABLE `snmpagent_cache` (
  `oid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `mib` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL default '',
  `otype` varchar(50) NOT NULL default '',
  `kind` varchar(50) NOT NULL default '',
  `max-access` varchar(50) NOT NULL default 'not-accessible',
  `value` varchar(255) NOT NULL default '',
  `description` varchar(5000) NOT NULL default '',
  PRIMARY KEY (`oid`),
  KEY `name` (`name`),
  KEY `mib_name` (`mib`,`name`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='SNMP MIB CACHE';

CREATE TABLE `snmpagent_mibs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL default '',
  `file` varchar(255) NOT NULL default '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Registered MIB files';

CREATE TABLE `snmpagent_cache_notifications` (
  `name` varchar(50) NOT NULL,
  `mib` varchar(50) NOT NULL,
  `attribute` varchar(50) NOT NULL,
  `sequence_id` smallint(6) NOT NULL,
  PRIMARY KEY (`name`,`mib`,`attribute`,`sequence_id`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Notifications and related attributes';

CREATE TABLE `snmpagent_cache_textual_conventions` (
  `name` varchar(50) NOT NULL,
  `mib` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL default '',
  `description` varchar(5000) NOT NULL default '',
  PRIMARY KEY (`name`,`mib`,`type`),
  KEY `mib` (`mib`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='Textual conventions';

CREATE TABLE `snmpagent_managers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `disabled` char(2) default NULL,
  `max_log_size` tinyint(4) NOT NULL,
  `snmp_version` tinyint(3) unsigned NOT NULL default '1',
  `snmp_community` varchar(100) NOT NULL default '',
  `snmp_username` varchar(50) NOT NULL,
  `snmp_password` varchar(50) NOT NULL,
  `snmp_auth_protocol` char(6) NOT NULL,
  `snmp_priv_passphrase` varchar(200) NOT NULL,
  `snmp_priv_protocol` char(7) NOT NULL,
  `snmp_engine_id` varchar(64) default NULL,
  `snmp_port` mediumint(8) unsigned NOT NULL default '161',
  `snmp_message_type` tinyint(4) NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `hostname` (`hostname`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='snmp notification receivers';

CREATE TABLE `snmpagent_managers_notifications` (
  `manager_id` int(10) unsigned NOT NULL,
  `notification` varchar(50) NOT NULL,
  `mib` varchar(50) NOT NULL,
  PRIMARY KEY(`manager_id`,`notification`,`mib`),
  KEY `mib` (`mib`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='snmp notifications to receivers';

CREATE TABLE `snmpagent_notifications_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `time` int(24) NOT NULL,
  `severity` tinyint(4) NOT NULL,
  `manager_id` int(10) unsigned NOT NULL,
  `notification` varchar(190) NOT NULL,
  `mib` varchar(50) NOT NULL,
  `varbinds` varchar(5000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `time` (`time`),
  KEY `severity` (`severity`),
  KEY `manager_id_notification` (`manager_id`,`notification`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='logs snmp notifications to receivers';

CREATE TABLE `vdef` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `graphs` int(10) unsigned NOT NULL default '0',
  `templates` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (id),
  KEY `hash` (`hash`),
  KEY `name` (`name`(171))
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='vdef';

CREATE TABLE `vdef_items` (
  `id` mediumint(8) unsigned NOT NULL auto_increment,
  `hash` varchar(32) NOT NULL default '',
  `vdef_id` mediumint(8) unsigned NOT NULL default '0',
  `sequence` mediumint(8) unsigned NOT NULL default '0',
  `type` tinyint(3) unsigned NOT NULL default '0',
  `value` varchar(150) NOT NULL default '',
  PRIMARY KEY (id),
  KEY `vdef_id_sequence` (`vdef_id`,`sequence`)
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='vdef items';

CREATE TABLE `rrdcheck` (
  `local_data_id` mediumint(8) unsigned NOT NULL,
  `test_date` timestamp NOT NULL default '0000-00-00 00:00:00',
  `message` varchar(250) default ''
) ENGINE=InnoDB ROW_FORMAT=Dynamic COMMENT='rrdcheck';

CREATE TABLE `version` (
  cacti char(30) default '',
  PRIMARY KEY (cacti)
) ENGINE=InnoDB ROW_FORMAT=Dynamic;
