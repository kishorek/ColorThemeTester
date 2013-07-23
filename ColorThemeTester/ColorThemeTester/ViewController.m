//
//  ViewController.m
//  KulerTester
//
//  Created by Kishore Kumar on 21/6/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import "ViewController.h"
#import "APIHelper.h"
#import "ColourThemeObject.h"
#import "DetailViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableArray *colors;
@property(nonatomic, strong) UIColor *currentNavBarColor;
@property(nonatomic, strong) APIHelper *apiHelper;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Color Theme Tester";
    self.currentNavBarColor = self.navigationController.navigationBar.tintColor;
    self.apiHelper = [[APIHelper alloc] init];
    
    __block UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    __weak ViewController *weakself = self;

/* 
 
 Enable Kuler if you have access
 -------------------------------
    [self.apiHelper fetchKulerColourThemesOnSuccess:^(NSArray *colors) {
        weakself.colors = [NSMutableArray arrayWithArray:colors];
        
        [weakself.tableView reloadData];
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }];
 */
    
    [self.apiHelper fetchCOLOURloversColourThemesOnSuccess:^(NSArray *colors) {
        weakself.colors = [NSMutableArray arrayWithArray:colors];
        
        [weakself.tableView reloadData];
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setTintColor:self.currentNavBarColor];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.colors count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"Kuler";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *view1 = [[UIView alloc] init];
        view1.frame = CGRectMake(0*cell.frame.size.width/5, 0, cell.frame.size.width/5, cell.frame.size.height);
        view1.tag = 1111;
        
        UIView *view2 = [[UIView alloc] init];
        view2.frame = CGRectMake(1*cell.frame.size.width/5, 0, cell.frame.size.width/5, cell.frame.size.height);
        view2.tag = 2222;
        
        UIView *view3 = [[UIView alloc] init];
        view3.frame = CGRectMake(2*cell.frame.size.width/5, 0, cell.frame.size.width/5, cell.frame.size.height);
        view3.tag = 3333;
        
        UIView *view4 = [[UIView alloc] init];
        view4.frame = CGRectMake(3*cell.frame.size.width/5, 0, cell.frame.size.width/5, cell.frame.size.height);
        view4.tag = 4444;
        
        UIView *view5 = [[UIView alloc] init];
        view5.frame = CGRectMake(4*cell.frame.size.width/5, 0, cell.frame.size.width/5, cell.frame.size.height);
        view5.tag = 5555;
        
        [cell addSubview:view1];
        [cell addSubview:view2];
        [cell addSubview:view3];
        [cell addSubview:view4];
        [cell addSubview:view5];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *view1 = [cell viewWithTag:1111];
    UIView *view2 = [cell viewWithTag:2222];
    UIView *view3 = [cell viewWithTag:3333];
    UIView *view4 = [cell viewWithTag:4444];
    UIView *view5 = [cell viewWithTag:5555];
    
    ColourThemeObject *obj = [self.colors objectAtIndex:indexPath.section];
    view1.backgroundColor = obj.color1;
    view2.backgroundColor = obj.color2;
    view3.backgroundColor = obj.color3;
    view4.backgroundColor = obj.color4;
    view5.backgroundColor = obj.color5;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ColourThemeObject *obj = [self.colors objectAtIndex:section];
    return obj.title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    ColourThemeObject *obj = [self.colors objectAtIndex:indexPath.section];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.colorObject = obj;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
