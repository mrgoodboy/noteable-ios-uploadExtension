//
//  FileDetailViewController.h
//  Noteable
//
//  Created by Micah Rosales on 9/14/14.
//  Copyright (c) 2014 Micah Rosales. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotableFile;
@interface FileDetailViewController : UIViewController

- (void)configureForFile:(NotableFile *)file;

@end
