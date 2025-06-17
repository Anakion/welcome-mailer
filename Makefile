MIGRATION_DIR=alembic/versions

up:
	docker compose up --build web_services db_services

create_migration:
	docker compose build migrate; \
	docker compose run --rm migrate alembic revision --autogenerate --rev-id "$(REV)" -m "$(NAME)"

upgrade:
	docker compose build migrate; \
	docker compose run --rm migrate alembic upgrade head

migrate:
	@read -p "Enter migration name (e.g. add_table): " name; \
	last=$$(ls alembic/versions | grep -Eo '^[0-9]+' | sort -n | tail -1); \
	rev=$$(printf "%04d" $$( [ -z "$$last" ] && echo 1 || echo $$(($$last + 1)) )); \
	make create_migration REV="$$rev" NAME="$$name"; \
	sudo chown $(USER):$(USER) -R alembic/versions; \

reset_db:
	docker compose exec db_services psql -U postgres -d postgres -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'

db_shell:
	docker compose exec -it db_services psql -h postgres_services_mailer -p 5432 -U postgres -d postgres

format:
	./format.sh
