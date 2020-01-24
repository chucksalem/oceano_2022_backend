# Oceano

Rails application for Oceano. Interfaces with the Escapia SOAP API for data.

Staging Server: http://159.203.67.43

### Setup & Usage

```bash
bin/setup                  # Bundle and clean up
bundle exec foreman start  # Start the Rails server
open http://localhost:5000 # Open in web browser
```

or in development

if you checkout the `run_master_in_docker` branch you can just run
```
docker-comopse up
```
as long as you have docker and docker-compose installed.

It's a good idea to rebase master into the run_master_in_docker branch when master is updated.

### Processes

| Name | Description |
| ---  | ---         |
| `web` | Rails application. |

Run an indivual process with:
```bash
bundle exec foreman start <PROCESS_NAME>
```
Reset property cache with:
```bash
bundle exec rake oceano:cache:properties
```

Reset Forecast.io cache with:
```bash
bundle exec rake oceano:cache:weather
```

### Deploys
Deploy to Staging with:
```bash
bundle exec cap staging deploy
```
I like to use the docker setup from the run_master_in_docker branch, copy my
ssh keys into the rails docker container, so I don't have to remember the
password to the server's deploy user.
