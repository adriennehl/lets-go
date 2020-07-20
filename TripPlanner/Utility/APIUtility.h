//
//  APIUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIUtility : NSObject
+ (void)initializeMapsSDK;
+ (void)getPlaces:(NSString *)searchTerm withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion;
+ (void)getPlaceDetails:(NSString *)placeId withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completion;
+ (void)getPhoto:(NSArray *)photos photoReference:(NSString *)photoReference withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completion;
@end

NS_ASSUME_NONNULL_END
