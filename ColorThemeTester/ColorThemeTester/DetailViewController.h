//
//  DetailViewController.h
//  KulerTester
//
//  Created by Kishore Kumar on 21/6/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class KulerObject;

@interface DetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property(strong, nonatomic) KulerObject *kuler;

@end
