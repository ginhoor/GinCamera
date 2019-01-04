//
//  GinVideoCaptureViewModel.h
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GinVideoCaptureItem.h"
#import "GinMediaManager.h"

@interface GinVideoCaptureViewModel : NSObject

@property (strong, nonatomic) NSArray <GinVideoCaptureItem *> *videoItemList;

@property (copy, nonatomic) void(^getVehicleVideoBlock) (NSString *videoFilename);

- (void)addVideoFile:(NSString *)videoFilePath;
- (void)removePreviousVideoFile;
- (void)removeVideoFile:(NSString *)videoFilePath;

@end
