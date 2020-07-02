# Let's Go

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Let's Go helps users plan outings and meetings with their friends. Afterwards, users can upload images to create memories of their trops and share them with their friends.  

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
* user can login
* user can search places and see yelp reviews
* user can see a list of popular places
* user can create and save a trip
* user can see details about their trip and who they've invited
* user can share trip and send invites to friends
* user can upload a photo to a trip memory
* user can see photos that other attendees have added to their trip
* user can see their profile page with past trips
* user can configure app options


**Optional Nice-to-have Stories**

* user can search and add other users
* user can see photos from other users' trips
* app recommends new places for users
* app recommends meeting times depending on who is invited
* user can add a comment to a photo or trip
* user can visit other user's profiles and see their past trips
* app provides budget planning for trip
* user gets notifications before their trips
* user can see if their friends. has accepted their invite
* user can create a trip message chat with users who are invited to the trip


### 2. Screen Archetypes

* Login Screen
   * User can log in 
* Registration Screen
   * User can create a new account
* Trip Stream (could later be a map view of locations of previous trips)
   * User can see their previous trips
* Creation
   * User can create and save a new trip
* Trip Detail
    * User can see details about their trip and who they've invited
    * user can share trip and send invites to friends
    * user can upload a photo to a trip memory
    * user can see photos that other attendees have added to their trip
* Search
    * User can search places for trips
    * User can see a list of popular places
* Profile
    * User can see their profile and a list of their trips
* settings
    * user can configure app options

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Trip Stream
* Creation
* Profile
* Search

**Flow Navigation** (Screen to Screen)

* Login Screen
    * Trip Stream
* Registration Screen
   * Trip Stream
* Trip Stream
   * Trip Detail
* Profile
    * Trip Detail
    * Settings

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
