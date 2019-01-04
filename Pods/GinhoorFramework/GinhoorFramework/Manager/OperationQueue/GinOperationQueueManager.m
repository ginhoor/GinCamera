//
//  GinOperationQueueManager.m
//  demo4Queue
//
//  Created by JunhuaShao on 2018/7/23.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import "GinOperationQueueManager.h"

@implementation GinOperationQueueManager

+ (NSOperationQueue *)startOperationOnSerialQueue:(NSArray *)dataList
                     opreationBlock:(void(^)(id data, NSOperationQueue *queue, NSInteger index, double totalProgress))opreationBlock
                        cancelBlock:(BOOL(^)(id data, NSInteger index))cancelBlock
                    completionBlock:(void(^)(BOOL success))completionBlock
{
    // 创建一个线程队列，最大并发数为1
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    // 根据数据源创建Operation
    __block NSBlockOperation *lastBlockOperation;
    [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            // 如果设置了中断回调，优先检测中断回调是否触发
            if (cancelBlock) {
                BOOL cancelFlag = cancelBlock(obj,idx);
                //如果中断了
                if (cancelFlag) {
                    //取消所有线程
                    [queue cancelAllOperations];
                    // 触发一次完成回调
                    [queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                        if (completionBlock) {
                            completionBlock(NO);
                        }
                    }]];
                } else {
                    if (opreationBlock) {
                        opreationBlock(obj, queue, idx, idx*1.0f/dataList.count);
                    }
                }
            } else {
                if (opreationBlock) {
                    opreationBlock(obj, queue, idx, idx*1.0f/dataList.count);
                }
            }
        }];
        
        // 将当前线程设置为上一次线程的依赖，保证运行顺序
        if (lastBlockOperation) {
            [blockOperation addDependency:lastBlockOperation];
        }
        lastBlockOperation = blockOperation;
        [queue addOperation:blockOperation];
        if (idx == dataList.count-1) {
            //当最后一个线程运行完毕后，触发完成回调
            NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
                if (completionBlock) {
                    completionBlock(YES);
                }
            }];
            [completionOperation addDependency:blockOperation];
            [queue addOperation:completionOperation];
        }
    }];
    
    return queue;
}

@end
