//
//  GinCapturePhoto.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/4.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <NSString+GinUnit.h>

#import "GinCapturePhoto.h"

@implementation GinCapturePhoto

+ (instancetype)photo:(GinCapturePhotoEnum *)index
{
    GinCapturePhoto *photo = [[GinCapturePhoto alloc] init];
    
    photo.photoEnumNum = index.num;
    return photo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.option = GinMediaEditTypeCreate;
}

- (NSString *)fetchPhotoUrl
{
    if ([self.editedPhotoUrl isNotBlank]) {
        return self.editedPhotoUrl;
    } else if ([self.photoUrl isNotBlank]) {
        return self.photoUrl;
    } return nil;
}

- (NSString *)fetchLocalFilename
{
    if ([self.editedLocalFilename isNotBlank]) {
        return self.editedLocalFilename;
    } else if ([self.localFilename isNotBlank]) {
        return self.localFilename;
    } else {
        return nil;
    }
}

-  (BOOL)hasEditedPhoto
{
    return [self.editedPhotoUrl isNotBlank] || [self.editedLocalFilename isNotBlank];
}

@end
