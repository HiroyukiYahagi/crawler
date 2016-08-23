<?php


require_once dirname(__FILE__) .'/lib/Feed.php';
require_once dirname(__FILE__) .'/classes/Article.php';
require_once dirname(__FILE__) .'/classes/Category.php';
require_once dirname(__FILE__) .'/classes/Site.php';

try {
	$companies = Model::factory('Category')->find_many();
} catch (Exception $e) {
	echo $e->getMessage();
	exit;
}


