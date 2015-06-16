//
//  DownloadItem.m
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import "DownloadItem.h"
#import "AFNetworking.h"


@implementation DownloadItem {
    BOOL _downloaded;
    BOOL _downloading;
    BOOL _downloadedQueued;
    CGFloat _progress;
}

- (id)init {
    self = [super init];
    if (self) {
        _downloaded = NO;
        _downloading = NO;
        _downloadedQueued = NO;
        _progress = 0.0;
    }
    
    return self;
}

- (BOOL)isDownloaded
{
    return _downloaded;
}

- (BOOL)isDownloading {
    return _downloading;
}

- (BOOL)isDownloadedQueued
{
    return _downloadedQueued;
}

- (CGFloat)progress {
    return _progress;
}

-(void)downloadItem
{
    _downloadedQueued = NO;
    _downloading = YES;
    // Simulate network activity
    if (_delegate) {
        [_delegate didStartDownloading];
    }
    
    //Downlaod File
    NSURL *fileURL = [NSURL URLWithString:_strFileDownloadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        [_fileDownloadedPathURL setResourceValue: [NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
        return _fileDownloadedPathURL;
    }
    completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
    {
        NSLog(@"File downloaded to: %@", filePath);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        if (!error)
        {
            // Completed
            dispatch_async(dispatch_get_main_queue(), ^{
                _downloading = NO;
                _downloaded = YES;
            
                if (_delegate)
                    [_delegate didFinishDownload];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStatusNotification" object:[NSDictionary dictionaryWithObjectsAndKeys:self,@"DownloadItem",nil]];
            });
        }
        else
        {
            //Un Completed
            dispatch_async(dispatch_get_main_queue(), ^{
                _downloading = NO;
                _downloaded = NO;
                
                if (_delegate)
                    [_delegate didFailDownload];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStatusNotification" object:[NSDictionary dictionaryWithObjectsAndKeys:self,@"DownloadItem",nil]];
            });
        }

#pragma clang diagnostic pop

    }];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"

         _progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
         NSLog(@"%f",_progress);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_delegate)
                 [_delegate didUpdateProgress:_progress];
             
             if (_delegate)
                 [_delegate gotFileSize:[NSString stringWithFormat:@"%f",(float)totalBytesExpectedToWrite]];
             
         });
         
#pragma clang diagnostic pop
         
     }];
    
    [_downloadTask resume];
}

-(void)waitDownloadItem
{
    _downloadedQueued = YES;
    _downloading = NO;
    // Simulate UI
    if (_delegate)
    {
        _progress = 0.000000000001;
        [_delegate didHaveToWaitDownload];
    }
}

-(void)startDownloadItem
{
    _downloadedQueued =  NO;
    _downloading = YES;
    // Simulate network activity
    if (_delegate) {
        [_delegate didStartDownloading];
    }
    
    [_downloadTask resume];
}

@end
