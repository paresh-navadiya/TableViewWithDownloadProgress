//
//  DownloadItemTableViewCell.m
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import "DownloadItemTableViewCell.h"

@interface DownloadItemTableViewCell () <ItemDownloadDelegate>

@end

@implementation DownloadItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector:)];
    [_progressView addGestureRecognizer:tapGesture];
}

#pragma mark -
#pragma mark - ItemDownloadDelegate

- (void)didStartDownloading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

- (void)didUpdateProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

- (void)didFinishDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

- (void)didFailDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

- (void)gotFileSize:(NSString *)strFileSize
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _lblFileSize.text = [self transformedValue:strFileSize];
    });
   
}

-(void)didHaveToWaitDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _progressView.progress = _item.progress;
        [_progressView downloadPaused];
    });
}

#pragma mark -
#pragma mark - Methods
- (void)setupUI
{
    if ([_item isDownloading])
    {
        if (_item.progress == 0)
            [_progressView startSpinProgressBackgroundLayer];
        else if (_item.progress > 0)
            [_progressView stopSpinProgressBackgroundLayer];
            
        _lblFileName.text = [NSString stringWithFormat:@"%@", _item.strFileName];
        
        _progressView.isDownloadPaused = NO;
    }
    else if ([_item isDownloaded])
    {
        _lblFileName.text = [NSString stringWithFormat:@"%@", _item.strFileName];
    }
    else
    {
        // Not downloaded, not downloading (initial state)
        _lblFileName.textColor = [UIColor blackColor];
        _lblFileName.text = _item.strFileName;
        _lblFileCreated.text = _item.strFileCreatedDate;
        _lblFileSize.text = _item.strFileSize;
        
        if ([_item isDownloadedQueued])
        {
            _progressView.isDownloadPaused = YES;
        }
    }
    
    _progressView.progress = _item.progress;

}

- (void)setItem:(DownloadItem *)item {
    _item = item;
    _item.delegate = self;
    [self setupUI];
}

- (void)prepareForReuse {
    _item.delegate = nil;
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

#pragma mark -
#pragma mark - gesture methods

- (void)tapGestureSelector:(UITapGestureRecognizer *)recognizer
{
    if (_item.isDownloading)
    {
        //NSLog(@"%@",_item.downloadTask);
        if(_item.downloadTask.state == NSURLSessionTaskStateRunning)
        {
            [_progressView downloadPaused];
            
            [_item.downloadTask suspend];
        }
        else if(_item.downloadTask.state == NSURLSessionTaskStateSuspended)
        {
            [_progressView downloadStarted];
            
            [_item.downloadTask resume];
        }
    }
}


@end
