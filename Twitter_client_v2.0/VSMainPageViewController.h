//
//  VSMainPageViewController.h
//  Twitter_client_v2.0
//
//  Created by Admin on 05.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "VSTweetsListViewController.h"
#import "VSPeopleListViewController.h"

@interface VSMainPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *hacheName;
@property (weak, nonatomic) IBOutlet UIImageView *usersAvatar;

@property (weak, nonatomic) IBOutlet UIButton *tweetsButtonReference;
@property (weak, nonatomic) IBOutlet UIButton *folowingButtonReference;
@property (weak, nonatomic) IBOutlet UIButton *folowerButtonReference;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *countSymbols;

- (IBAction)sendTweet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendTweetReference;
@property (weak, nonatomic) IBOutlet UITabBarItem *tweetList;
@property (weak, nonatomic) IBOutlet UITabBarItem *homeButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *infoButton;
- (IBAction)myTweetsList:(id)sender;
- (IBAction)folowingList:(id)sender;
- (IBAction)folowersList:(id)sender;


@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *typeTwitter;
@property (strong, nonatomic) ACAccount *activeAccount;
@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) VSTweetsListViewController *listViewController;
@property (strong, nonatomic) VSPeopleListViewController *listPeopleViewController;

-(id) init;

-(void)loadDataFromService;
-(void)hideAllElemnts;
-(void)buttonsSettingsDefault;

@end
