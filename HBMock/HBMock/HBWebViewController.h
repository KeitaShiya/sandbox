#import <UIKit/UIKit.h>

@class HBContent;

@interface HBWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) HBContent *content;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
