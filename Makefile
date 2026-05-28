.PHONY: run check lint bootstrap

run:
	ansible-playbook site.yml

check:
	ansible-playbook site.yml --check --diff

lint:
	ansible-lint

bootstrap:
	./bootstrap.sh
