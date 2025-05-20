destroy:
	source creds && ./scripts/shutdown.sh
	tofu -chdir=proxmox destroy

init:
	tofu -chdir=proxmox init -upgrade

plan:
	tofu -chdir=proxmox plan

apply:
	tofu -chdir=proxmox apply -auto-approve

shutdown:
	source creds && ./scripts/shutdown.sh

remove:
	source creds && ./scripts/remove.sh

ssh:
	./scripts/clear-known-hosts.sh