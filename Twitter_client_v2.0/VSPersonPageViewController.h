//
//  VSPersonPageViewController.h
//  Twitter_client_v2.0
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "VSTweetsListViewController.h"
#import "VSPeopleListViewController.h"
#import "VSPersonTweetsListViewController.h"
#import "VSPersonPeopleListViewController.h"

@interface VSPersonPageViewController : UIViewController

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

- (IBAction)sendMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendMessageReference;
@property (weak, nonatomic) IBOutlet UITabBarItem *tweetList;
@property (weak, nonatomic) IBOutlet UITabBarItem *homeButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *infoButton;
- (IBAction)personTweetsList:(id)sender;
- (IBAction)folowingList:(id)sender;
- (IBAction)folowersList:(id)sender;


@property (strong, nonatomic) ACAccount *activeAccount;
@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) VSPersonTweetsListViewController *listViewController;
@property (strong, nonatomic) VSPersonPeopleListViewController *listPeopleViewController;
@property (strong, nonatomic) NSString *personName;
@property(strong, nonatomic)ACAccountStore *accountStore;
@property(strong, nonatomic) ACAccountType *typeTwitter;

-(id) init;

-(void)loadDataFromService;
-(void)hideAllElemnts;
-(void)buttonsSettingsDefault;

@end
