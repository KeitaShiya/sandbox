#import <Foundation/Foundation.h>

@interface HBContent : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSURL *URL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
