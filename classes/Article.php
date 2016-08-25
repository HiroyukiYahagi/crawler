<?php

require_once dirname(__FILE__) .'/../config/config.php';

class Article extends Model{

  public static $_table = 'articles';    # table name (異なる場合オーバライドできる)
  public static $_id_column = 'id';     # primary key (同様)

  public function category(){
  	return $this->belongs_to('Site');
  }

}