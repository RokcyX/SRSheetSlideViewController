//
//  ViewController.m
//  SRSheetSlideViewControllerDemo
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+SRSheetSlide.h"
#import "SecondViewController.h"

static NSString * const kTitleKey = @"kTitleKey";
static NSString * const kSheetPositionKey = @"kSheetPositionKey";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *menuList;

@property (nonatomic,strong) SecondViewController *vc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vc = [[SecondViewController alloc] init];
    [self.vc becomeSheetSlideOnViewController:self];
}

- (NSArray *)menuList {
    if (!_menuList) {
        _menuList = @[
                      @{kTitleKey: @"显示顶部卡片", kSheetPositionKey: @(SRSheetSlideViewControllerSheetPositionTop)},
                      @{kTitleKey: @"显示右侧卡片", kSheetPositionKey: @(SRSheetSlideViewControllerSheetPositionRight)},
                      @{kTitleKey: @"显示底部卡片", kSheetPositionKey: @(SRSheetSlideViewControllerSheetPositionBottom)},
                      @{kTitleKey: @"显示左侧卡片", kSheetPositionKey: @(SRSheetSlideViewControllerSheetPositionLeft)},
                      ];
    }
    return _menuList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SRCell"];
    }
    cell.textLabel.text = [[self.menuList objectAtIndex:indexPath.row] valueForKey:kTitleKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.vc.sheetPosition = [[[self.menuList objectAtIndex:indexPath.row] valueForKey:kSheetPositionKey] integerValue];
    [self presentViewController:self.vc animated:YES completion:nil];
}

@end
