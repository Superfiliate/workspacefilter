setup:
	mix local.hex --force;
	mix local.rebar --force;
	mix setup;

dev:
	mix phx.server
