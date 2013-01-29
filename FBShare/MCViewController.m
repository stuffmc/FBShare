//
//  MCViewController.m
//  FBShare
//
//  Created by Manuel "StuFF mc" Carrasco Molina on 26.01.13.
//  Copyright (c) 2013 Pomcast.biz. All rights reserved.
//
//  THIS HELPED A LOT: http://facebook.stackoverflow.com/questions/12644229/ios-6-facebook-posting-procedure-ends-up-with-remote-app-id-does-not-match-stor

#import "MCViewController.h"

@interface MCViewController ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *facebookAccountType;
@property (strong, nonatomic) NSMutableDictionary *fbOptions;

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composeVC setInitialText:@"Super Test"];
    [composeVC addImage:[UIImage imageNamed:@"avatar"]];
    [composeVC addImage:[UIImage imageNamed:@"cat"]];
    [composeVC addURL:[NSURL URLWithString:@"http://apple.com"]];
    [composeVC addURL:[NSURL URLWithString:@"http://commentsapp.co"]];
    [self presentViewController:composeVC animated:NO completion:^{
        
    }];
}
- (IBAction)basic:(id)sender {
    self.accountStore = [[ACAccountStore alloc] init];
    self.facebookAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    // Specify App ID and permissions
    self.fbOptions = [@{ACFacebookAppIdKey: @"319469588153965", ACFacebookPermissionsKey: @[@"email"], ACFacebookAudienceKey: ACFacebookAudienceFriends} mutableCopy];
    [self.accountStore requestAccessToAccountsWithType:self.facebookAccountType
                                          options:self.fbOptions completion:^(BOOL granted, NSError *e) {
        NSLog(@"G: %d — e: %@", granted, e);
        if (!granted) {
            switch (e.code) {
              case 6:
                  NSLog(@"Please setup a Facebook account from the settings");
                  break;
                  
              default:
                  break;
            }
        }
    }];
}

- (IBAction)request:(id)sender {
    // Specify App ID and permissions
    self.fbOptions[ACFacebookPermissionsKey] = @[[self.fbOptions[ACFacebookPermissionsKey] lastObject], @"publish_actions"];
    __block ACAccount *facebookAccount = nil;
    [self.accountStore requestAccessToAccountsWithType:self.facebookAccountType
                                               options:self.fbOptions
                                            completion:^(BOOL granted, NSError *e) {
        NSLog(@"G: %d — e: %@", granted, e);
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:_facebookAccountType];
            facebookAccount = [accounts lastObject];

            // Which fields? See https://developers.facebook.com/docs/reference/api/publishing/
            NSString *message = [NSString stringWithFormat:@"Post on %@", [NSDate date]];
            NSDictionary *parameters = @{@"message": message,
                                       @"picture" : @"http://commentsapp.co/wp-content/uploads/2012/12/icon_128x128.png",
                                       @"link" : @"http://commentsapp.co"
                                       ,@"name" : @"name?"
                                       ,@"caption": @"caption?"
                                       ,@"description": @"description here"
                                       ,@"source" : @"http://diskalarm.com" // Unsure where that appears in the wall...... anyone?
            //                                       ,@"place" : @"Irgendwo (Place!)" // Didn't checked how it works
            //                                       ,@"tags" : @"Tag Tag TigidiTag!" // Probably a user ID but I don't need it personally ;-)
                                       };

            NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];

            SLRequest *feedRequest = [SLRequest
                                    requestForServiceType:SLServiceTypeFacebook
                                    requestMethod:SLRequestMethodPOST
                                    URL:feedURL
                                    parameters:parameters];

            feedRequest.account = facebookAccount;
            [feedRequest performRequestWithHandler:^(NSData *responseData,
                                                   NSHTTPURLResponse *urlResponse, NSError *error) {
               NSLog(@"error: %@\nurlResponse: %@", error, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            }];
        } else {
          switch (e.code) {
              case 6:
                  NSLog(@"Please setup a Facebook account from the settings");
                  break;
                  
              default:
                  break;
          }
        }
    }];
}

@end
