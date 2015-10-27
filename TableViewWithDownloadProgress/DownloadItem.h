//
//  DownloadItem.h
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHTTPRequest.h"

@protocol ItemDownloadDelegate <NSObject>

-(void)didStartDownloading;
-(void)didUpdateProgress:(CGFloat)progress;
-(void)didFinishDownload;
-(void)didFailDownload;
-(void)didHaveToWaitDownload;

@end

@interface DownloadItem : NSObject

@property (nonatomic, strong) NSString *strFileName;
@property (nonatomic, strong) NSString *strFileCreatedDate;
@property (nonatomic, strong) NSString *strFileSize;
@property (nonatomic, strong) NSString *strFileDownloadURL;
@property (nonatomic, strong) NSURL *fileDownloadedPathURL;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) STHTTPRequest *request;
@property (nonatomic, strong) id<ItemDownloadDelegate> delegate;

- (BOOL)isDownloading;
- (BOOL)isDownloaded;
- (BOOL)isDownloadedQueued;
- (CGFloat)progress;

- (void)downloadItem;
-(void)waitDownloadItem;
-(void)startDownloadItem;
@end
