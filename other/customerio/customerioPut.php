<?php

/*
 * Customerio put new customer
 * This creates a new customer or updates a new one if id already exists
 *
 * needs api key, api url, site id
 *
 * runs with: php customerioPut.php <csvFile.csv>
 */

// turn off error reporting.
error_reporting(0);

// opening file
$fileHandle = fopen($argv[1], "r");

// somewhat global parameters that come from parameters.yml
$parsedParametersYml = yaml_parse_file('parameters.yml');

$API_KEY = $parsedParametersYml['parameters']['customer_io_api_key'];
$API_URL = $parsedParametersYml['parameters']['customer_io_api_url'];
$SITE_ID = $parsedParametersYml['parameters']['customer_io_site_id'];

// initializating vars
$headerAsArray = array();
$lineAsArray = array();
$request = null;

if ($fileHandle) {
    $i = 0;

    // iterates over file
    while (($line = fgets($fileHandle)) !== false) {
        if ($i == 0) {
            $headerAsArray = str_getcsv($line);
            $i++;
            continue; // skip first line because it's a header
        }
        $i++;

        $lineAsArray = str_getcsv($line, ",", "'", "\\");
        $customerIoArray = array_combine($headerAsArray, $lineAsArray);

        //
        $customerId = $customerIoArray['id'];
        unset($customerIoArray['id']);
        $data = $customerIoArray;

        makeCustomerIoCall($customerId, $data);
    }

    // closing file
    fclose($fileHandle);
} else {
    echo "error opening the file";
}

function makeCustomerIoCall($customerId, $data)
{
    global $API_KEY, $API_URL, $SITE_ID;

    // starting curl session
    $session = curl_init();
    curl_setopt($session, CURLOPT_URL, $API_URL.$customerId);
    curl_setopt($session, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    curl_setopt($session, CURLOPT_HTTPGET, 1);
    curl_setopt($session, CURLOPT_HEADER, false);
    curl_setopt($session, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($session, CURLOPT_CUSTOMREQUEST, 'PUT');
    curl_setopt($session, CURLOPT_VERBOSE, 0);
    curl_setopt($session, CURLOPT_POSTFIELDS, http_build_query($data));
    curl_setopt($session, CURLOPT_USERPWD, $SITE_ID . ":" . $API_KEY);

    if (ereg("^(https)", $request)) {
        curl_setopt($session, CURLOPT_SSL_VERIFYPEER, false);
    }

    $response = curl_exec($session);

    echo $customerId . ' done: ' . $response;

    curl_close($session);
}


/*
// aux query to get email, id, active_projects, first_name, last_name, created_at, signup_org

select email, id, active_projects, first_name, last_name, UNIX_TIMESTAMP(created_at) as created_at, signup_org
from
user u left join
(select poo.user_id as user_id, o.subdomain as signup_org
from
  (SELECT project_id, m.user_id, p.organization_id
  from membership m, project p
  where
  m.project_id=p.id and
  #user_id in ('d028fae0-20cc-11e6-9629-0ab24b97733e', '2e5e0e28-7890-11e3-949b-0ab24b97733e', '5cfdfdbf-77e8-11e3-949b-0ab24b97733e') and
  m.created_at=(select min(created_at) from membership where user_id=m.user_id)
  group by user_id) as poo,
  organization o
where poo.organization_id = o.id) usu
on u.id=usu.user_id
where
active_projects like '%startup%'
order by created_at desc
*/
