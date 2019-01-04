//
//  NSObject+SetterAndGetter.h
//  FrameworkDemo
//
//  Created by JunhuaShao on 15/4/16.
//  Copyright (c) 2015年 JunhuaShao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (GinSetterAndGetter)

- (void)setValue:(id)value key:(NSString *)key policy:(NSInteger)policy owner:(id)owner;

- (id)getValueForKey:(NSString *)key;

@end
