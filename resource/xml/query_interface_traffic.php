<?php

# include some cacti files for ease of use
include(dirname(__FILE__) . '/../include/cli_check.php');
include(dirname(__FILE__) . '/../lib/snmp.php');

# define all OIDs we need for further processing
$oids = array(
	'index'         => '.1.3.6.1.2.1.2.2.1.1',
	'ifstatus'      => '.1.3.6.1.2.1.2.2.1.8',
	'ifdescription' => '.1.3.6.1.2.1.2.2.1.2',
	'ifname'        => '.1.3.6.1.2.1.31.1.1.1.1',
	'ifalias'       => '.1.3.6.1.2.1.31.1.1.1.18',
	'iftype'        => '.1.3.6.1.2.1.2.2.1.3',
	'ifspeed'       => '.1.3.6.1.2.1.2.2.1.5',
	'ifHWaddress'   => '.1.3.6.1.2.1.2.2.1.6',
	'ifInOctets'    => '.1.3.6.1.2.1.2.2.1.10',
	'ifOutOctets'   => '.1.3.6.1.2.1.2.2.1.16',
);

$xml_delimiter  =  '!';

# all required input parms
$hostname               = $_SERVER['argv'][1];
$snmp_community         = $_SERVER['argv'][2];
$snmp_version           = $_SERVER['argv'][3];
$snmp_port              = $_SERVER['argv'][4];
$snmp_timeout           = $_SERVER['argv'][5];
$max_oids               = $_SERVER['argv'][6];

# required for SNMP V3
$snmp_auth_username     = $_SERVER['argv'][7];
$snmp_auth_password     = $_SERVER['argv'][8];
$snmp_auth_protocol     = $_SERVER['argv'][9];
$snmp_priv_passphrase   = $_SERVER['argv'][10];
$snmp_priv_protocol     = $_SERVER['argv'][11];
$snmp_context           = $_SERVER['argv'][12];
$cmd                    = $_SERVER['argv'][13];
if (isset($_SERVER['argv'][14])) {
	$query_field = $_SERVER['argv'][14]; 
};

if (isset($_SERVER['argv'][15])) {
	$query_index = $_SERVER['argv'][15]; 
};

# -------------------------------------------------------------------------
# main code starts here
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# script MUST respond to index queries
#       the command for this is defined within the XML file as
#       <arg_index>index</arg_index>
#       you may replace the string 'index' both in the XML and here
# -------------------------------------------------------------------------
#       php -q <script> <parms> index
# will list all indices of the target values
# e.g. in case of interfaces
#      it has to respond with the list of interface indices
# -------------------------------------------------------------------------
if ($cmd == 'index') {
	# retrieve all indices from target
	$return_arr = reindex(cacti_snmp_walk($hostname, $snmp_community,
	$oids['index'], $snmp_version, $snmp_auth_username,
	$snmp_auth_password, $snmp_auth_protocol, $snmp_priv_passphrase, $snmp_priv_protocol,
	$snmp_context, $snmp_port, $snmp_timeout, $snmp_retries, $max_oids, SNMP_POLLER));

	# and print each index as a separate line
	for ($i=0;($i<sizeof($return_arr));$i++) {
		print $return_arr[$i] . "\n";
	}
} 

# -------------------------------------------------------------------------
# script MUST respond to query requests
#       the command for this is defined within the XML file as
#       <arg_query>query</arg_query>
#       you may replace the string 'query' both in the XML and here
# -------------------------------------------------------------------------
#       php -q <script> <parms> query <function>
# where <function> is a parameter that tells this script,
# which target value should be retrieved
# e.g. in case of interfaces, <function> = ifdescription
#      it has to respond with the list of
#      interface indices along with the description of the interface
# -------------------------------------------------------------------------
elseif ($cmd == 'query' && isset($query_field)) {
	$arr_index = reindex(cacti_snmp_walk($hostname, $snmp_community,
		$oids['index'], $snmp_version, $snmp_auth_username,
		$snmp_auth_password, $snmp_auth_protocol, $snmp_priv_passphrase, $snmp_priv_protocol,
		$snmp_context, $snmp_port, $snmp_timeout, $snmp_retries, $max_oids, SNMP_POLLER));
		$arr = reindex(cacti_snmp_walk($hostname, $snmp_community,
		$oids[$query_field], $snmp_version, $snmp_auth_username,
		$snmp_auth_password, $snmp_auth_protocol, $snmp_priv_passphrase, $snmp_priv_protocol,
		$snmp_context, $snmp_port, $snmp_timeout, $snmp_retries, $max_oids, SNMP_POLLER));

	for ($i=0;($i<sizeof($arr_index));$i++) {
		print $arr_index[$i] . $xml_delimiter . $arr[$i] . "\n";
	}
} 

# -------------------------------------------------------------------------
# script MUST respond to get requests
#       the command for this is defined within the XML file as
#       <arg_get>get</arg_get>
#       you may replace the string 'get' both in the XML and here
# -------------------------------------------------------------------------
#       php -q <script> <parms> get <function> <index>
# where <function> is a parameter that tells this script,
# which target value should be retrieved
# and   <index>    is the index that should be queried
# e.g. in case of interfaces, <function> = ifdescription
#                             <index>    = 1
#      it has to respond with
#      the description of the interface for interface #1
# -------------------------------------------------------------------------
elseif ($cmd == 'get' && isset($query_field) && isset($query_index)) {
	print (cacti_snmp_get($hostname, $snmp_community,
		$oids[$query_field] . ".$query_index", $snmp_version, $snmp_auth_username,
		$snmp_auth_password, $snmp_auth_protocol, $snmp_priv_passphrase, $snmp_priv_protocol,
		$snmp_context, $snmp_port, $snmp_timeout, $snmp_retries, $max_oids, SNMP_POLLER));
} else {
	print "Invalid use of script query, required parameters:\n\n";
	print "    <hostname> <cmd>\n";
}

function reindex($arr) {
	$return_arr = array();

	for ($i=0;($i<sizeof($arr));$i++) {
		$return_arr[$i] = $arr[$i]['value'];
	}

	return $return_arr;
}

