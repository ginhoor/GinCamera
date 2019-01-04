//
//  UIView+CGRect.m
//  Ginhoor
//
//  Created by Ginhoor on 14-3-19.
//  Copyright (c) 2014年 zhitech. All rights reserved.
//

#import "UIView+GinCGRect.h"

@implementation UIView (GinCGRect)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

@end
