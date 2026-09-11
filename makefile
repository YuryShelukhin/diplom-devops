# Makefile
SHELL := /bin/bash
TERRAFORM_DIR := terraform
BOOTSTRAP_DIR := $(TERRAFORM_DIR)/bootstrap
INFRA_DIR := $(TERRAFORM_DIR)/infrastructure

.PHONY: help bootstrap get-secrets init plan apply destroy clean


bootstrap: ## Создание bootstrap 
	@echo "=== Bootstrap ==="
	cd $(BOOTSTRAP_DIR) && terraform init && terraform apply -auto-approve

get-secrets: ## Получение секретов bootstrap
	@echo "=== Получение секретов ==="
	@cd $(BOOTSTRAP_DIR) && terraform output -raw access_key > /tmp/diploma_access_key
	@cd $(BOOTSTRAP_DIR) && terraform output -raw secret_key > /tmp/diploma_secret_key
	@echo "Секреты сохранены в /tmp/"

init: bootstrap get-secrets ## Инициализация основной инфраструктуры
	@echo "=== Инициализация ==="
	@cd $(INFRA_DIR) && terraform init \
		-backend-config="access_key=$$(cat /tmp/diploma_access_key)" \
		-backend-config="secret_key=$$(cat /tmp/diploma_secret_key)"

plan: init ## Показать план
	@cd $(INFRA_DIR) && terraform plan

apply: init ## Применить инфраструктуру
	@cd $(INFRA_DIR) && terraform apply

destroy-infra: ## Уничтожить только инфраструктуру (не bootstrap)
	@cd $(INFRA_DIR) && terraform destroy

destroy-all: ## Уничтожить ВСЁ включая bootstrap (осторожно!)
	@echo "$(RED)ВНИМАНИЕ: Это удалит бакет и SA!$(NC)"
	@read -p "Продолжить? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd $(INFRA_DIR) && terraform destroy -auto-approve; \
		cd $(BOOTSTRAP_DIR) && terraform destroy -auto-approve; \
	fi

clean: ## Очистить временные файлы
	rm -f /tmp/diploma_access_key /tmp/diploma_secret_key
	find . -name "*.terraform" -type d -exec rm -rf {} +
	find . -name "terraform.tfstate*" -delete

validate: ## Проверить конфигурацию
	@cd $(BOOTSTRAP_DIR) && terraform validate
	@cd $(INFRA_DIR) && terraform validate