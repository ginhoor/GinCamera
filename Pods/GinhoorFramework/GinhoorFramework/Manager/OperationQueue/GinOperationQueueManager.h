//
//  GinOperationQueueManager.h
//  demo4Queue
//
//  Created by JunhuaShao on 2018/7/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GinOperationQueueManager : NSObject

/**
 串行队列
 
 @param dataList 数据源
 @param opreationBlock 运行回调
 @param cancelBlock 中断回调，设置为nil时，则不进行中断检测
 @param completionBlock 完成回调
 @return 线程队列
 */
+ (NSOperationQueue *)startOperationOnSerialQueue:(NSArray *)dataList
                     opreationBlock:(void(^)(id data, NSOperationQueue *queue, NSInteger index, double totalProgress))opreationBlock
                        cancelBlock:(BOOL(^)(id data, NSInteger index))cancelBlock
                    completionBlock:(void(^)(BOOL success))completionBlock;

@end

/** 具体实现参考
 
    NSMutableArray *imageKeys = [NSMutableArray array];
    __block NSString *lastResultKey = nil;
    [GinOperationQueueManager startOperationOnSerialQueue:imageList opreationBlock:^(id data, NSOperationQueue *queue, NSInteger index, double totalProgress) {
        // 这里挂起队列
        queue.suspended = YES;
        [self uploadSingleImage:data filename:[CEQiNiuManager createJPGImageKey] progress:nil completion:^(QNResponseInfo *info, NSString *key, NSDictionary *resp, UIImage *image) {
            lastResultKey = key;
            if (!key) {
                if (completion) {
                    completion(NO, nil);
                }
            } else {
                if (progress) {
                    progress(key, totalProgress ,index);
                }
                [imageKeys addObject:key];
            }
            //执行完成后继续队列
            queue.suspended = NO;
        }];
    } cancelBlock:^BOOL(id data, NSInteger index) {
        return ![lastResultKey isNotBlank] && index != 0;
    } completionBlock:^(BOOL success) {
        if (completion) {
            completion(success, imageKeys.count!=0?imageKeys:nil);
        }
    }];
 */
