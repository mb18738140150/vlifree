//
//  GSCommentController.m
//  vlifree
//
//  Created by 仙林 on 15/8/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GSCommentController.h"
#import "CommentViewCell.h"
#import "CommentModel.h"

#define CELL_INDENTIFIER @"cell"

@interface GSCommentController ()<HTTPPostDelegate>

@property (nonatomic, strong)NSMutableArray *commentArray;

@end

@implementation GSCommentController

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"酒店评论详情";
    
    NSDictionary *jsondic = @{
                              @"Command":@39,
                              @"BusType":@1,
                              @"StoreId":@(self.StoreId),
                              @"CurPage":@(self.CurPage),
                              @"CurCount":@(self.CurCount)
                              };
    [self playPostWithDictionary:jsondic];
    
    [self.tableView registerClass:[CommentViewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backLastVC:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 评论数据刷新

- (void)headerRereshing
{
    _CurPage = 1;
    [self.tableView.footer resetNoMoreData];
    [self downloadDataWithCommand:@39 page:_CurPage count:COUNT];
}

- (void)footerRereshing
{
    [self downloadDataWithCommand:@39 page:++_CurPage count:COUNT];
}

#pragma mark - 数据请求

- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
    NSDictionary *jsondic = @{
                              @"Command":@39,
                              @"BusType":@1,
                              @"StoreId":@(self.StoreId),
                              @"CurPage":@(self.CurPage),
                              @"CurCount":@(self.CurCount)
                              };
    [self playPostWithDictionary:jsondic];
}
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    //    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    NSLog(@"+++%@", data);
    //    [self.groshopTabelView.header endRefreshing];
    //    [self.groshopTabelView.footer endRefreshing];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        if([[data objectForKey:@"Command"] isEqualToNumber:@10039])
        {
            
            NSArray * array = [data objectForKey:@"CommentList"];
            if (_CurPage == 1) {
                self.commentArray = nil;
            }
            for (NSDictionary * dic in array) {
                CommentModel * commentMD  = [[CommentModel alloc] initWithDictionary:dic];
                [self.commentArray addObject:commentMD];
            }
            if ([[data objectForKey:@"AllCur"] intValue] == _CurPage || self.commentArray.count == 0 || self.commentArray.count == [[data objectForKey:@"AllCount"] integerValue]) {
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    CommentModel *model = [self.commentArray objectAtIndex:indexPath.row];
    cell.commentMD = model;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel * commentMD = [self.commentArray objectAtIndex:indexPath.row];
    return [CommentViewCell cellHeightWithCommentMD:commentMD];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
