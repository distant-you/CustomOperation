//
//  ZZDownloadOperation.m
//  CustomOperation
//
//  Created by 开发所用，一般人别用 on 2019/8/27.
//  Copyright © 2019年 CK. All rights reserved.
//

#import "ZZDownloadOperation.h"

@implementation ZZDownloadOperation

- (void)main
{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(downloadOperation:didDownloadWithImage:)]) {
                [self.delegate downloadOperation:self didDownloadWithImage:[UIImage imageWithData:data]];
            }
        });
}

@end
