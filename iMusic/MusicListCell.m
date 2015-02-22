//
//  MusicListCell.m
//  iMusic
//
//  Created by Lance Cohen on 14/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import "MusicListCell.h"
#import "UIView+Geometry.h"

#define RESIZE_ADJUSTMENT 57.0

@implementation MusicListCell



// This method is called on the cell just before it transitions between cell states (eg: before delete button animates into view
-(void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];
	
	// Check if state transitioned in is where the delete button is shown on screen
	if(state == UITableViewCellStateShowingDeleteConfirmationMask){
		
		// Shrink the frameWidth of both labels
		self.albumNameLabel.frameWidth -= RESIZE_ADJUSTMENT;
		self.artistNameLabel.frameWidth -= RESIZE_ADJUSTMENT;
	
	}
}

// This method is called on the cell just after it transitions between cell states (eg: after the delete butotn animates out of view)
- (void)didTransitionToState:(UITableViewCellStateMask)state  {
	
	// Check if going from delete confirmation shown back to default state
	if(state == UITableViewCellStateDefaultMask){
		
		// Animate changes to one or more views using the specified duration with animation and completion handler.
		[UIView animateWithDuration:0.4 animations:^{
			
			// Expand the frameWidth of both labels
			self.albumNameLabel.frameWidth += RESIZE_ADJUSTMENT;
			self.artistNameLabel.frameWidth += RESIZE_ADJUSTMENT;

			
		} completion:^ (BOOL finished){ [super didTransitionToState:state];
		}];
		
	
	} else {
		[super didTransitionToState:state];
		
		
	}
	
	
	
}




@end
