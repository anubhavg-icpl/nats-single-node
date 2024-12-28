.PHONY: setup test deploy clean

# Variables
ANSIBLE_PLAYBOOK = ansible-playbook
INVENTORY = tests/inventory
TEST_PLAYBOOK = tests/test.yaml
SSH_KEY = ~/.ssh/id_rsa
TARGET_HOST = 192.168.122.66

setup: ## Setup SSH key authentication
	@echo "Setting up SSH key authentication..."
	@if [ ! -f $(SSH_KEY) ]; then \
		ssh-keygen -t rsa -b 4096 -f $(SSH_KEY) -N ""; \
	fi
	@ssh-copy-id -i $(SSH_KEY) mranv@$(TARGET_HOST)

test: ## Run the test playbook
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(TEST_PLAYBOOK) --diff

verify: ## Test the connection
	ansible all -i $(INVENTORY) -m ping

clean: ## Clean up deployed services
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(TEST_PLAYBOOK) --tags "cleanup" --diff

help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

default: help