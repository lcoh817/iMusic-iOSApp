//
//  HTTPGetRequest.h
//  iMusic
//
//  Created by Lance Cohen on 22/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSData *response);
typedef void(^FailureBlock)(NSError *error);


@interface HTTPGetRequest : NSObject


-(id)initWithURL:(NSURL *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)startRequest;



@end
