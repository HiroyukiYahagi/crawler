<?php


require_once dirname(__FILE__) .'/lib/Feed.php';
require_once dirname(__FILE__) .'/lib/OpenGraph.php';
require_once dirname(__FILE__) .'/classes/Article.php';
require_once dirname(__FILE__) .'/classes/Category.php';
require_once dirname(__FILE__) .'/classes/Site.php';

function logging($string){
	echo $string."<br />\n";
}

function getDateString(){
	return date("Y-m-d H:i:s");
}

function compareDate($x, $y){
	if($x == NULL || $y == NULL){
		return true;
	}
	if($x > $y){
		return true; 
	}else{
		return false;
	}
}
function getRelatedImage($url){
	$graph = OpenGraph::fetch($url);
	return $graph->image;
}


Class Crawler{

	public static function main(){
		logging("start main");
		$sites = self::getSites();
		foreach ($sites as $key => $site) {
			logging("start crawle site:".$site->id);
			self::crawleSite($site);
			$site->save();
		}
		logging("end main");
	}

	private static function getSites(){
		try {
			$sites = Model::factory('Site')->filter('alives')->find_many();
		} catch (Exception $e) {
			echo $e->getMessage();
			exit;
		}
		return $sites;
	}

	private static function crawleSite($site){
		logging("crawle:". $site->rss_url);
		switch ($site->rss_type){
			case '1':
				$xml =self::getRss($site->rss_url);
				foreach ($xml->item as $key => $item) {
					$article = self::patchArticleRSS1($site->id, $item);
					if(compareDate($article->post_date, $site->last_update)){
						$article->save();
					}
				}
				break;
			case '3':
				$feed = new Feed;
				$rss = $feed->loadAtom($site->rss_url);
				foreach ($rss->item as $key => $item) {
					$article = self::patchArticleAtom($site->id, $item);
					if(compareDate($article->post_date, $site->last_update)){
						$article->save();
					}
				}
				break;
			case '2':
			default:
				$feed = new Feed;
				$rss = $feed->load($site->rss_url);
				foreach ($rss->item as $key => $item) {
					$article = self::patchArticleRSS2($site->id, $item);
					if(compareDate($article->post_date, $site->last_update)){
						$article->save();
					}
				}
				break;
		}

		logging("end crawle");
		$site->last_update = getDateString();
		logging("end crawle");
	}

	private static function patchArticleAtom($siteId, $item){
		$article = Model::factory('Article')->create();

		$article->site_id = $siteId;
		$article->title = $item->title;
		// $article->image = $item->;
		$article->url = $item->link;
		$article->description = $item->description;
		$article->post_date = date( "Y-m-d H:i:s", strtotime($item->pubDate));
		$article->deleted = 0;
		$article->image = getRelatedImage($article->url);

		return $article;
	}

	private static function patchArticleRSS2($siteId, $item){
		$article = Model::factory('Article')->create();

		$article->site_id = $siteId;
		$article->title = $item->title;
		$article->url = $item->link;
		$article->description = $item->description;
		$article->post_date = date( "Y-m-d H:i:s", strtotime($item->pubDate));
		$article->deleted = 0;
		$article->image = getRelatedImage($article->url);

		return $article;
	}

	private static function patchArticleRSS1($siteId, $item){
		$article = Model::factory('Article')->create();

		$article->site_id = $siteId;
		$article->title = (string)$item->title;
		$article->url = (string)$item->link;
		$article->description = (string)$item['content'];
		$article->post_date = date( "Y-m-d H:i:s",strtotime($item['date']));
		$article->deleted = 0;
		$article->image = getRelatedImage($article->url);

		return $article;
	}

    private static function getRss($rss)
    {
        $xml = '';
        if ($rss) {
            $xml = simplexml_load_file($rss);
            if ($xml->item) {
                // RSS1.0
                foreach ($xml->item as $entry) {
                    $dc = $entry->children('http://purl.org/dc/elements/1.1/');

                    $date = $dc->date;
                    $entry['date'] = $date;
                    $content = $entry->children('http://purl.org/rss/1.0/modules/content/');
                    $contentStr = $content->encoded;
                    $entry['content'] = $contentStr;
                }
            }
        }
        return $xml;
    }

}

Crawler::main();
