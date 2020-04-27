
### This page will list known issues per Cacti Version that have impact either on installation or  performance


## 1.2.11

1.) config.php has cookie domain uncommented causing impact to login

Fix: uncomment $cacti_cookie_domain = 'cacti.net';
Status - Fixed in 1.2.x branch still present in 1.2.11.zip
