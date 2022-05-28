-- Sebastian Clavijo
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `deng_nba_final` DEFAULT CHARACTER SET latin1 ;
USE `deng_nba_final` ;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`address` (
  `address_id` TINYINT(10) NOT NULL AUTO_INCREMENT, -- Always below 50 
  `address` VARCHAR(5) NOT NULL,
  `address_state` VARCHAR(45) NOT NULL,
  `address_city` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`address_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`arena` (
  `arena_id` TINYINT(10) NOT NULL AUTO_INCREMENT,  
  `address_id` TINYINT(10) NOT NULL,
  `capacity` VARCHAR(45) NOT NULL,
  `arena_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`arena_id`),
  CONSTRAINT `fk_arena_add`
	FOREIGN KEY (`address_id`)
    REFERENCES `deng_nba_final`.`address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_team` (
  `team_id` TINYINT(10) NOT NULL AUTO_INCREMENT, -- Always below 50 
  `team_abr` VARCHAR(5) NOT NULL,
  `team_mascot` VARCHAR(45) NOT NULL,
  `team_city` VARCHAR(45) NOT NULL,
  `arena_id`  TINYINT(10) NOT NULL,
  PRIMARY KEY (`team_id`),
  CONSTRAINT `fk_team_arena`
    FOREIGN KEY (`arena_id`)
    REFERENCES `deng_nba_final`.`arena` (`arena_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_season` (
  `season_id` TINYINT(10) NOT NULL AUTO_INCREMENT, 
  `season_name` VARCHAR(45) NOT NULL,
  `season_year_start` INT(5) NOT NULL,
  PRIMARY KEY (`season_id`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_season_attendance` (
  `season_id` TINYINT(10) NOT NULL AUTO_INCREMENT, 
  `team_id` TINYINT(10) NOT NULL,
  `total_attendance` INT(20) NOT NULL,
  `home_avg` INT(20) NOT NULL,
  `away_avg` INT(20) NOT NULL,
  PRIMARY KEY (`season_id`),
  CONSTRAINT `fk_season_ref`
    FOREIGN KEY (`season_id`)
    REFERENCES `deng_nba_final`.`nba_season` (`season_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_reference`
    FOREIGN KEY (`team_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_games` (
  `game_id` INT(10) NOT NULL AUTO_INCREMENT, -- Always below 50
  `season_id` TINYINT(10) NOT NULL ,
  `home_team_id` TINYINT(10) NOT NULL,
  `away_team_id` TINYINT(10) NOT NULL,
  `home_points` INT(10) NOT NULL,
  `away_points` INT(10) NOT NULL,
  `team_winner_id` TINYINT(10) NOT NULL,
  `game_date` DATE NOT NULL,
  `arena_id` TINYINT(10) NOT NULL,
  PRIMARY KEY (`game_id`),
  CONSTRAINT `fk_game_away_team_reference`
    FOREIGN KEY (`away_team_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_home_team_reference`
    FOREIGN KEY (`home_team_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_game_winner_reference`
    FOREIGN KEY (`team_winner_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_season_reference`
    FOREIGN KEY (`season_id`)
    REFERENCES `deng_nba_final`.`nba_season` (`season_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_game_location`
    FOREIGN KEY (`arena_id`)
    REFERENCES `deng_nba_final`.`arena` (`arena_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION  
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_team_stats` (
  `game_id` INT(10) NOT NULL AUTO_INCREMENT, -- Always below 50
  `team_id` TINYINT(10) NOT NULL,
  `q1_pts` INT(2) NOT NULL,
  `q2_pts` INT(2) NOT NULL,
  `q3_pts` INT(2) NOT NULL,
  `q4_pts` INT(2) NOT NULL,
  `ot1_pts` INT(2) NULL,
  `ot2_pts` INT(2) NULL,
  `ot3_pts` INT(2) NULL,
  `ot4_pts` INT(2) NULL,
  `ft` INT(2) NOT NULL,
  `ft_attempts` INT(2) NOT NULL,
  `off_rebouding` INT(2) NOT NULL,
  `def_rebounding` INT(2) NOT NULL,
  `assists` INT(2) NOT NULL,
  `steals` INT(2) NOT NULL,
  `turnovers` INT(2) NOT NULL,
  `blocks` INT(2) NOT NULL,
  `off_efficiency` INT(10) NOT NULL,
  `def_efficiency` INT(10) NOT NULL,  
  PRIMARY KEY (`game_id`,`team_id`),
  CONSTRAINT `fk_team_ref`
    FOREIGN KEY (`team_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_season_game_stats_ref`
    FOREIGN KEY (`game_id`)
    REFERENCES `deng_nba_final`.`nba_games` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_player` (
  `player_id` TINYINT(10) NOT NULL AUTO_INCREMENT,
  `player_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`player_id`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_player_team` (
  `player_id` TINYINT(10) NOT NULL,  
  `team_id` TINYINT(10) NOT NULL,
  `season_id` TINYINT(10) NOT NULL,
  PRIMARY KEY (`player_id`, `season_id`,`team_id`),
  CONSTRAINT `fk_player_team`
    FOREIGN KEY (`team_id`)
    REFERENCES `deng_nba_final`.`nba_team` (`team_id`),
    FOREIGN KEY (`player_id`)
    REFERENCES `deng_nba_final`.`nba_player` (`player_id`),
	FOREIGN KEY (`season_id`)
    REFERENCES `deng_nba_final`.`nba_season` (`season_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE TABLE IF NOT EXISTS `deng_nba_final`.`nba_player_stats` (
  `game_id` INT(10) NOT NULL AUTO_INCREMENT, -- Always below 50
  `player_id` TINYINT(10) NOT NULL,
  `pts` INT(2) NOT NULL,
  `ft` INT(2) NOT NULL,
  `ft_attempts` INT(2) NOT NULL,
  `off_rebouding` INT(2) NOT NULL,
  `def_rebounding` INT(2) NOT NULL,
  `assists` INT(2) NOT NULL,
  `steals` INT(2) NOT NULL,
  `turnovers` INT(2) NOT NULL,
  `blocks` INT(2) NOT NULL,
  `per` INT(10) NOT NULL,
  PRIMARY KEY (`player_id`,`game_id`),
  CONSTRAINT `fk_player_ref`
    FOREIGN KEY (`player_id`)
    REFERENCES `deng_nba_final`.`nba_player` (`player_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_game_ref`
    FOREIGN KEY (`game_id`)
    REFERENCES `deng_nba_final`.`nba_games` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


