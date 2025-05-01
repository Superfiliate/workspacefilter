# Elixir/Phoenix Dev Container

This project includes a Development Container configuration to provide a consistent and isolated Elixir/Phoenix development environment without needing to install Elixir or its dependencies directly on your host machine.

## Prerequisites

* Orbstack
* VSCode-based editor (Cursor, Windsurf, ...)
  * Make sure the "Dev Containers" externsion is also installed.

## Getting Started

1.  Clone this repository (or ensure you have the `.devcontainer` folder in your project root).
2.  Open the project folder in VS Code or Cursor.
3.  When prompted, click on "Reopen in Container". Alternatively, open the Command Palette (`Cmd+Shift+P` or `Ctrl+Shift+P`) and select "Dev Containers: Reopen in Container".
4.  VS Code will build the container image (this might take a few minutes the first time) and start the development environment.

## Accessing the Phoenix Server

When you run your Phoenix server inside the container (typically with `mix phx.server`), it will be available on port 4000.

You can access it from your local machine's browser at:

[http://localhost:4000](http://localhost:4000)
