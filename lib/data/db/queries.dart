const queries = [
  'CREATE DATABASE IF NOT EXISTS task_manager',
  'use task_manager',
  '''CREATE TABLE IF NOT EXISTS projects (
    id varchar(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)''',
  '''CREATE TABLE IF NOT EXISTS tasks (
    id varchar(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    project_id varchar(255) NOT NULL,
    time_in_millis BIGINT NULL DEFAULT NULL ,
    status VARCHAR(255) NOT NULL DEFAULT "PENDING",
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id)
)''',
  'SHOW COLUMNS FROM `tasks` LIKE "description"',
  'ALTER TABLE tasks ADD COLUMN description TEXT(6000) NULL',
  'ALTER TABLE projects ADD COLUMN active TINYINT DEFAULT 1',
];
