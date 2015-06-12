//
//  DownloadItemTableViewCell.h
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadItem.h"
#import "FFCircularProgressView.h"

@interface DownloadItemTableViewCell : UITableViewCell
//{
//    IBOutlet UILabel *lblFileName;
//    IBOutlet UILabel *lblFileCreated;
//    IBOutlet UILabel *lblFileSize;
//    IBOutlet FFCircularProgressView *progressView;
//}
@property (strong, nonatomic) IBOutlet UILabel *lblFileName;
@property (strong, nonatomic) IBOutlet UILabel *lblFileCreated;
@property (strong, nonatomic) IBOutlet UILabel *lblFileSize;
@property (strong, nonatomic) IBOutlet FFCircularProgressView *progressView;

@property (nonatomic, strong) DownloadItem *item;
@end
