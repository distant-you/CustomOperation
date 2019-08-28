//
//  ZZDownloadOperation.h
//  CustomOperation
//
//  Created by 开发所用，一般人别用 on 2019/8/27.
//  Copyright © 2019年 CK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZDownloadOperation;

NS_ASSUME_NONNULL_BEGIN

@protocol ZZDownloadOperationDelegate <NSObject>

- (void)downloadOperation:(ZZDownloadOperation *)opration didDownloadWithImage:(UIImage *)image;

@end

@interface ZZDownloadOperation : NSOperation

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<ZZDownloadOperationDelegate> delegate;

@property (nonatomic, copy) NSString *url;


@end

NS_ASSUME_NONNULL_END
