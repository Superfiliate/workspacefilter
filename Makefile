setup:
	curl -L https://fly.io/install.sh | sh;
	echo 'export PATH="$$HOME/.fly/bin:$$PATH"' >> $$HOME/.bashrc;
	mix local.hex --force;
	mix local.rebar --force;
	mix setup;

dev:
	mix phx.server
