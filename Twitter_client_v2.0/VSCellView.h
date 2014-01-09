//
//  VSCellView.h
//  Twitter_client_v2.0
//
//  Created by Admin on 07.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *hacheName;
@property (weak, nonatomic) IBOutlet UILabel *tweetMessage;

@end
