//
//  VSTweetsListViewController.h
//  Twitter_client_v2.0
//
//  Created by Admin on 06.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface VSTweetsListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableViewReference;
@property (strong, nonatomic) NSMutableArray *dictListFromJson;
@property (strong, nonatomic) NSString *objectType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

-(id)init;

-(void)getData;
@end
