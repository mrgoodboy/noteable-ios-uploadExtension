//
//  NotableFile.h
//  Noteable
//
//  Created by Micah Rosales on 9/14/14.
//  Copyright (c) 2014 Micah Rosales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotableFile : NSObject

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *identifier;

@end
