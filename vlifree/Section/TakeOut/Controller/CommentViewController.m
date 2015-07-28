//
//  CommentViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/24.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentViewCell.h"
#import "CommentModel.h"

#define CELL_IDENTIFIER @"cell"

@interface CommentViewController ()<HTTPPostDelegate>
{
    int _page;
}
@property (nonatomic, strong)NSMutableArray * dataArray;


@end

@implementation CommentViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[CommentViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    _page = 1;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self downloadDataWithCommand:@39 page:_page count:COUNT];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据刷新

- (void)headerRereshing
{
    _page = 1;
    [self.tableView.footer resetNoMoreData];
    [self downloadDataWithCommand:@39 page:_page count:COUNT];
}

- (void)footerRereshing
{
    [self downloadDataWithCommand:@39 page:++_page count:COUNT];
}

#pragma mark - 数据请求
- (void)downloadDataWithCommand:(NSNumber *)command page:(int)page count:(int)count
{
        NSDictionary * jsonDic = @{
                                   @"Command":command,
                                   @"CurPage":[NSNumber numberWithInt:page],
                                   @"CurCount":[NSNumber numberWithInt:count],
                                   @"StoreId":self.storeId,
                                   @"BusType":@2
                                   };
        [self playPostWithDictionary:jsonDic];
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    NSLog(@"+++%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSArray * array = [data objectForKey:@"CommentList"];
        if (_page == 1) {
            self.dataArray = nil;
        }
        for (NSDictionary * dic in array) {
            CommentModel * commentMD  = [[CommentModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:commentMD];
        }
        if ([[data objectForKey:@"AllCur"] intValue] == _page || self.dataArray.count == 0) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }
}

- (void)failWithError:(NSError *)error
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    //    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    CommentModel * commentMD = [self.dataArray objectAtIndex:indexPath.row];
    cell.commentMD = commentMD;
//    cell.textLabel.text = @"123455";
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel * commentMD = [self.dataArray objectAtIndex:indexPath.row];
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
