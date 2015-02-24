//
//  BrowseAlbumsViewController.m
//  iMusic
//
//  Created by Bob McCune.
//  Copyright (c) 2012 TapHarmonic, LLC. All rights reserved.
//

#import "BrowseAlbumsViewController.h"
#import "AlbumDetailsViewController.h"
#import "Album.h"
#import "MusicStoreService.h"

@interface BrowseAlbumsViewController ()
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation BrowseAlbumsViewController

@synthesize artist = _artist;
@synthesize albums = _albums;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Albums";
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	// Create a new instance of MusicStoreService
	MusicStoreService *service = [[MusicStoreService alloc] init];
	
	// Call loadAlbumsForArtist method on service object to get the album based on artist from iTunes
	[service loadAlbumsForArtist:self.artist
			  completionBlock:^(id result, NSError *error) {
				  
				  // Display a popup error message if unable to find artist entered on iTunes
				  if(error)
				  {
					  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Search Error"
																		  message:@"Unable to retrieve search results. "
															    delegate: nil
																cancelButtonTitle:@"OK"
																otherButtonTitles:nil];
					  
					  [alertView show];
					  return;
				  }
				  
				  // Set the albums property to the result paramater of the search
				  self.albums= result;
				  // Refresh the result list. This reinvokes the tableView data source methods and redraws the table
				  [self.tableView reloadData];
	  
				  
			  }];
	
	}

- (IBAction)closeDialog:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];
	cell.textLabel.text = [[self.albums objectAtIndex:indexPath.row] albumName];
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showDetails"]) {
		AlbumDetailsViewController *controller = [segue destinationViewController];
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		controller.album = [self.albums objectAtIndex:indexPath.row];
		controller.saveToListEnabled = YES;
	}
}

@end
