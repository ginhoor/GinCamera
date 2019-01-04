//
//  GinVideoCaptureViewModel.m
//  demo4CaptureVideo
//
//  Created by JunhuaShao on 2018/2/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//
#import <NSString+GinUnit.h>
#import <BlocksKit.h>

#import "GinVideoCaptureViewModel.h"

@implementation GinVideoCaptureViewModel

- (void)addVideoFile:(NSString *)videoFilePath
{
    GinVideoCaptureItem *item = [self.videoItemList bk_match:^BOOL(GinVideoCaptureItem *obj) {
        return [obj.filePath isEqualToString:videoFilePath];
    }];
    
    if (!item) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.videoItemList];
        item = [[GinVideoCaptureItem alloc] init];
        item.filePath = videoFilePath;
        [tempArr addObject:item];
        self.videoItemList = tempArr;
    }
}

- (void)removePreviousVideoFile
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.videoItemList];
    [tempArr removeObject:self.videoItemList.lastObject];
    self.videoItemList = tempArr;
}

- (void)removeVideoFile:(NSString *)videoFilePath
{
    GinVideoCaptureItem *item = [self.videoItemList bk_match:^BOOL(GinVideoCaptureItem *obj) {
        return [obj.filePath isEqualToString:videoFilePath];
    }];
    
    if (item) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.videoItemList];
        [tempArr removeObject:item];
        self.videoItemList = tempArr;
    }
}

@end
