//
//  MusicListViewController.m
//  iMusic
//


#import "MusicListViewController.h"
#import "Album.h"
#import "MusicListCell.h"
#import "AlbumDetailsViewController.h"


@interface MusicListViewController ()
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation MusicListViewController

@synthesize albums = _albums;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//self.navigationController.navigationBarHidden = YES;
	
	self.title = @"iMusic List";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES];
	
	// Get the updated list of albums from disk
	self.albums = [NSMutableArray arrayWithArray:[Album findAllAlbums]];
	
	// Reload the data in the table to reinvoke the datasource methods
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	

}



#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];

	Album *album = [self.albums objectAtIndex:indexPath.row];
	
	cell.albumImageView.image = album.albumImage;
	cell.albumNameLabel.text = album.albumName;
	cell.artistNameLabel.text = album.artist.artistName;

	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		Album *album = [self.albums objectAtIndex:indexPath.row];
		[album deleteAlbum];
		[self.albums removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - UITableViewDelegate Methods

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Album *album = [self.albums objectAtIndex:indexPath.row];
	NSString *message = [NSString stringWithFormat:@"Artist: %@\nAlbum: %@", album.artist.artistName, album.albumName];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Selection" 
														message:message 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
}
*/

/* This method is invoked prior to executing a segue (transition between controller views) allowing us the chance to do whatever setup needs doing */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Check if the seque identifier is equal to "showDetails"
	if([segue.identifier isEqualToString:@"showDetails"])
	{
		// Get the index path for the table row that was selected
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		
		// Get the album that was selected in the correpsonding tableView row
		Album *album = [self.albums objectAtIndex:indexPath.row];
		
		// Get the destination view controller for the segue (where it is transitioning to).
		AlbumDetailsViewController *controller = [segue destinationViewController];
		
		// Set the album property of the destination view controller to be the album selected
		controller.album = album;
		
		
	}

	
	
	
}

@end
