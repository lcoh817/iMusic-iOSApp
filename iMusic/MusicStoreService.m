//
//  MusicStoreService.m
//  iMusic
//
//  Created by Lance Cohen on 18/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import "MusicStoreService.h"
#import "Artist.h"
#import "Album.h"
#import "NSDictionary+DateAdditions.h"
#import "NSString+Additions.h"

// Define a format string for the API endpoint
#define ARTIST_ENDPOINT_FORMAT @"http://itunes.apple.com/search?term=%@&media=music&entity=musicArtist&attribute=artistTerm&limit=20"

/* Define class extention to define private properties */
@interface MusicStoreService()
@property (nonatomic, strong) NSURLConnection *connection;

// Note: NSMututableData is an OO wrapper around a byte buffer
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic,strong) ServiceCompletionBlock completionBlock;
@end

@implementation MusicStoreService


-(void)findArtistsByArtistName:(NSString *)artistName completionBlock:(ServiceCompletionBlock)completionBlock {
	
	self.completionBlock = completionBlock;
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:ARTIST_ENDPOINT_FORMAT, [artistName urlEncodedString]]];
	
	/* The URL defines what we are attempting to get, the URL request defines HOW we are getting that resource */
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	// responseData will be a byte buffer which accumulates the response back from the server to the API request
	self.responseData = [[NSMutableData alloc] init];
	
	/*  As soon as the connectionWithRequest method is called it will invoke the actual GET request. 
	    Set this class as the delege so this class can participate in the request response process  
	    (via delegate call back methods)
	 */	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	
	
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
	
}

/* This method is invoked when the response is complete and we have captured all of the response data */
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	
	// Declare a pointer to an NSError object to hold any errors that might occur while Parsing the JSON
	NSError *error;
	
	// Convert response buffer data into NSDictionary format
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
	
	// Check if data parsed correctly
	if(jsonDict){
		
		// Creat an empty NSMutableArry to store list of artists
		NSMutableArray *artists = [NSMutableArray array];
		// Iterate through the "result" dictionary value in jsonDic
		for(id artistDict in [jsonDict objectForKey:@"results"]){
			
			// Extract the artistID as an NSInteger value
			NSInteger artistID = [[artistDict objectForKey:@"artistID"] integerValue];
			// Extract the artistName as a NSString value
			NSString *artistName = [artistDict objectForKey:@"artistName"];
			
			// Add an artistObject to the array of artists with artistID and artistName parsed above
			[artists addObject:[Artist artistWithID:artistID name:artistName]];
		}
		
		// Call the completion block passing in the array of artists as the result of the parsing
		self.completionBlock(artists, nil);
	}
	else {
		self.completionBlock(nil, error);
	
	}
	

}





-(void)loadAlbumsForArtist:(Artist *)artist completionBlock:(ServiceCompletionBlock)completionBlock {
	
	
	
}

-(void)fetchArtworkForAlbum:(Artist *)album completionBlock:(ServiceCompletionBlock)completionBlock {
	
	
	
	
	
}


@end
