Original App Design Project - README Template
===

# Let's Go

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Let's Go helps users plan outings and meetings with their friends. Afterwards, users can upload images to create memories of their trips and share them with their friends.  

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Productivity/Social
- **Mobile:** Uses location, maps, and camera. 
- **Story:** Allows user to plan and keep a timeline of memories of gatherings.
- **Market:** Anyone that enjoys going out and finds making plans with a group of people difficult, especially if they enjoy taking photos and making memories
- **Habit:** Anytime users have a meeting with a large group of people, they can use the app to help with planning. Users can also post anytime they take have a get together.
- **Scope:** V1 allows users to plan events and invite friends. After the event, user can upload pictures. V2 recommends places for new outings and keeps a record of photos uploaded by all attendees, so there is a shared photo album for each outing. V3 recommends meeting times depending on when everyone's schedule is free. Users can see public posts uploaded by other users at different places. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* user can create a new account
* user can login/logout
* user can search places (Google Maps or Yelp)
* user can create and save a trip
* user can see details about their trip and who they've invited
* user can share trip and send invites to friends 
* app recommends meeting times depending on who is invited(complex algorithm)
* user can take and upload a photo to a trip memory
* user can see a list of upcoming trips


**Optional Nice-to-have Stories**

* user can see photos that other attendees have added to their trip
* user can see their profile page with past trips
* user can see a list of popular places
* user see yelp reviews
* user can delete trips

**Extra Stretch**

* user can see if their friend has accepted their invite
* user can edit their profile
* user can search and add other users
* user gets notifications before their trips
* app recommends new places for users
* user can edit trips
* user can visit other user's profiles and see their past trips
* app provides budget planning for trip
* user can create a trip message chat with users who are invited to the trip


### 2. Screen Archetypes

* Login/Registration Screen
   * User can log in 
   * User can create a new account
* Trip Stream (could later be a map view of locations of previous trips)
   * User can see their upcoming trips
* Creation
   * User can create and save a new trip
* Trip Detail
    * User can see details about their trip and who they've invited
    * user can share trip and send invites to friends
    * user can take and upload a photo to a trip memory
    * app recommends meeting times depending on who is invited
* Search
    * User can search places for trips
* Profile
    * User can see their profile with past trips
    * user can edit their profile
    * User can log out

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Trip Stream
* Creation
* Profile
* Search

**Flow Navigation** (Screen to Screen)

* Login/Registration Screen
    * Trip Stream
* Trip Stream
   * Trip Detail
* Profile
    * Trip Detail

## Wireframes
[Sketched wireframes]
<img src="https://github.com/adriennehl/lets-go/blob/master/09A1F976-BD99-49F1-B8EC-0B1D70B2CFB7.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models

User
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId| String| unique id for the user post (default field)|
|profileImage|File| user profile image|
|username|String|username|
|password|String|password|
|name|String|user name|
|number of trips|number|number of trips|
|createdAt|DateTime|date when trip is created (default field)|
|updatedAt|DateTime|date when post is last update (default field)|
|trips|Array/Relation|list of trip Ids/pointers to trips the user is invited to|

Trip

| Property | Type | Description |
| -------- | -------- | -------- |
| objectId| String| unique id for the user post (default field)|
|author|Pointer to user| trip creator|
|invitees|Array/Relation|list of usernames/pointers to users who are invited|
|images|Array|list of trip images|
|description|String|trip description|
|title|String|trip title|
|location|String|address of trip location|
|startDate|DateTime|trip start date and time|
|endDate|DateTime|trip end date and time|
|createdAt|DateTime|date when trip is created (default field)|
|updatedAt|DateTime|date when post is last update (default field)|




### Networking
Register/Login
- Authenticate user
```objectivec=
[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
        }
    }];
}

```
- (POST) Create a new user
```objectivec=
 [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
                }];
                
            } else {
                NSLog(@"User registered successfully");
                // display view controller that needs to shown after successful signup
            }
        }];
```
Trip Stream
- (GET) Query all trips where user is invited
```objectivec=
PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query includeKey:@"author"];
    [query includeKey:@"invitees"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"invitees" equalTo:[PFUser currentUser]];
    [query whereKey:@"endDate" greaterThanOrEqualTo:[NSDate date]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (trips != nil) {
            self.trips = trips;
            [self.tripsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
```
Creation
- (Post) Create a new trip
```objectivec=
PFObject *trip = [PFObject objectWithClassName:@"Trip"];
// add trip fields

 [trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatMessageField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
```

Profile
- (GET) Query current user details

```objectivec=
self.user = [PFUser currentUser];
```
- (GET) Query current user's trips
```objectivec=
PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query includeKey:@"author"];
    [query includeKey:@"invitees"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"invitees" equalTo:[PFUser currentUser]];
    [query whereKey:@"endDate" lessThan:[NSDate date]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (trips != nil) {
            self.trips = trips;
            [self.tripsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
```


- [OPTIONAL: List endpoints if using existing API such as Yelp]

Yelp API
Base URL - https://api.yelp.com/v3/businesses/

|HTTP Verb|Endpoint|Description|
|--------|---------|--------|
|GET|search|businesses based on provided search criteria|
|GET|{id}|detailed business content|
|GET|{id}/reviews|up to 3 review excerpts|
|GET|/v3/categories/{alias}|detailed information about the Yelp category|


Foursquare API
Base URL - https://api.foursquare.com/v2/venues/
|HTTP Verb|Endpoint|Description|
|---------|---------|--------|
|GET|/trending|list of venues near the current location with the most people currently checked in|
|GET|/VENUE_ID/similar|list of venues similar to the specified venue|
|GET|/search?|search venues|

-(GET) Query locations near a city
```objectivec=
 [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
```
 -(GET) Query locations from search
```objectivec=
  NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
```
