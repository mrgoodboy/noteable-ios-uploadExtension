//
//  FileDetailViewController.m
//  Noteable
//
//  Created by Micah Rosales on 9/14/14.
//  Copyright (c) 2014 Micah Rosales. All rights reserved.
//

#import "FileDetailViewController.h"
#import "NotableFile.h"
@interface FileDetailViewController ()
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NotableFile *file;
@end

@implementation FileDetailViewController

- (void)configureForFile:(NotableFile *)file {
    self.file = file;
    self.title = file.filename;
    [self loadURL:file.downloadUrl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.webView];
    }
    // Do any additional setup after loading the view.
}

- (void)loadURL:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadURL:self.file.downloadUrl];

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
