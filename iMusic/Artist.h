//
//  Artist.h
//  iMusic
//


@interface Artist : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger artistID;
@property (nonatomic, copy) NSString *artistName;

+ (id)artistWithID:(NSUInteger)artistID name:(NSString *)artistName;
- (id)initWithID:(NSUInteger)artistID name:(NSString *)artistName;

@end
