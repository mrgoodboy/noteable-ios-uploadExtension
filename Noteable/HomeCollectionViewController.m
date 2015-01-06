//
//  HomeCollectionViewController.m
//  Noteable
//
//  Created by Minh Tri Pham on 1/6/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "NoteableConfig.h"
#import "FileCollectionViewCell.h"
#import "NoteableFile.h"
#import "NoteableTheme.h"

@interface HomeCollectionViewController ()

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *files;
@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupController];
  
  
  // Register cell classes
  [self.collectionView registerNib:[UINib nibWithNibName:@"FileCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"fileCell"];
  NSLog(@"config dict: %@", self.config);
  [self fetchFiles];
  
  
  self.collectionView.alwaysBounceVertical = YES;
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(startRefresh:)
           forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:refreshControl];
  self.refreshControl = refreshControl;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [self.collectionView reloadData];
}

- (void)setupController {
  self.title = @"My Documents";
}

- (void)startRefresh:(id)sender {
  if (!self.isRefreshing) {
    [self fetchFiles];
  }
}

- (void)fetchFiles {
  self.isRefreshing = YES;
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  NSDictionary *params = @{
                           @"token" : self.config[@"token"]
                           };
  NSString *url = [NSString stringWithFormat:@"%@/iphone/files", BASE_URL];
  [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    if (responseObject && [responseObject[@"success"] boolValue]) {
      NSMutableArray *array = [NSMutableArray array];
      NSArray *result = responseObject[@"results"];
      for (NSDictionary *fileDict in result) {
        NoteableFile *file = [[NoteableFile alloc] init];
        file.fileName = fileDict[@"name"];
        file.downloadUrl = fileDict[@"url"];
        [array addObject:file];
      }
      self.files = [[array reverseObjectEnumerator] allObjects];
      [self.collectionView reloadData];
    }
    
    self.isRefreshing = NO;
    [self.refreshControl endRefreshing];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    self.isRefreshing = NO;
    [self.refreshControl endRefreshing];
    NSLog(@"Error: %@", error);
  }];
}


- (IBAction)tappedUserButton:(id)sender {
  [[[UIAlertView alloc] initWithTitle:@"Logout?" message:@"Would you like to log out of your current account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.cancelButtonIndex != buttonIndex) {
    // log out
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"loginModal" sender:@(YES)];
  }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.files count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fileCell" forIndexPath:indexPath];
  [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
  NoteableFile *file = [self.files objectAtIndex:indexPath.row];
  
  [cell configureForFile:file];
  
  
  // Configure the cell
  
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(300.0, 160.0);
  
}
#pragma mark <UICollectionViewDelegate>


@end
