//
//  LoginViewController.m
//  Noteable
//
//  Created by Minh Tri Pham on 1/3/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking/AFNetworking.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) UITextField *activeTextField;


@end

@implementation LoginViewController

//#define BASE_URL @"http://noteable.com"
#define BASE_URL @"http://4302a100.ngrok.com"

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLogin {
  
  NSString *string = [NSString stringWithFormat:@"%@/iphone-login", BASE_URL];
  NSDictionary *params = @ {
    @"username" :self.usernameField.text,
    @"password" :self.passwordField.text
  };
  NSLog(@"Attempting to log in");
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager POST:string parameters:params
        success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
   {
     if (responseObject && [responseObject[@"success"] boolValue]) {
       NSLog(@"Login success!");
       [self saveLoginInfo:responseObject];
       NSLog(@"Saved login info: %@", [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.noteable.app"] objectForKey:@"token"]);
       [self performSegueWithIdentifier:@"Login" sender:self];
     } else {
       NSLog(@"Login failed with code %@", responseObject[@"code"]);
     }     }
        failure:
   ^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Login Error: %@", error);
   }];
}

- (IBAction)loginAction:(id)sender {
  [self startLogin];
}

- (void)saveLoginInfo:(NSDictionary *)info {
  if (info && [info[@"success"] boolValue]) {
    NSString *token = info[@"token"];
    if (token) {
      NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"group.com.noteable.app"];
      [myDefaults setObject:token forKey:@"token"];
      [myDefaults synchronize];
    }
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
  self.activeTextField = textField;
  [self.view layoutIfNeeded];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.activeTextField = nil;
  
  [self.view layoutIfNeeded];
}
- (IBAction)backgroundTapped:(id)sender {
  [self.activeTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
