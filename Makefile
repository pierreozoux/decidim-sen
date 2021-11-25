create_db:
	docker-compose exec app rake db:create

run_migrations:
	docker-compose exec app rake db:migrate

setup:
	@make create_db
	@make run_migrations