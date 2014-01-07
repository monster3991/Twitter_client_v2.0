//
//  VSTweetsListViewController.m
//  Twitter_client_v2.0
//
//  Created by Admin on 06.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "VSTweetsListViewController.h"
#import "VSMainPageViewController.h"

@interface VSTweetsListViewController ()

@end

@implementation VSTweetsListViewController

@synthesize tableViewReference;
@synthesize dictListFromJson,heights;

- (id)init
{
    self = [super initWithNibName:@"VSTweetsListViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableViewReference.delegate = self;
    tableViewReference.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getData];
    [tableViewReference reloadData];
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    VSMainPageViewController *userPage = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    [userPage.accountStore requestAccessToAccountsWithType:userPage.typeTwitter options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
            [param setObject:@"100" forKey:@"count"];
            [param setObject:@"1" forKey:@"include_entities"];
            NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
            SLRequest *getTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
            [getTweets setAccount:userPage.activeAccount];
            [getTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                dictListFromJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                if(dictListFromJson.count!=0){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"count elements dict = %d",dictListFromJson.count);
                        [tableViewReference reloadData];
                        // Check if we reached the reate limit
                    });
                    
                }
            }];
        } else
        {
            NSLog(@"No access granted");
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *avatar = [[UIImageView alloc] init];
    UILabel *fullName = [[UILabel alloc] init];
    UILabel *hacheName = [[UILabel alloc] init];
    UITextView *tweetMessage = [[UITextView alloc] init];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"create cell");
        //cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        
        avatar.frame = CGRectMake(20, 10, 50, 50);
        fullName.frame = CGRectMake(90, 10, 210, 30);
        hacheName.frame = CGRectMake(90, 40, 210, 15);
        tweetMessage.frame = CGRectMake(20, 70, 210, 40);
        
        fullName.numberOfLines = 2;
        fullName.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        hacheName.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        tweetMessage.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        
        
    }
    
    NSDictionary *currentDict = [dictListFromJson objectAtIndex:indexPath.row];
    NSDictionary *usersCurrentDict = currentDict[@"user"];
    tweetMessage.text = currentDict[@"text"];
    NSLog(@"tweet = %@", tweetMessage.text);
    fullName.text = usersCurrentDict[@"name"];
    hacheName.text = [NSString stringWithFormat:@"@%@", usersCurrentDict[@"screen_name"]];
    
    NSURL *image = [NSURL URLWithString:usersCurrentDict[@"profile_image_url_https"]];
    avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image]];
    
    CGSize textViewSize = [tweetMessage sizeThatFits:CGSizeMake(tweetMessage.frame.size.width, FLT_MAX)];
    tweetMessage.frame = CGRectMake(tweetMessage.frame.origin.x, tweetMessage.frame.origin.y, tweetMessage.frame.size.width, textViewSize.height);
    
    tweetMessage.userInteractionEnabled = NO;
    
    [cell addSubview:fullName];
    [cell addSubview:hacheName];
    [cell addSubview:avatar];
    [cell addSubview:tweetMessage];
    //[tweetMessage becomeFirstResponder];
    [heights addObject:[NSNumber numberWithInteger:(tweetMessage.frame.origin.y + textViewSize.height + 20)]];
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSString *str = [dictListFromJson objectAtIndex:indexPath.row][@"text"];
    CGSize contrainSize = CGSizeMake(320, MAXFLOAT);//320 is width of the screen
    CGRect size = [str boundingRectWithSize:contrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    return size.size.height + 14;*/
    //NSNumber *a = ;
    //NSLog(@"int = %d",[[heights objectAtIndex:indexPath.row] integerValue]);
    //return [[heights objectAtIndex:indexPath.row] integerValue];
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dictListFromJson count];
}

@end
