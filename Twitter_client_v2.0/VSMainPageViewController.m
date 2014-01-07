//
//  VSMainPageViewController.m
//  Twitter_client_v2.0
//
//  Created by Admin on 05.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "VSMainPageViewController.h"

@interface VSMainPageViewController ()

@end

@implementation VSMainPageViewController

@synthesize tabBar;
@synthesize accountStore;
@synthesize typeTwitter;
@synthesize activeAccount;
@synthesize dictionary;
@synthesize usersAvatar, fullName, hacheName, tweetsButtonReference, folowerButtonReference, folowingButtonReference, loadingIndicator;
@synthesize countSymbols, buttonSendTweetReference, tweetList, tweetsListController;

- (id)init
{
    self = [super initWithNibName:@"VSMainPageViewController" bundle:nil];
    if (self) {
        // Custom initialization
        
        NSLog(@"init MainPage");
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background.jpg"]
                                            forBarMetrics:UIBarPositionTop];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[_textView layer] setBorderWidth:3.0f];
    _textView.layer.borderColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:0.5].CGColor;
    _textView.layer.cornerRadius = 10.0f;
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    accountStore = [[ACAccountStore alloc] init];
    _textView.delegate = self;
    tabBar.delegate = self;
    _textView.text = @"Compose new Tweet...";
    _textView.textColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    typeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:typeTwitter options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:typeTwitter];
            activeAccount = [[ACAccount alloc] init];
            activeAccount = [accounts objectAtIndex:(accounts.count -1)];
            [self loadDataFromService];
        }
        else{
            NSLog(@"WTF");
        }
    }];
    
    tabBar.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    
	
}

-(void)buttonsSettingsDefault
{
    tweetsButtonReference.titleLabel.textColor = [UIColor whiteColor];
    tweetsButtonReference.titleLabel.shadowColor = [UIColor whiteColor];
    tweetsButtonReference.titleLabel.numberOfLines = 2;
    tweetsButtonReference.titleLabel.textAlignment = NSTextAlignmentCenter;
    folowerButtonReference.titleLabel.textColor = [UIColor whiteColor];
    folowerButtonReference.titleLabel.shadowColor = [UIColor whiteColor];
    folowerButtonReference.titleLabel.numberOfLines = 2;
    folowerButtonReference.titleLabel.textAlignment = NSTextAlignmentCenter;
    folowingButtonReference.titleLabel.textColor = [UIColor whiteColor];
    folowingButtonReference.titleLabel.shadowColor = [UIColor whiteColor];
    folowingButtonReference.titleLabel.numberOfLines = 2;
    folowingButtonReference.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)loadDataFromService
{
    
    [self buttonsSettingsDefault];
    
    _textView.hidden = YES;
    [self.tabBar setHidden:YES];
    usersAvatar.hidden = YES;
    fullName.hidden = YES;
    hacheName.hidden = YES;
    tweetsButtonReference.hidden = YES;
    folowingButtonReference.hidden = YES;
    folowerButtonReference.hidden = YES;
    usersAvatar.layer.cornerRadius = 20.0f;
    loadingIndicator.hidden = NO;
    [loadingIndicator startAnimating];
    countSymbols.hidden = YES;
    buttonSendTweetReference.hidden = YES;
    
    [accountStore requestAccessToAccountsWithType:typeTwitter options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSString *userName = activeAccount.username;
            NSDictionary *options =[NSDictionary dictionaryWithObject:userName forKey:@"screen_name"];
            
            NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
            
            SLRequest *getInfo = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:options];
            
            [getInfo setAccount:activeAccount];
            [getInfo performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Check if we reached the reate limit
                    if ([urlResponse statusCode] == 429)
                    {
                        NSLog(@"Rate limit reached");
                        return;
                    }
                    if (error)
                    {
                        NSLog(@"Error: %@", error.localizedDescription);
                        return;
                    }
                    if (responseData) {
                        NSError *error = nil;
                        dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                        
                        
                        fullName.text = dictionary[@"name"];
                        hacheName.text = [NSString stringWithFormat:@"@%@", dictionary[@"screen_name"]];
                        
                        [tweetsButtonReference setTitle:[NSString stringWithFormat:@"%ld\n Tweets", (long)[dictionary[@"statuses_count"]integerValue]] forState:UIControlStateNormal];
                        [folowerButtonReference setTitle:[NSString stringWithFormat:@"%ld\n Folower", (long)[dictionary[@"friends_count"]integerValue]] forState:UIControlStateNormal];
                        [folowingButtonReference setTitle:[NSString stringWithFormat:@"%ld\n Folowing", (long)[dictionary[@"followers_count"]integerValue]] forState:UIControlStateNormal];
                        NSURL *imageurl = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
                        usersAvatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
                        
                        [self.navigationController setNavigationBarHidden:NO animated:YES];
                        [self.tabBar setHidden:NO];
                        usersAvatar.hidden = NO;
                        fullName.hidden = NO;
                        hacheName.hidden = NO;
                        tweetsButtonReference.hidden = NO;
                        folowingButtonReference.hidden = NO;
                        folowerButtonReference.hidden = NO;
                        [loadingIndicator stopAnimating];
                        loadingIndicator.hidden = YES;
                        _textView.hidden = NO;
                    }
                });
            }];
        }
        else
        {
            NSLog(@"No access granted");
        }
        
    }];
}

