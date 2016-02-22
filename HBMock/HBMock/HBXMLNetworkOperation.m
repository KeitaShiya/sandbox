#import "HBXMLNetworkOperation.h"
#import "XMLReader.h"

@implementation HBXMLNetworkOperation

- (id)processData:(NSData *)data
{
    return [XMLReader dictionaryForXMLData:data error:nil];
}

@end
