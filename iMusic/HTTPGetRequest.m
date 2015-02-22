//
//  HTTPGetRequest.m
//  iMusic
//
//  Created by Lance Cohen on 22/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import "HTTPGetRequest.h"

// Define class extension to define private properties
@interface HTTPGetRequest()

@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation HTTPGetRequest

-(id)initWithURL:(NSURL *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
	
	
	self = [super init];
	
	if(self) {
		
		self.requestURL = requestURL;
		self.successBlock = successBlock;
		self.failureBlock = failureBlock;
		
	}
	
	return self;
	
	
}

-(void)startRequest {
	
	/* The URL defines what we are attempting to get, the URL request defines HOW we are getting that resource */
	NSURLRequest *request = [NSURLRequest requestWithURL:self.requestURL];
	
	
	// responseData will be a byte buffer which accumulates the response back from the server to the API request
	self.responseData = [[NSMutableData alloc] init];
	
	/*  As soon as the connectionWithRequest method is called it will invoke the actual GET request.
	 Set this class as the delege so this class can participate in the request response process
	 (via delegate call back methods) */
	
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
}


/* If the remote server handles the request and provides a response this method will get invoked.
 
 Depending on redirects happening on the server side, this method could be invoked multiple times.
 So that means we need truncate old response data so that we are not holding old values from the previous request */
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response {
	
	// Set the number of bytes in the byte buffer to 0 to clear the buffer of old values
	[self.responseData setLength:0];
	
}

/* This method will be called as the remote server is writing out its response. The server will fill up the buffer and flush into the output stream until the entire response is completed. So this method will be invoked multiple times for each request */
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
	
	// Append the received data into the response byte buffer
	[self.responseData appendData:data];
	
	
}

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	
	
	// Nil out response data and connection properties so they can be freed up if an error occurs
	self.responseData = nil;
	self.connection = nil;
	
	// Invoke the failureBlock
	self.failureBlock(error);
	
}

/* This method is invoked when the response is complete and we have captured all of the response data */
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	
	self.successBlock([NSData dataWithData:self.responseData]);
	
}



@end
