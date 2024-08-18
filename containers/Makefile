### Network ###
setup_network:
	-docker network create software_tools_network

### Kafka ###
start-kafka: setup_network
	docker-compose -f docker-compose-kafka up --build --force-recreate

### Postgres ###
start-postgres: setup_network
	docker-compose -f docker-compose-postgres up --build --force-recreate

connect-postgres:
	docker exec -it software_tools_postgres psql -U postgres -W -p 5433 -h localhost -d software_tools

### Mongo ###
start-mongo: setup_network
	docker-compose -f docker-compose-mongo up --build --force-recreate

### Redis ###
start-redis: setup_network
	docker-compose -f docker-compose-redis up --build --force-recreate

### Grafana ###
start-grafana: setup_network
	docker-compose -f docker-compose-grafana up --build --force-recreate

### Jaeger ###
start-grafana: setup_network
	docker-compose -f docker-compose-jaeger up --build --force-recreate