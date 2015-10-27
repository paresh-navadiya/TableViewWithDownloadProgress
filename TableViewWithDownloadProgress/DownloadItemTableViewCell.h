//
//  DownloadItemTableViewCell.h
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadItem.h"

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
@property (strong, nonatomic) IBOutlet UILabel *lblProgress;
@property (strong, nonatomic) IBOutlet UIButton *btnStatus;
@property (nonatomic, strong) DownloadItem *item;

-(IBAction)btnStatusAction:(id)sender;
@end
