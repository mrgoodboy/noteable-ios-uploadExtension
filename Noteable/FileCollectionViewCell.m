//
//  FileCollectionViewCell.m
//  Noteable
//
//  Created by Minh Tri Pham on 1/6/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import "FileCollectionViewCell.h"

@implementation FileCollectionViewCell



- (void)configureForFile:(NoteableFile *)file {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.titleLabel setText:file.fileName];
  });
}

@end
