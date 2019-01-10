//
//  DemoPhotoCollectionViewController.m
//  GinCameraCaptureManager
//
//  Created by JunhuaShao on 2019/1/7.
//  Copyright © 2019 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <BlocksKit.h>
#import "GinMediaManager.h"
#import "DemoPhotoCell.h"
#import "GinPhotoQueueCaptureViewController+Router.h"

#import "DemoPhotoCollectionViewController.h"

@interface DemoPhotoCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) GinPhotoQueueCaptureViewController *queueCaptureVC;
@property (strong, nonatomic) NSArray <GinCapturePhoto *> *photoList;
@property (strong, nonatomic) NSArray <GinCapturePhotoEnum *> *indexList;

@end

@implementation DemoPhotoCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSource];
    
    [self.view addSubview:self.collectionView];
    
    [self setupCaptureVC];
}

- (void)setupSource
{
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        GinCapturePhotoEnum *photoEnum = [[GinCapturePhotoEnum alloc] init];
        
        if (i < 5) {
            photoEnum.category = GinCapturePhotoCategoryNormal;
        } else {
            photoEnum.category = GinCapturePhotoCategoryUnlimited;
        }
        photoEnum.num = i;
        photoEnum.key = [NSString stringWithFormat:@"key%ld",i];
        photoEnum.displayName = [NSString stringWithFormat:@"第%ld张",i+1];
        photoEnum.sampleUrl = @"https://www.baidu.com/img/bd_logo1.png?qua=high&where=super";
        photoEnum.viewUrl = @"https://www.baidu.com";
        [mArr addObject:photoEnum];
    }
    
    self.indexList = mArr;
}

- (void)setupCaptureVC
{
    self.queueCaptureVC = [GinPhotoQueueCaptureViewController VCWithPhotoList:self.photoList photoIndexQueue:self.indexList didPhotoCaptureListChangedBlock:^(GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull item, GinMediaEditType option) {
        ;
    } didPhotoCapturedBlock:^(NSString * _Nonnull localPhotoFileName, GinCapturePhoto * _Nonnull photo, GinCapturePhotoEnum * _Nonnull photoIndex, NSInteger indexInPhotoList) {
        ;
    } didStopCapturingBlock:^(GinCapturePhotoEnum * _Nonnull photoIndex, BOOL isCaturingFinished) {
        ;
    } canDeletePhotoBlock:^BOOL{
        return YES;
    }];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.offset(0);
        make.right.offset(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.offset(0);
        }
    }];
}


#pragma mark- Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.indexList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DemoPhotoCell class]) forIndexPath:indexPath];
    
    GinCapturePhotoEnum *photoIndex = self.indexList[indexPath.row];
    cell.titleLabel.text = photoIndex.displayName;
    
    GinCapturePhoto *photo = [self.photoList bk_match:^BOOL(GinCapturePhoto *obj) {
        return obj.photoEnumNum == photoIndex.num;
    }];
    
    if (photo) {
        cell.photoImgV.image = [GinMediaManager getImageByName:photo.localFilename];
    } else {
        cell.photoImgV.image = nil;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.queueCaptureVC.viewModel.currentPhotoIndex = self.queueCaptureVC.viewModel.photoIndexQueue.firstObject;
    
    [self.queueCaptureVC presentPhotoCapture:self];

}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.itemSize = [DemoPhotoCell cellSize];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[DemoPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([DemoPhotoCell class])];
    }
    return _collectionView;
}


@end
