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
   _lblFileSize.text = [self transformedValue:strFileSize];
}

- (void)setupUI
{
    //_progressView.hidden = ![_item isDownloading];
    _progressView.progress = _item.progress;
    
    if ([_item isDownloading])
    {
        if (_item.progress == 0)
            [_progressView startSpinProgressBackgroundLayer];
        else if (_item.progress > 0)
            [_progressView stopSpinProgressBackgroundLayer];
            
        _lblFileName.text = [NSString stringWithFormat:@"%@", _item.strFileName];
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
    }
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

#pragma mark - gesture methods

- (void)tapGestureSelector:(UITapGestureRecognizer *)recognizer
{
    if (_item.isDownloading)
    {
        //NSLog(@"%@",_item.downloadTask);
        if(_item.downloadTask.state == NSURLSessionTaskStateRunning)
        {
            [_item.downloadTask suspend];
        }
        else if(_item.downloadTask.state == NSURLSessionTaskStateSuspended)
        {
            [_item.downloadTask resume];
        }
    }
}


@end
