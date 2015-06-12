//
//  DownloadItem.h
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemDownloadDelegate <NSObject>

- (void)didStartDownloading;
- (void)gotFileSize:(NSString *)strFileSize;
- (void)didUpdateProgress:(CGFloat)progress;
- (void)didFinishDownload;
- (void)didFailDownload;

@end

@interface DownloadItem : NSObject

@property (nonatomic, strong) NSString *strFileName;
@property (nonatomic, strong) NSString *strFileCreatedDate;
@property (nonatomic, strong) NSString *strFileSize;
@property (nonatomic, strong) NSString *strFileDownloadURL;
@property (nonatomic, strong) NSURL *fileDownloadedPathURL;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) id<ItemDownloadDelegate> delegate;

- (void)downloadItem;
- (BOOL)isDownloading;
- (BOOL)isDownloaded;
- (CGFloat)progress;

@end
