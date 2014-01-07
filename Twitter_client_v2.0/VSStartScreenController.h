//
//  VSStartScreenController.h
//  Twitter_client
//
//  Created by Admin on 02.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSMainPageViewController.h"

@interface VSStartScreenController : UIViewController <UIViewControllerTransitioningDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (strong, nonatomic) VSMainPageViewController *mainViewController;

- (IBAction)setCursorToPasswdField:(id)sender;
- (IBAction)goAction:(id)sender;

-(id)init;
- (IBAction)authorized:(id)sender;

@end
