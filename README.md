# Fleetio iOS Technical Assessment - James Lane

This repository contains my solution for the iOS technical assessment for Fleetio.

---

## To Run

Copy+Paste your Fleetio API key and Account Token values into the `Credentials.plist` file I added and they will be plugged into every REST API call.

- [x] Fetches and displays a list of vehicles in a Fleetio manager's account
- [x] List is searchable and supports paginated API
- [X] Has a Vehicle detail view that can be viewed when tapping on a vehicle from the list
- [X] Vehicle Detail view contains vehicle mileage data, driver indo, VIN, license plate, name, list of comments (also paginated list), and MapKit view of vehicle's last location

## Architectural Considerations
- [x] Implements **MVVM Architecture** for list views for separation of concerns, structured concurrency, and API response handling encapsulation
- [x] Uses SwiftUI child/component views for maintainability and avoiding repetitive UI logic
- [X] Vehicls list Uses a lazy-loading approach where pages are feteched either by user scrolling down to the bottom OR fetches all pages by user initiating a search in the search box
