//
//  MusicListCell.h
//  iMusic
//
//  Created by Lance Cohen on 14/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *albumImageView;
@property (nonatomic, weak) IBOutlet UILabel *albumNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;

@end
