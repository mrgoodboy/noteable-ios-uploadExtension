//
//  LoginViewController.m
//  Noteable
//
//  Created by Minh Tri Pham on 1/3/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "NoteableConfig.h"
#import "HomeCollectionViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) NSMutableDictionary *config;


@end

@implementation LoginViewController

- (NSMutableDictionary *)config {
  if (!_config) {
    _config = [[NSMutableDictionary alloc] init];
  }
  return _config;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.passwordField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)startLogin {
  
  NSString *string = [NSString stringWithFormat:@"%@/iphone-login", BASE_URL];
  NSDictionary *params = @ {
    @"email" :self.emailField.text,
    @"password" :self.passwordField.text
  };
  [self.config setObject:self.emailField.text forKey:@"email"];
  
  NSLog(@"Attempting to log in");
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager POST:string parameters:params
        success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
   {
     if (responseObject && [responseObject[@"success"] boolValue]) {
       NSLog(@"Login success!");
       [self saveLoginInfo:responseObject];
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
                                    initWithSuiteName:GROUP_ID];
      [myDefaults setObject:token forKey:@"token"];
      [myDefaults synchronize];
      [self.config setObject:token forKey:@"token"];
    }
    NSString *name = info[@"name"];
    if (name) {
      [self.config setObject:name forKey:@"name"];
    }
    
    NSLog(@"Saved info, name: %@, token: %@", self.config[@"name"], self.config[@"token"]);
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"Login"]) {
    UINavigationController *navController = segue.destinationViewController;
    HomeCollectionViewController *home = [navController.viewControllers objectAtIndex:0];
    home.config = self.config;
  }
}

@end
