//
//  HomeCollectionViewController.h
//  Noteable
//
//  Created by Minh Tri Pham on 1/6/15.
//  Copyright (c) 2015 Noteable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSDictionary *config;
@end
