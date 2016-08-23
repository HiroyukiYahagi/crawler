<?php

require_once dirname(__FILE__) .'/../config/config.php';

class Category extends Model{

  public static $_table = 'categories';    # table name (異なる場合オーバライドできる)
  public static $_id_column = 'id';     # primary key (同様)


  public function sites(){
    return $this->has_many('Site', 'category'); 
  }

}