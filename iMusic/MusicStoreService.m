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
#define ALBUM_URL_FORMAT @"http://itunes.apple.com/lookup?id=%lu&entity=album"

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
				NSInteger artistID = [[artistDict objectForKey:@"artistId"] integerValue];
				
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
	
	// Invoke the startRequest method on the request object to issue the request
	[request startRequest];
}


-(void)loadAlbumsForArtist:(Artist *)artist completionBlock:(ServiceCompletionBlock)completionBlock {
	
	// Create URL based on the artist ID
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:ALBUM_URL_FORMAT, (unsigned long)artist.artistID]];
	
	NSLog([NSString stringWithFormat:ALBUM_URL_FORMAT, (unsigned long)artist.artistID]);
	
	SuccessBlock successBlock = ^(NSData *responseData) {
		
		//NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
		
		NSError *error;
		
		// Convert the JSON response data into a dictionary using NSJSONSerialization
		id jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
		
		// Check is jsonDict was properly parsed
		if(jsonDict){
			
			// Create an new instance of NSMutableArray
			NSMutableArray *albums = [NSMutableArray array];
			
			// Iterate throught the "results" dictionary
			for(NSDictionary *albumDict in [jsonDict objectForKey:@"results"])
			{
				if([[albumDict objectForKey:@"wrapperType"] isEqualToString: @"collection"])
				{
					// Create a new album instance
					Album *album = [[Album alloc] init];
					
					// Set the albumID property of the new album object
					album.albumID =	[[albumDict objectForKey:@"collectionId"]  integerValue];
				
					// Set the albumName property of the new album object
					album.albumName = [albumDict objectForKey:@"collectionName"];
					
					// Set the albumURLString property of the new album object
					album.imageURLString = [albumDict objectForKey:@"artworkUrl100"];
					
					// Set the albumPrice price property of the new album object
					album.price = [albumDict objectForKey:@"collectionPrice"];
					
					// Set the collectionViewUrl price property of the new album object
					album.iTunesURLString = [albumDict objectForKey:@"collectionViewUrl"];
					
					// Set the genre property of the new album object
					album.genre = [albumDict objectForKey:@"primaryGenreName"];
					
					// Set the releaseDate property of the new album object. Note dateForKey is a category method added to NSDictionary
					album.releaseDate = [albumDict dateForKey:@"releaseDate"];
					
					album.artist = artist;
					
					// Add album to our albums collection
					[albums addObject:album];
					
				}
				
				completionBlock(albums, nil);
				
			}
			
			
		} else {
			
			completionBlock(nil, error);
			
		}
		
		
		
	};
	
	FailureBlock failureBlock = ^(NSError *error) {
		
		completionBlock(nil, error);
		
		
	};
	
	// Create a new instance of HTTGetRequest initiliased with our url and success and failure blocks
	HTTPGetRequest *request = [[HTTPGetRequest alloc] initWithURL:url successBlock:successBlock failureBlock:failureBlock];
	
	// Invoke the startRequest method on the request object to issue the request
	[request startRequest];
}

-(void)fetchArtworkForAlbum:(Album *)album completionBlock:(ServiceCompletionBlock)completionBlock {
	
	// Create a new instance of a URL object from the imageURLString
	NSURL *url = [NSURL URLWithString:album.imageURLString];
	
	SuccessBlock successBlock = ^(NSData *responseData) {
		
		completionBlock([UIImage imageWithData:responseData], nil);
		
	};
	
	// Create a new instance of a HTTP get request object
	HTTPGetRequest *request = [[HTTPGetRequest alloc] initWithURL:url successBlock:successBlock failureBlock:NULL];
	
	// Kick off the request
	[request startRequest];
	

}


@end
