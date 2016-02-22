#import "HBContentsTableViewController.h"
#import "HBWebViewController.h"
#import "HBXMLNetworkOperation.h"
#import "ISRefreshControl.h"
#import "HBContent.h"

@implementation HBContentsTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.contents = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
    
    self.refreshControl = [(id)[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushWeb"]) {
        HBWebViewController *viewController = (id)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        viewController.content = [self.contents objectAtIndex:indexPath.row];
    }
}

#pragma mark - action

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    
    NSURL *URL = [NSURL URLWithString:RSS_URL];
    [ISNetworkClient sendRequest:[NSURLRequest requestWithURL:URL]
                  operationClass:[HBXMLNetworkOperation class]
                         handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                             if (error || response.statusCode != 200) {
                                 return;
                             }
                             
                             NSMutableArray *contents = [NSMutableArray array];
                             NSArray *array = [[[object objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
                             for (NSDictionary *dictionary in array) {
                                 HBContent *content = [[HBContent alloc] initWithDictionary:dictionary];
                                 [contents addObject:content];
                             }
                             self.contents = [NSArray arrayWithArray:contents];
                             
                             [self.refreshControl endRefreshing];
                             [self.tableView reloadData];
                         }];
}

#pragma mark - table view data srouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    HBContent *content = [self.contents objectAtIndex:indexPath.row];
    cell.textLabel.text = content.title;
    cell.detailTextLabel.text = content.dateString;
    
    return cell;
}

@end
