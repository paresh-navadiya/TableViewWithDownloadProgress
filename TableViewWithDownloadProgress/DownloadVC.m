//
//  DownloadVC.m
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadItem.h"
#import "DownloadItemTableViewCell.h"

@interface DownloadVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DownloadVC {
    NSMutableArray *_items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _items = [NSMutableArray array];
    
    self.title = @"Download List";
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    
    for (int i = 0; i < 50; i++) {
        DownloadItem *item = [[DownloadItem alloc] init];
        item.strFileName = [NSString stringWithFormat:@"sample_iTunes.mov.zip %d", i];
        item.strFileSize = @"-.-";
        item.strFileCreatedDate = @"2015-06-11";
        item.strFileDownloadURL = @"http://a1408.g.akamai.net/5/1408/1388/2005110403/1a1a1ad948be278cff2d96046ad90768d848b41947aa1986/sample_iTunes.mov.zip";
        
       
        NSURL *filePathURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"sample_iTunes.mov_%d.zip",i]];
        item.fileDownloadedPathURL = filePathURL;
        [_items addObject:item];
    }
}

-(void)dealloc
{
    NSLog(@"%@ is being deallocated",NSStringFromClass([self class]));
}

#pragma mark - 
#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadItemTableViewCell *cell = (DownloadItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemTableCell"];
    
    DownloadItem *item = [_items objectAtIndex:indexPath.row];
    [cell setItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DownloadItem *item = [_items objectAtIndex:indexPath.row];
    if (![item isDownloading] && ![item isDownloaded]) {
        [item downloadItem];
    }
}

@end
