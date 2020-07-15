//
//  APIUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "APIUtility.h"
#import "Key.h"

@implementation APIUtility

// get list of places from search query
+ (void)getPlaces:(NSString *)searchTerm withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion{
    Key *key = [[Key alloc] init];
       NSString *queryTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
       NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=%@&input=%@&inputtype=%@&fields=business_status,formatted_address,geometry,icon,name,photos,place_id,plus_code,types,price_level,rating", key.key, queryTerm, @"textquery"];
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
