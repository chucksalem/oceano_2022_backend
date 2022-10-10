# Oceano Rentals Backend

Rails API for Oceano. Interfaces with the Escapia SOAP API for data.

### Setup & Usage

To run in development simply run `docker-compose up --build`
as long as you have docker and docker-compose installed. It is
necessary to create a .env file as well, that contains the username
and password needed to access the escapia API.

In order for the application to load the pages, the following command has
to be executed in the resulting docker container:

```bash
bundle exec rake oceano:cache:properties
```

### Processes

Run an individual process with:
```bash
bundle exec foreman start <PROCESS_NAME>
```
Reset property cache with:
```bash
bundle exec rake oceano:cache:properties
```

### Deploys

There are scripts that can be used to deploy the application into the server of
your choice. In order to use them, connect to the server via ssh, and go into the 
folder containing the code. Once there, run either `sh build-staging.sh` or `sh build-production.sh`
to deploy either develop or master respectively. The scripts bothe leave a terminal running
inside the container, where one can run the property cache reset process to load the units.

## Endpoints

The API contains the following endpoints:

### Recommended properties

Returns a list with the recommended properties to display in the homepage

### Search properties

Allows the users to search the available properties, in a date range and for a certain amount of guests. If no dates or amount of guests are specified, all units are returned. Additional filters can be applied, on the property's location, the minimum and maximum prices, the amenities available or the property's type.

### Get Filters

Returns the available values for the locations, types and amenities filters. This is used so new values can be reflected without having to make changes in the frontend.

### Get property

Returns a detailed view of a property, including pictures and videos. If a date range and the amount of guests is specified, the stay details are included.

### Get Stay

Gets the prices, taxes and fees for a certain property during a specific date range.

### Get Calendar Availability

Gets the available and unavailable dates for a specific property, on a specific date range. Returns a string with the following possible values: ‘A’ ( Available ), ‘U’ ( Unavailable ), ‘I’ ( Available for checkin only ), ‘O’ ( Available for checkout only ).

As this is an interface for the the Escapia SOAP API for data, more information about it can be found [here](https://eweb.escapia.com/distribution/api/evrn-api-documentation#UnitCalendarAvail).
