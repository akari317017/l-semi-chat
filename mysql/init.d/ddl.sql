-- define database
DROP DATABASE `ls_chat`;
CREATE DATABASE IF NOT EXISTS `ls_chat`;

-- define tables
CREATE TABLE IF NOT EXISTS `ls_chat`.`users`(
    `id` VARCHAR(36) PRIMARY KEY COMMENT'id',
    `user_id` VARCHAR(36) UNIQUE NOT NULL COMMENT 'ユーザid',
    `name` VARCHAR(64) NOT NULL COMMENT '名前',
    `image` VARCHAR(128) NOT NULL COMMENT '画像',
    `profile` VARCHAR(150) COMMENT 'プロフィール',
    `is_admin` TINYINT NOT NULL DEFAULT 0 COMMENT '権威',
    `mail` VARCHAR(254) NOT NULL UNIQUE COMMENT 'メールアドレス',
    `login_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'ログイン日時',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `password` VARCHAR(70) NOT NULL COMMENT 'パスワード'
)
COMMENT = 'ユーザ';

CREATE TABLE IF NOT EXISTS `ls_chat`.`messages`(
    `id` VARCHAR(36) NOT NULL COMMENT 'id',
    `message` VARCHAR(150) NOT NULL COMMENT '投稿本文',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `grade` INTEGER UNSIGNED NOT NULL DEFAULT 0 COMMENT '発言のグレード' ,
    `user_id` VARCHAR(64) NOT NULL COMMENT 'ユーザID',
    `thread_id` VARCHAR(36) NOT NULL COMMENT 'スレッドID',
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_messages_users`
        FOREIGN KEY (`user_id`)
        REFERENCES `ls_chat`.`users` (`user_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_messages_threads`
        FOREIGN KEY (`thread_id`)
        REFERENCES `ls_chat`.`threads`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
COMMENT = '投稿メッセージ';

CREATE TABLE IF NOT EXISTS `ls_chat`.`threads`(
    `id` VARCHAR(36) PRIMARY KEY NOT NULL COMMENT 'id',
    `name` VARCHAR(32) NOT NULL COMMENT '名前',
    `description` VARCHAR(150) COMMENT '説明',
    `limit_users` INTEGER COMMENT '上限人数',
    `user_id` VARCHAR(64) NOT NULL COMMENT '管理者',-- F
    `is_public` TINYINT NOT NULL DEFAULT 0 COMMENT '範囲',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '更新日時',
    CONSTRAINT `fk_threads_users`
        FOREIGN KEY (`user_id`)
        REFERENCES `ls_chat`.`users`(`user_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
COMMENT ='スレッド';

CREATE TABLE IF NOT EXISTS `ls_chat`.`tags`(
    `id` VARCHAR(36) NOT NULL PRIMARY KEY COMMENT 'id',
    `tag` VARCHAR(25) NOT NULL COMMENT 'タグ名',
    `category_id` VARCHAR(36) NOT NULL COMMENT '大枠',
    CONSTRAINT `fk_tags_categories`
        FOREIGN KEY (`category_id`)
        REFERENCES `ls_chat`.`categories`(`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    UNIQUE(`tag`,`category_id`)
)
COMMENT 'タグ';

CREATE TABLE IF NOT EXISTS `ls_chat`.`categories`(
    `id` VARCHAR(36) PRIMARY KEY NOT NULL COMMENT'id',
    `category` VARCHAR(8) NOT NULL COMMENT '大枠名'
)
COMMENT'カテゴリ';


-- archives
CREATE TABLE IF NOT EXISTS `ls_chat`.`archives`(
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'id',
    `path` VARCHAR(128) NOT NULL COMMENT 'ファイルのpath',
    `is_public` TINYINT NOT NULL DEFAULT 1 COMMENT '公開範囲',
    `password` VARCHAR(70) NOT NULL COMMENT 'パスワード' ,
    `thread_id` VARCHAR(36) NOT NULL COMMENT 'スレッドID',
    CONSTRAINT `fk_archives_threads`
        FOREIGN KEY (`thread_id`)
        REFERENCES `ls_chat`.`threads` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
COMMENT = 'アーカイブ';

-- evaluations(master)
CREATE TABLE IF NOT EXISTS `ls_chat`.`evalutions`(
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'id',
    `item` VARCHAR(10) NOT NULL UNIQUE COMMENT '評価文'
)
COMMENT = '評価';

-- evaluation_scores
CREATE TABLE IF NOT EXISTS `ls_chat`.`evaluation_scores`(
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'id',
    `evaluation_id` VARCHAR(36) NOT NULL COMMENT '評価ID',
    `users_id` VARCHAR(36) NOT NULL COMMENT 'ユーザID',
    `score` INTEGER NOT NULL DEFAULT 0 COMMENT 'スコア' ,
    CONSTRAINT `fk_evaluation_scores_evaluations`
        FOREIGN KEY (`evaluation_id`)
        REFERENCES `ls_chat`.`evaluations` (`evaluation_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_evaluation_scores_users`
        FOREIGN KEY (`user_id`)
        REFERENCES `ls_chat`.`users` (`id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `unique_user_evaluation`
        UNIQUE (`user_id`, `evaluation_id`)
)
COMMENT = '評価スコア';

-- users_followers
CREATE TABLE IF NOT EXISTS `ls_chat`.`users_followers`(
    `id` VARCHAR(36) PRIMARY KEY COMMENT 'id',
    `users_id` VARCHAR(36) NOT NULL COMMENT 'ユーザID',
    `followed_user_id` VARCHAR(36) NOT NULL COMMENT 'フォローユーザーID',
    CONSTRAINT `fk_users_followers_users`
        FOREIGN KEY (`user_id`)
        REFERENCES `ls_chat`.`users` (`user_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_users_followers_followed_users`
        FOREIGN KEY (`followed_user_id`)
        REFERENCES `ls_chat`.`followed_users` (`followed_user_id`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `unique_user_followed`
        UNIQUE (`user_id`, `followed_id`)
)
COMMENT = 'フォロワー';
	
