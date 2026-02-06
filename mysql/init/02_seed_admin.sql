INSERT IGNORE INTO users
(name, nickname, email, password, role, is_deleted, token_version, email_verified)
VALUES
('Admin','admin','admin@gmail.com',
'$2a$10$/PtZgbJQn4nO1kW/6NFge.ufC6jj7HLdM7B1wXnaNP07Tg7uoppfK',
'ADMIN',0,0,0);
