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
}

#pragma mark -
#pragma mark - ItemDownloadDelegate

-(void)didStartDownloading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.btnStatus.hidden = NO;
        self.btnStatus.selected = NO;
        [self.btnStatus setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        
        [self setupUI];
    });
}

-(void)didUpdateProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

-(void)didFinishDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

-(void)didFailDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.btnStatus.selected = YES;
        [self.btnStatus setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        
        [self setupUI];
    });
}

-(void)didHaveToWaitDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}

#pragma mark -
#pragma mark - Methods
- (void)setupUI
{
    _lblFileName.textColor = [UIColor blackColor];
    _lblFileName.text = _item.strFileName;
    _lblFileCreated.text = _item.strFileCreatedDate;
    _lblFileSize.text = _item.strFileSize;
    
    if (_item.progress>0)
    {
        
        if (_item.progress == 1.0)
        {
            self.btnStatus.hidden = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                CGFloat width = 0;
                CGRect rect = self.lblProgress.frame;
                rect.size.width = width;
                [self.lblProgress setFrame:rect];
            }];
        }
        else
        {
            self.btnStatus.hidden = NO;
            
            [UIView animateWithDuration:0.1 animations:^{
                CGFloat width = (self.contentView.frame.size.width*_item.progress)/1.f;
                CGRect rect = self.lblProgress.frame;
                rect.size.width = width;
                [self.lblProgress setFrame:rect];
            }];
        }
    }
    else
    {
        self.btnStatus.hidden = YES;
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = self.lblProgress.frame;
            rect.size.width = 0;
            [self.lblProgress setFrame:rect];
        }];
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

#pragma mark -
#pragma mark - Action Method

-(IBAction)btnStatusAction:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.btnStatus.selected)
        {
            [self.btnStatus setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [self.item.request cancel];
        }
        else
        {
            [self.btnStatus setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            [self.item downloadItem];
        }
        
        self.btnStatus.selected = !self.btnStatus.selected;
        
    });
}

#pragma mark -
#pragma mark - gesture methods

//- (void)tapGestureSelector:(UITapGestureRecognizer *)recognizer
//{
//    if (_item.isDownloading)
//    {
//        //NSLog(@"%@",_item.downloadTask);
//        if([_item.request downloadStatus] == NSURLSessionTaskStateRunning)
//        {
//            //[_progressView downloadPaused];
//            
//            [_item.request pause];
//        }
//        else if([_item.request downloadStatus] == NSURLSessionTaskStateSuspended)
//        {
//            //[_progressView downloadStarted];
//            
//            [_item.request resume];
//        }
//    }
//}


@end
