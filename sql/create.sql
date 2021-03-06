-- MySQL Script generated by MySQL Workbench
-- Fri Aug 26 02:45:05 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema crawler
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema crawler
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `crawler` DEFAULT CHARACTER SET utf8 ;
USE `crawler` ;

-- -----------------------------------------------------
-- Table `crawler`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NULL,
  `image` MEDIUMTEXT NULL,
  `deleted` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`sites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`sites` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NULL,
  `name` VARCHAR(256) NULL,
  `image` MEDIUMTEXT NULL,
  `url` MEDIUMTEXT NULL,
  `rss_type` INT NULL DEFAULT 2,
  `rss_url` MEDIUMTEXT NULL,
  `description` MEDIUMTEXT NULL,
  `last_update` DATETIME NULL,
  `deleted` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_sites_category_id_idx` (`category_id` ASC),
  CONSTRAINT `fk_sites_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `crawler`.`categories` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`articles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`articles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `site_id` INT NULL,
  `title` VARCHAR(256) NULL,
  `image` MEDIUMTEXT NULL,
  `url` MEDIUMTEXT NULL,
  `description` MEDIUMTEXT NULL,
  `post_date` DATETIME NULL,
  `deleted` INT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_articles_site_id_idx` (`site_id` ASC),
  CONSTRAINT `fk_articles_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `crawler`.`sites` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idfa` VARCHAR(256) NULL,
  `created` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`histories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`histories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article_id` INT NULL,
  `user_id` INT NULL,
  `date` DATETIME NULL,
  `action` INT NULL,
  `attrebute` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hisotries_article_id_idx` (`article_id` ASC),
  INDEX `fk_histories_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_histories_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `crawler`.`articles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_histories_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `crawler`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NULL,
  `color` VARCHAR(256) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `crawler`.`tag_article_relations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `crawler`.`tag_article_relations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tag_id` INT NULL,
  `article_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tag_article_relations_tag_id_idx` (`tag_id` ASC),
  INDEX `fk_tag_article_relations_article_id_idx` (`article_id` ASC),
  CONSTRAINT `fk_tag_article_relations_tag_id`
    FOREIGN KEY (`tag_id`)
    REFERENCES `crawler`.`tags` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tag_article_relations_article_id`
    FOREIGN KEY (`article_id`)
    REFERENCES `crawler`.`articles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
