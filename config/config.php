<?php
require_once dirname(__FILE__) .'/../lib/idiorm.php';
require_once dirname(__FILE__) .'/../lib/paris.php';

# データベース設定
ORM::configure('mysql:;host=localhost;dbname=crawler');
ORM::configure('driver_options', array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'));
ORM::configure('username', 'crawler');
ORM::configure('password', 'welcome1');
