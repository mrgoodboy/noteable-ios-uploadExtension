//
//  ShareViewController.m
//  Noteable-DocumentUpload
//
//  Created by Minh Tri Pham on 1/3/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import "ShareViewController.h"
#import "NoteableConfig.h"
#import "AFNetworking/AFNetworking.h"

@interface ShareViewController ()
@property (nonatomic, strong)UIProgressView *progressView;

@property NSString *token;  //auth token from the container app

@end

@implementation ShareViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  
  self.title = @"Noteable";
  self.placeholder = @"Document Name";
  self.navigationItem.rightBarButtonItem.title = @"Upload";
  
  //get the auth token
  NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                initWithSuiteName:GROUP_ID];
  self.token = [myDefaults objectForKey:@"token"];
  if (self.token)
    NSLog(@"token is %@", self.token);
  else
    NSLog(@"no token, must login first");
}

- (BOOL)isContentValid {
  // Do validation of contentText and/or NSExtensionContext attachments here
  return YES;
}

- (void)didSelectPost {
  
  // Verify that we have a valid NSExtensionItem
  NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
  if(!imageItem){
    return;
  }
  
  // Verify that we have a valid NSItemProvider
  NSItemProvider *imageItemProvider = [[imageItem attachments] firstObject];
  if(!imageItemProvider){
    return;
  }
  
  // Look for an image inside the NSItemProvider
  if([imageItemProvider hasItemConformingToTypeIdentifier:@"public.jpeg"]) {
    [imageItemProvider loadItemForTypeIdentifier:@"public.jpeg" options:nil completionHandler:^(UIImage *image, NSError *error) {
      
      if(image) {
        
        NSString *title = self.title;
        
        NSLog(@"title %@", title);
        NSLog(@"description %@", self.textView.text);
        NSLog(@"image %@", image);
        
        [self uploadImage:image withFilename:self.textView.text];
      }
    }];
  }
  
  
}

- (void)addProgressView {
  //   4. Set the progress block of the operation.
  
  self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
  self.progressView.center = self.view.center;
  [self.view addSubview:self.progressView];
}

- (void)uploadImage:(UIImage *)image withFilename:(NSString *)filename {
  NSParameterAssert(image);
  NSParameterAssert(filename);
  
  NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
  
  NSDictionary *params = @{ @"token":self.token, @"filename":filename };
  NSString *path = [NSString stringWithFormat:@"%@/notes/iphone-upload", BASE_URL];
  
  // 1. Create `AFHTTPRequestSerializer` which will create your request.
  AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
  
  // 2. Create an `NSMutableURLRequest`.
  NSMutableURLRequest *request =
  [serializer multipartFormRequestWithMethod:@"POST" URLString:path
                                  parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                     [formData appendPartWithFileData:imageData
                                                 name:@"photo"
                                             fileName:@"photo"
                                             mimeType:@"image/jpeg"];
                   } error:nil];

  
  // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  AFHTTPRequestOperation *operation =
  [manager HTTPRequestOperationWithRequest:request
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Success %@", responseObject);
                                     [self finishUpload];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Failure %@", error.description);
                                     [self.progressView removeFromSuperview];
                                     [self finishUpload];
                                   }];
  
  [self addProgressView];
  
  [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                      long long totalBytesWritten,
                                      long long totalBytesExpectedToWrite) {
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"Progress:%f", progress);
    [self updateProgress:progress];
    self.progressView.alpha = 1;
    if (progress == 1) {
      [self.progressView removeFromSuperview];
    }
  }];
  
//  5. Begin!
  [operation start];
  
}

- (void)finishUpload {
//  [self.progressView removeFromSuperview];
  [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (void)updateProgress:(double)progress {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.progressView.progress = progress;
  });
}

- (NSArray *)configurationItems {
  // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
  return @[];
}

@end
