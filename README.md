# Oceano

Rails application for Oceano. Interfaces with the Escapia SOAP API for data.

### Setup & Usage

```bash
bin/setup                  # Bundle and clean up
bundle exec foreman start  # Start the Rails server
open http://localhost:5000 # Open in web browser
```

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
