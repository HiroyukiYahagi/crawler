<?php
require_once dirname(__FILE__) .'/../lib/idiorm.php';
require_once dirname(__FILE__) .'/../lib/paris.php';

# データベース設定
ORM::configure('mysql:dbname=crawler;host=localhost:3306;charset=utf8');
ORM::configure('username', 'mysql');
ORM::configure('password', 'welcome1');
