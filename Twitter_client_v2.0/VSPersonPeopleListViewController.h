//
//  VSPersonPeopleListViewController.h
//  Twitter_client_v2.0
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface VSPersonPeopleListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *peopleList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (strong, nonatomic) NSMutableDictionary *dictListFromJson;
@property (strong, nonatomic) NSString *objectType;
@property (strong, nonatomic) NSArray *currentDict;

-(id)init;

-(void)getData;

@end
