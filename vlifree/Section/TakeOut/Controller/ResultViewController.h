//
//  ResultViewController.h
//  vlifree
//
//  Created by 仙林 on 15/6/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UITableViewController<UISearchResultsUpdating>


@property (nonatomic, assign)id target;
@property (nonatomic, assign)SEL action;



@end
