//
//  APIUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "APIUtility.h"
#import "Key.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation APIUtility

// initialize Google maps SDK
+ (void)initializeMapsSDK {
    Key *key = [[Key alloc] init];
    [GMSServices provideAPIKey:key.key];
}

// get list of places from search query
+ (void)getPlaces:(NSString *)searchTerm withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion{
    Key *key = [[Key alloc] init];
       NSString *queryTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
       NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=%@&query=%@", key.key, queryTerm];
       NSURL *url = [NSURL URLWithString:urlString];
       NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completion];
       [task resume];
}

// get place details: opening hours, atmostphere, etc
+ (void)getPlaceDetails:(NSString *)placeId withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion{
    Key *key = [[Key alloc] init];
       NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=%@&place_id=%@&fields=opening_hours", key.key, placeId];
       NSURL *url = [NSURL URLWithString:urlString];
       NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completion];
       [task resume];
}

// get photo using photo reference
+ (void)getPhoto:(NSArray *)photos photoReference:(NSString *)photoReference withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completion {
    Key *key = [[Key alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxheight=185&photoreference=%@&key=%@", photoReference, key.key];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completion];
    [task resume];
}
@end
