//
//  ViewController.h
//  KulerTester
//
//  Created by Kishore Kumar on 21/6/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
