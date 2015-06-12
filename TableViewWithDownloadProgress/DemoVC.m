//
//  DemoVC.m
//  TableViewWithDownloadProgress
//
//  Created by ECWIT on 12/06/15.
//  Copyright (c) 2015 Causania. All rights reserved.
//

#import "DemoVC.h"
#import "DownloadVC.h"

@interface DemoVC ()

@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Action

-(IBAction)btnShowDownloadListAction:(id)sender
{
    DownloadVC *objDownloadVC = (DownloadVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"DownloadVC"];
    if (objDownloadVC)
    {
        [self.navigationController pushViewController:objDownloadVC animated:YES];
    }
}

@end
