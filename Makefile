# **************************************************************************** #
#                              INCEPTION MAKEFILE                              #
# **************************************************************************** #

NAME	= inception
COMPOSE	= docker-compose -f ./srcs/docker-compose.yml
VOLUME_PATH = /home/mmaltas-/data

# **************************** REGLAS PRINCIPALES **************************** #

.PHONY: fclean status down start stop bonus build all

all: create-folders
	@echo "🛠️  Construyendo los servicios ..."
	$(COMPOSE) up --build -d

build:
	@$(COMPOSE) up --build -d

stop:
	@echo "🛑 Deteniendo contenedores..."
	$(COMPOSE) stop

start:
	@echo "▶️ Levantando contenedores..."
	$(COMPOSE) start

down:
	@echo "🧨 Deteniendo y eliminan contenedores..."
	$(COMPOSE) down

status:
	@echo "🐳 Mostrando contenedores..."
	@docker ps

fclean: down
	@echo "🧹 Limpiando imágenes, volúmenes y carpetas de datos..."
	docker system prune -af --volumes
	sudo rm -rf $(VOLUME_PATH)

re: fclean all

# **************************** VOLÚMENES **************************** #

create-folders:
	@echo "📁 Creando carpetas de volumen en $(VOLUME_PATH)"
	@sudo mkdir -p $(VOLUME_PATH)/wordpress
	@sudo mkdir -p $(VOLUME_PATH)/mariadb

