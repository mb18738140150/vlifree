//
//  ResultViewController.m
//  vlifree
//
//  Created by 仙林 on 15/6/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()<HTTPPostDelegate>


@property (nonatomic, strong)NSMutableArray * dataArray;


@end

@implementation ResultViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = TEXT_COLOR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.target respondsToSelector:_action]) {
        [self.target performSelector:_action withObject:[self.dataArray objectAtIndex:indexPath.row]];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@", searchController.searchBar.text);
    if (searchController.searchBar.text.length) {
        NSDictionary * jsonDic = @{
                                   @"Command":@18,
                                   @"KeyWord":searchController.searchBar.text
                                   };
        //    [self playPostWithDictionary:jsonDic];
        NSString * jsonStr = [jsonDic JSONString];
        //    NSLog(@"%@", jsonStr);
        NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
        NSString * md5Str = [str md5];
        NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSOperationQueue * queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSLog(@"%@", data);
            if (data != nil) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray * array = [dic objectForKey:@"KeyWordList"];
                self.dataArray = nil;
                for (NSDictionary * wordDic in array) {
                    [self.dataArray addObject:[wordDic objectForKey:@"KeyWord"]];
                }
                [self.tableView reloadData];
                NSLog(@"%@, error = %@", dic, connectionError);
            }
        }];

    }
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
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
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
