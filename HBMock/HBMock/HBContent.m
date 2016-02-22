#import "HBContent.h"

@implementation HBContent

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.title      = [self trimmingWhiteSpaceAndNewLine:[[dictionary objectForKey:@"title"]objectForKey:@"text"]];
        self.dateString = [self trimmingWhiteSpaceAndNewLine:[[dictionary objectForKey:@"pubDate"]objectForKey:@"text"]];
        
        NSString *urlString = [self trimmingWhiteSpaceAndNewLine:[[dictionary objectForKey:@"link"]objectForKey:@"text"]];
        self.URL            = [NSURL URLWithString:urlString];
    }
    return self;
}

- (NSString *)trimmingWhiteSpaceAndNewLine:(NSString*)string
{
    return  [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
