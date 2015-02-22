//
//  MusicStoreService.h
//  iMusic
//
//  Created by Lance Cohen on 18/02/2015.
//  Copyright (c) 2015 TapHarmonic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Artist;
@class Album;

typedef void(^ServiceCompletionBlock)(id result, NSError *error);


@interface MusicStoreService : NSObject

-(void)findArtistsByArtistName:(NSString *)artistName completionBlock:(ServiceCompletionBlock)completionBlock;

-(void)loadAlbumsForArtist:(Artist *)artist completionBlock:(ServiceCompletionBlock)completionBlock;

-(void)fetchArtworkForAlbum:(Artist *)album completionBlock:(ServiceCompletionBlock)completionBlock;

@end