-(void)hideAllElemnts
{
    _textView.hidden = YES;
    [self.tabBar setHidden:YES];
    usersAvatar.hidden = YES;
    fullName.hidden = YES;
    hacheName.hidden = YES;
    tweetsButtonReference.hidden = YES;
    folowingButtonReference.hidden = YES;
    folowerButtonReference.hidden = YES;
    usersAvatar.layer.cornerRadius = 20.0f;
    loadingIndicator.hidden = NO;
    [loadingIndicator startAnimating];
    countSymbols.hidden = YES;
    buttonSendTweetReference.hidden = YES;
}

-(void)viewWillLayoutSubviews
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        NSLog(@"Landscape main screen");//big small
        
        /*usersAvatar.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        fullName.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        hacheName.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        tweetsButtonReference.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        folowerButtonReference.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        folowingButtonReference.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);*/
        loadingIndicator.frame = CGRectMake(274, 118, 20, 20);
        tabBar.frame = CGRectMake(0, 219, 568, 49);
    }
    else
    {
        NSLog(@"Portrait main screen");//small big
        
        usersAvatar.frame = CGRectMake(20, 20, 100, 100);
        fullName.frame = CGRectMake(150, 20, 134, 66);
        hacheName.frame = CGRectMake(150, 87, 142, 21);
        tweetsButtonReference.frame = CGRectMake(13, 158, 87, 60);
        folowerButtonReference.frame = CGRectMake(220, 158, 87, 60);
        folowingButtonReference.frame = CGRectMake(115, 158, 90, 60);
        loadingIndicator.frame = CGRectMake(150, 242, 20, 20);
        tabBar.frame = CGRectMake(0, 455, 320, 49);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) keyboardDidShow:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 90);
    else
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 130);
    [UIView commitAnimations];
}

- (void) keyboardDidHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
    else
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 130);
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Iterate through your subviews, or some other custom array of views
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}

- (IBAction)sendTweet:(id)sender
{
    
    NSString *tweetText = _textView.text.copy;
    NSLog(@"%@",tweetText);
    _textView.text = @"";
    //not neccesary if all clear, but something was wrong.... we take an error code
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"Success");
                //no errors, control our posting
                
            }
            else {
                NSLog(@"ERROR: error code: %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
        ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
        ^(BOOL granted, NSError *error) {
            if (granted) {
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                NSDictionary *params = @ {@"status" : tweetText};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:url
                                                           parameters:params];
                [request setAccount:activeAccount];
                [request setAccessibilityValue:@"1"];
                [request performRequestWithHandler:requestHandler];
            }
            else {
                NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                      [error localizedDescription]);
            }
        };
        
        [accountStore requestAccessToAccountsWithType:typeTwitter
                                              options:NULL
                                           completion:accountStoreHandler];

}



//here and below the description UITextViewDelegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
        NSLog(@"The border of the screen is reached and scrolled the text up");
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _textView.layer.borderColor = [UIColor colorWithRed:0 green:0.68 blue:0.93 alpha:1].CGColor;
    
    if([textView.text isEqual:@"Compose new Tweet..."] && [textView.textColor isEqual:[UIColor lightGrayColor]])
        textView.text = @"";
    textView.textColor = [UIColor blackColor];
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        //self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
        ;
    else
    {
        _textView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, 280, 130);
        countSymbols.frame = CGRectMake(_textView.frame.origin.x + 180, _textView.frame.origin.y + 140, 30, 20);
        buttonSendTweetReference.frame = CGRectMake(countSymbols.frame.origin.x + 60, countSymbols.frame.origin.y, 50, 25);
        buttonSendTweetReference.layer.cornerRadius = 10;
        countSymbols.text = [NSString stringWithFormat:@"%d", 140 - _textView.text.length];
    }
    countSymbols.hidden = NO;
    buttonSendTweetReference.hidden = NO;
    if(textView.text.length == 0)
        buttonSendTweetReference.enabled = NO;
    else
        buttonSendTweetReference.enabled = YES;
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    countSymbols.text = [NSString stringWithFormat:@"%d", 140 - _textView.text.length];
    if(textView.text.length == 0){
        /*textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Compose new Tweet...";
        [textView resignFirstResponder];*/
        buttonSendTweetReference.enabled = NO;
    }
    else
        buttonSendTweetReference.enabled = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _textView.layer.borderColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:0.5].CGColor;
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Compose new Tweet...";
        [textView resignFirstResponder];
    }
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        //self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
        ;
    else
        _textView.frame = CGRectMake(_textView.frame.origin.x, _textView.frame.origin.y, 280, 34);
    countSymbols.hidden = YES;
    buttonSendTweetReference.hidden = YES;
}

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 139)
        return NO;
    else return YES;
}

//tabBar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //if([item isEqual:tweetList])
    NSLog(@"working");
    {
        if ( !tweetsListController )
        {
            tweetsListController = [ [ VSTweetsListViewController alloc ] init ];
        }
        [self.navigationController pushViewController:tweetsListController animated:YES];
    }
}

@end