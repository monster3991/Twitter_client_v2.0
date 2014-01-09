//
//  VSStartScreenController.h
//  Twitter_client
//
//  Created by Admin on 02.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "VSMainPageViewController.h"

@interface VSStartScreenController : UIViewController <UIViewControllerTransitioningDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) VSMainPageViewController *mainViewController;
@property (strong,nonatomic) ACAccountStore *accountStore;
@property (strong,nonatomic) ACAccountType *accountType;


-(id)init;
- (IBAction)authorized:(id)sender;

@end
