<?php
/*
 * ChurchCRM configuration for Railway.
 * Every value comes from the service's environment variables; no secrets
 * are stored in this file.
 */
$sSERVERNAME = getenv('CHURCHCRM_DB_HOST') ?: '';
$dbPort = getenv('CHURCHCRM_DB_PORT') ?: '3306';
$sUSER = getenv('CHURCHCRM_DB_USER') ?: '';
$sPASSWORD = getenv('CHURCHCRM_DB_PASSWORD') ?: '';
$sDATABASE = getenv('CHURCHCRM_DB_NAME') ?: '';
$sRootPath = '';
$URL[0] = getenv('CHURCHCRM_URL') ?: 'http://localhost:8080/';

error_reporting(E_ERROR);

require_once dirname(__FILE__) . DIRECTORY_SEPARATOR . 'LoadConfigs.php';
