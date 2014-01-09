//
//  VSStartScreenController.m
//  Twitter_client
//
//  Created by Admin on 02.01.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "VSStartScreenController.h"

@interface VSStartScreenController ()

@end

@implementation VSStartScreenController

@synthesize logoImage;
@synthesize signInButton,accountStore,accountType;

@synthesize mainViewController;

-(id)init
{
    self = [super initWithNibName:@"VSStartScreenController" bundle:nil];
    if (self)
    {
        self.title = @"StartScreen";
        // Custom initialization
    }
    return self;
}


-(void) viewWillLayoutSubviews
{
    //background
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //load twitter logo
    //[logoImage initWithImage:[UIImage imageNamed:@"twitter_logo.jpg"]];
    [logoImage setImage:[UIImage imageNamed:@"twitter_logo.jpg"]];
    
    //round buttons and labels
    
    static BOOL isTheFirstRun = TRUE;
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        NSLog(@"Landscape main screen");//big small
        
        logoImage.frame = CGRectMake(215, 20, 138, 115);
        signInButton.frame = CGRectMake(50, 260, 468, 40);
        signInButton.alpha = 1.0f;
    }
    else
    {
        NSLog(@"Portrait main screen");//small big
        
        if( isTheFirstRun )
        {
            signInButton.frame = CGRectMake(55, 390, 210, 35);
            [UIView animateWithDuration:1.0f delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                logoImage.center = CGPointMake(160, 284);
                logoImage.center = CGPointMake(160, 160);
            } completion:^(BOOL finished){
                if (finished)
                    [UIView animateWithDuration:2.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{

                        signInButton.alpha = 1.0f;
                    } completion:nil];
                
            }];
            isTheFirstRun = FALSE;
        }
        else
        {
            logoImage.frame = CGRectMake(91, 102.5f, 138, 115);
            signInButton.frame = CGRectMake(55, 390, 210, 35);
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    static BOOL isTheFirstRun = TRUE;
    if(isTheFirstRun)
    {
        signInButton.alpha = 0.0f;
        signInButton.layer.cornerRadius = 10;
        isTheFirstRun = FALSE;
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = TRUE;
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if(!accountStore)
    {
        accountStore = [[ACAccountStore alloc] init];
        accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) keyboardDidShow:(NSNotification *)aNotification
{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 90);
        else
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        [UIView commitAnimations];
}

- (void) keyboardDidHide:(NSNotification *)aNotification
{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
        else
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
        [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Iterate through your subviews, or some other custom array of views
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}



-(IBAction)authorized:(id)sender
{
    BOOL __block grantedAccess = TRUE;
    /*[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if( accounts.count == 0)
            {
                ;
            }
            else
            {
                
                grantedAccess = TRUE;
            }
        }
        else
        {
            ;
        }
        
    }];*/
    if(grantedAccess)
    {
        if ( !mainViewController )
        {
            mainViewController = [ [ VSMainPageViewController alloc ] init ];
        }
        [ self.navigationController pushViewController:mainViewController animated:YES ];
    }
    else
    {
        UIAlertView *needAccount = [[UIAlertView alloc]initWithTitle:@"No connection"
                                                             message:@"Please, create an account in the settings"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [needAccount show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end