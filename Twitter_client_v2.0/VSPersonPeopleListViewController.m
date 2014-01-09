//
//  VSPersonPeopleListViewController.m
//  Twitter_client_v2.0
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "VSPersonPeopleListViewController.h"
#import "VSMainPageViewController.h"
#import "VSCellView.h"
#import "VSPersonPageViewController.h"


@interface VSPersonPeopleListViewController ()

@end

@implementation VSPersonPeopleListViewController

@synthesize peopleList;
@synthesize dictListFromJson;
@synthesize objectType,currentDict,loadIndicator;

VSPersonPageViewController *personPage;

- (id)init
{
    self = [super initWithNibName:@"VSPersonPeopleListViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    peopleList.delegate = self;
    peopleList.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    peopleList.hidden = YES;
    loadIndicator.hidden = NO;
    [loadIndicator startAnimating];
    [self getData];
    [peopleList reloadData];
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
    VSPersonPageViewController *userPageCustom = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    [userPage.accountStore requestAccessToAccountsWithType:userPage.typeTwitter options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSMutableDictionary *param =[[NSMutableDictionary alloc]init];
            [param setObject:@"100" forKey:@"count"];
            [param setObject:@"1" forKey:@"include_entities"];
            [param setObject:userPageCustom.hacheName.text forKey:@"screen_name"];
            
            
            NSURL *requestAPI;
            //composing request
            if([objectType isEqualToString:@"folowingList"])
                requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"];
            //composing request
            if([objectType isEqualToString:@"folowersList"])
                requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
            
            //
            SLRequest *getTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:param];
            [getTweets setAccount:userPage.activeAccount];
            [getTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                dictListFromJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                if(dictListFromJson.count!=0){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        currentDict = dictListFromJson[@"users"];
                        [peopleList reloadData];
                        [loadIndicator stopAnimating];
                        loadIndicator.hidden = YES;
                        peopleList.hidden = NO;
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
    
    cell.fullName.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.hacheName.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    NSLog(@"count of array = %d", currentDict.count);
    if(indexPath.row < currentDict.count)
    {
        cell.fullName.hidden = NO;
        cell.hacheName.hidden =NO;
        cell.avatar.hidden = NO;
        NSDictionary *usersCurrentDict = currentDict[indexPath.row];
        cell.fullName.text = usersCurrentDict[@"name"];
        cell.hacheName.text = [NSString stringWithFormat:@"@%@", usersCurrentDict[@"screen_name"]];
        NSURL *image = [NSURL URLWithString:usersCurrentDict[@"profile_image_url_https"]];
        cell.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image]];
    }
    else
    {
        cell.fullName.hidden = YES;
        cell.hacheName.hidden =YES;
        cell.avatar.hidden = YES;
    }
    cell.tweetMessage.hidden = YES;
    
    
    
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentDict count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VSMainPageViewController *userPage = [[self.navigationController viewControllers] objectAtIndex:(1)];
    if(indexPath.row < currentDict.count)
    {
    if([[currentDict[indexPath.row] valueForKey:@"screen_name"] isEqualToString:userPage.hacheName.text] )
    {
    NSLog(@"didSelect: %@",userPage.hacheName.text);
    if(indexPath.row < currentDict.count)
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
        if(indexPath.row < currentDict.count)
        {
     VSPersonPageViewController *page;
     if(!page)
     {
     page = [[VSPersonPageViewController alloc] init];
     }
     NSDictionary *usersCurrentDict = currentDict[indexPath.row];
     page.personName = usersCurrentDict[@"screen_name"];
     [self.navigationController pushViewController:page animated:YES];
        }
    }
    }
}

@end
