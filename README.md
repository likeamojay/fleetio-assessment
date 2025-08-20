# Fleetio iOS Technical Assessment - James Lane

This repository contains my solution for the iOS technical assessment for Fleetio.

---

## To Run

Copy+Paste your Fleetio API key and Account Token values into the `Credentials.plist` file I added and they will be plugged into every REST API call.

## Features

- [x] Fetches and displays a list of vehicles in a Fleetio manager's account
- [x] List is searchable and supports paginated API
- [X] Has a Vehicle detail view that can be viewed when tapping on a vehicle from the list
- [X] Vehicle Detail view contains vehicle mileage data, driver indo, VIN, license plate, name, list of comments (also paginated list), and MapKit view of vehicle's last location
- [X] Manage API credentials in a property list file for easy swap-out

## Architectural Considerations
- [x] Implements **MVVM Architecture** for list views for separation of concerns, structured concurrency, and API response handling encapsulation
- [x] Uses SwiftUI child/component views for maintainability and avoiding repetitive UI logic
- [X] Vehicls list Uses a lazy-loading approach where pages are feteched either by user scrolling down to the bottom OR fetches all pages by user initiating a search in the search box

## Shortcuts taken for time's sake since instructions said not to spend more than 5 hours on this

- [x] Didn't impelement colors for every vehicle status enum. Just "Active" for green and then red for everything else. I still included the status label. I know the API response has a string property for the color but didn't want to spend too much time mapping them all.
- [x] Didn't implement PUT APIs to make vehicle fields updatable, but did every other enhancement
