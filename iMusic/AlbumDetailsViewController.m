//
//  AlumDetailsViewController.m
//  iMusic
//
//  Created by Lance Cohen on 15/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import "AlbumDetailsViewController.h"
#import "MusicStoreService.h"

@implementation AlbumDetailsViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	//self.navigationController.navigationBarHidden = YES;
	
	[self.navigationController setNavigationBarHidden:NO];
	
	// Check if albumImage is empty
	if(!self.album.albumImage)
	{
		// Create a new instance of a MusicStoreService object
		MusicStoreService *service = [[MusicStoreService alloc] init];
		
		[service fetchArtworkForAlbum:self.album completionBlock:^(id result, NSError *error) {
			
				self.album.albumImage = result;
				self.albumImageView.image = result;
			
		}];
		
		
	} else {
		// Set the albumImageView to the albumImage
		self.albumImageView.image = self.album.albumImage;
		
	}
	
	// Set the albumNameLabel to the albumName
	self.albumNameLabel.text = self.album.albumName;
	
	// Set the artistNameLabel to the artistName
	self.artistNameLabel.text = self.album.artist.artistName;
	
	// Set the genreLabel to the album genre
	self.genreLabel.text = self.album.genre;
	
	// Set the priceLabel to the albumPrice formatted with $ sign before the price string
	self.priceLabel.text = [NSString stringWithFormat:@"$%@", self.album.price];
	
	// Create a new instance of NDDateFormatter object called formatter
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// Set the date format to short style
	[formatter setDateStyle:NSDateFormatterShortStyle];

	// Set dateLabel to the release date converted into a string with short style format
	self.dateLabel.text = [formatter stringFromDate:self.album.releaseDate];
	
	/* Set the enable property of the saveToListButton to the saveToListEnabled bool property (set to false by default). We want it to be disabled as the album is already in the list */
	self.saveToListButton.enabled = self.saveToListEnabled;
	

	
}

-(IBAction)saveToList:(id)sender {
	
	// Save the album property to disk
	[self.album saveAlbum];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
	
	
	
}
-(IBAction)openInITunes:(id)sender{
	
	/* Define the url that the user will transition to. This the iTunesURLString property contained within each album object */
	NSURL *url = [NSURL URLWithString:self.album.iTunesURLString];
	
	/* Get a reference to the UIApplication instance by calling the sharedApplication method on it.
	 Then call openURL on it to open/navigate to the url in a web browser */
	
	[[UIApplication sharedApplication] openURL: url];
	
	
}


@end
