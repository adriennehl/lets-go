//
//  MailUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@interface MailUtility : NSObject
+ (NSString *)composeMessage:(Trip *)trip;
@end

NS_ASSUME_NONNULL_END
