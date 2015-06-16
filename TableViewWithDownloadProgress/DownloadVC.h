//
//  DownloadVC.h
//  TableViewWithDownloadProgress
//
//  Created by Paresh Navadiya on 11/06/15.
//  Copyright (c) 2015 India. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BOOL isAnyDownloadStarted;
    NSMutableArray *mutArrQueueDownloadList;
}
@end
