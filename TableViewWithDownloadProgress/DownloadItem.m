//
//  DownloadItem.m
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import "DownloadItem.h"

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
    _request = [STHTTPRequest requestWithURLString:_strFileDownloadURL];
    
    //completion data block
    _request.completionDataBlock = ^(NSDictionary *headers, NSData *downloadedData)
    {
        // Completion Block
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        if (downloadedData)
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
        
    };
    
    //download progress
    _request.downloadProgressBlock = ^(NSData *dataJustReceived, int64_t totalBytesReceived, int64_t totalBytesExpectedToReceive)
    {
        // notify user of download progress
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        
        NSString *strCurFileSize = [NSString stringWithFormat:@"%f",(float)totalBytesExpectedToReceive];
        self.strFileSize = [self transformedValue:strCurFileSize];
        
        _progress = (float)totalBytesReceived / totalBytesExpectedToReceive;
        NSLog(@"%f",_progress);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate)
                [_delegate didUpdateProgress:_progress];
        });
        
#pragma clang diagnostic pop
        
    };
    
    //error block
    _request.errorBlock = ^(NSError *error) {
        // error
        NSLog(@"%@",[error description]);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        
        //Un Completed
        dispatch_async(dispatch_get_main_queue(), ^{
            _downloading = NO;
            _downloaded = NO;
            
            _progress = 0.f;
            
            if (_delegate)
            {
                [_delegate didUpdateProgress:_progress];
                [_delegate didFailDownload];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStatusNotification" object:[NSDictionary dictionaryWithObjectsAndKeys:self,@"DownloadItem",nil]];
        });
        
#pragma clang diagnostic pop
        
    };
    
    //start request
    [_request startAsynchronous];
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

-(NSString *)transformedValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

@end
