//
//  GinVideoCaptureItem.h
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GinVideoCaptureItem : NSObject

@property (strong, nonatomic) NSString *filePath;
@property (assign, nonatomic) NSTimeInterval duration;

@end
