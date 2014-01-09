//
//  VSPersonTweetsListViewController.m
//  Twitter_client_v2.0
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "VSPersonTweetsListViewController.h"
#import "VSPersonPageViewController.h"
#import "VSMainPageViewController.h"
#import "VSCellView.h"

@interface VSPersonTweetsListViewController ()

@end

@implementation VSPersonTweetsListViewController

@synthesize tableViewReference;
@synthesize dictListFromJson;
@synthesize objectType, loadIndicator;

- (id)init
{
    self = [super initWithNibName:@"VSPersonTweetsListViewController" bundle:nil];
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
    //[dictListFromJson removeAllObjects];
    tableViewReference.hidden = YES;
    [loadIndicator startAnimating];
    [loadIndicator setHidden:NO];
    [self getData];
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

    VSMainPageViewController *userPage = [[self.navigationController viewControllers] objectAtIndex:(1)];
    NSLog(@"hacheName = %@",userPage.hacheName.text);
    VSPersonPageViewController *userPageCustom = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    
    [userPage.accountStore requestAccessToAccountsWithType:userPage.typeTwitter options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
            [param setObject:@"100" forKey:@"count"];
            //[param setObject:@"1" forKey:@"include_entities"];
            [param setObject:userPageCustom.hacheName.text forKey:@"screen_name"];
            
            NSURL *requestAPI;
            //composing request
            if([objectType isEqualToString:@"tweetsList"])
                requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
            
            //composing request
            if([objectType isEqualToString:@"myTweetsList"])
                requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
            
            //
            SLRequest *getTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
            [getTweets setAccount:userPage.activeAccount];
            [getTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                dictListFromJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                if(dictListFromJson.count!=0){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"count elements dict = %d",dictListFromJson.count);
                        [tableViewReference reloadData];
                        [tableViewReference setHidden:NO];
                        [loadIndicator startAnimating];
                        [loadIndicator setHidden:YES];
                        // Check if we reached the rate limit
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
    static NSString *CellIdentifier = @"VSCellView";
    VSCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"VSCellView" owner:nil options:nil];
        //cell = [[VSCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"create cell");
        cell = [[VSCellView alloc] init];
        for(id currentObject in topLevelObjects )
            if([currentObject isKindOfClass:[VSCellView class]])
            {
                cell = (VSCellView*)currentObject;
                break;
            }
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.tweetMessage.numberOfLines = 0;
    cell.fullName.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.hacheName.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    cell.tweetMessage.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    NSDictionary *currentDict = [dictListFromJson objectAtIndex:indexPath.row];
    NSDictionary *usersCurrentDict = currentDict[@"user"];
    if( indexPath.row < [dictListFromJson count] )
    {
        cell.hidden = NO;
        cell.tweetMessage.text = currentDict[@"text"];
        cell.fullName.text = usersCurrentDict[@"name"];
        cell.hacheName.text = [NSString stringWithFormat:@"@%@", usersCurrentDict[@"screen_name"]];
        
        NSLog(@"tweet = %@", cell.tweetMessage.text);
        
        NSString *str = [dictListFromJson objectAtIndex:indexPath.row][@"text"];
        CGSize contrainSize = CGSizeMake(280, MAXFLOAT);//320 is width of the screen
        CGRect size = [str boundingRectWithSize:contrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
        cell.tweetMessage.frame = CGRectMake(/*cell.tweetMessage.frame.origin.x, cell.tweetMessage.frame.origin.y,*/20, 70, cell.tweetMessage.frame.size.width - 40, size.size.height);
        
        //cell.frame = CGRectMake(0, 0, 320, cell.tweetMessage.frame.origin.y + textViewSize.height + 14);
        
        NSURL *image = [NSURL URLWithString:usersCurrentDict[@"profile_image_url_https"]];
        cell.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image]];
    }
    else
    {
        cell.hidden = YES;
    }
    
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [dictListFromJson objectAtIndex:indexPath.row][@"text"];
    CGSize contrainSize = CGSizeMake(280, MAXFLOAT);//280 is width of the screen
    CGRect size = [str boundingRectWithSize:contrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil];
    return size.size.height + 84;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dictListFromJson count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSMainPageViewController *userPage = [[self.navigationController viewControllers] objectAtIndex:(1)];
    if(indexPath.row < dictListFromJson.count)
    {
        NSDictionary *usersCurrentDict = dictListFromJson[indexPath.row];
        NSDictionary *usersCurrent = usersCurrentDict[@"user"];
        
       
            if([[dictListFromJson[indexPath.row] valueForKey:@"screen_name"] isEqualToString:userPage.hacheName.text] )
            {
                NSLog(@"didSelect: %@",userPage.hacheName.text);
                if(indexPath.row < dictListFromJson.count)
                {
                    VSMainPageViewController *page;
                    if(!page)
                    {
                        page = [[VSMainPageViewController alloc] init];
                    }
                    [self.navigationController pushViewController:page animated:YES];
                }
            }
            else
            {
                NSLog(@"didSelect: %@",userPage.hacheName.text);
                if(indexPath.row < dictListFromJson.count)
                {
                    VSPersonPageViewController *page;
                    if(!page)
                    {
                        page = [[VSPersonPageViewController alloc] init];
                    }
                    
                    page.personName = usersCurrent[@"screen_name"];
                    [self.navigationController pushViewController:page animated:YES];
                }
            
        }
    }
}

@end
