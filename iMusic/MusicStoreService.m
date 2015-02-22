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
#import "HTTPGetRequest.h"

// Define a format string for the API endpoint
#define ARTIST_ENDPOINT_FORMAT @"http://itunes.apple.com/search?term=%@&media=music&entity=musicArtist&attribute=artistTerm&limit=20"


@implementation MusicStoreService

-(void)findArtistsByArtistName:(NSString *)artistName completionBlock:(ServiceCompletionBlock)completionBlock {
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:ARTIST_ENDPOINT_FORMAT, [artistName urlEncodedString]]];
	
	SuccessBlock successBlock = ^(NSData *response) {
		
		
		// Declare a pointer to an NSError object to hold any errors that might occur while Parsing the JSON
		NSError *error;
		
		// Convert response buffer data into NSDictionary format
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
		
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
			completionBlock(artists, nil);
		}
		else {
			completionBlock(nil, error);
			
		}

		
	};
	
	FailureBlock failureBlock = ^(NSError *error) {
		
		completionBlock(nil, error);
		
	};
	
	// Create a new instance of HTTGetRequest initiliased with our url and success and failure blocks
	HTTPGetRequest *request = [[HTTPGetRequest alloc] initWithURL:url successBlock:successBlock failureBlock:failureBlock];
	
	// Invoke the startRequest method on the request object to kick off the request
	[request startRequest];
}


-(void)loadAlbumsForArtist:(Artist *)artist completionBlock:(ServiceCompletionBlock)completionBlock {
	
	
	
}

-(void)fetchArtworkForAlbum:(Artist *)album completionBlock:(ServiceCompletionBlock)completionBlock {
	
	
	
	
	
}


@end
