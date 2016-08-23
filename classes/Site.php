<?php

require_once dirname(__FILE__) .'/../config/config.php';

class Site extends Model{

  public static $_table = 'sites';    # table name (異なる場合オーバライドできる)
  public static $_id_column = 'id';     # primary key (同様)

  # Userモデル関連付け
  public function articles(){
    return $this->has_many('Article', 'site'); # もし外部キーがcompany_idでなくcompanyの場合でも
  }

  public function category(){
  	return $this->belongs_to('Category');
  }


}