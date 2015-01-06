  //
//  FileCollectionViewCell.h
//  Noteable
//
//  Created by Minh Tri Pham on 1/6/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteableFile.h"

@interface FileCollectionViewCell : UICollectionViewCell

- (void)configureForFile:(NoteableFile *)file;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
