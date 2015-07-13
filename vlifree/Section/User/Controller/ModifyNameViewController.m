//
//  ModifyNameViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "ModifyNameViewController.h"


#define LEFT_SPACE 20
#define TOP_SPACE 20
#define TF_HEIGHT 30
#define TF_VIEW_SPACE 10
#define VIEW_HEIGHT ((TF_HEIGHT) + ((TF_VIEW_SPACE) * 2))

#define LABEL_WIDTH 50

@interface ModifyNameViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UITextField * nameTF;
@property (nonatomic, copy)RefreshUserInfo refreshBlock;

@end

@implementation ModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"修改昵称";
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, self.view.width - 2 *  LEFT_SPACE, VIEW_HEIGHT)];
    aView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    aView.layer.borderWidth = 1;
    aView.layer.cornerRadius = 3;
    [self.view addSubview:aView];
    
    
    UILabel * nameLB = [[UILabel alloc] initWithFrame:CGRectMake(TF_VIEW_SPACE, TF_VIEW_SPACE, LABEL_WIDTH, TF_HEIGHT)];
    nameLB.text = @"昵称:";
    nameLB.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    nameLB.font = [UIFont systemFontOfSize:20];
    [aView addSubview:nameLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLB.right + TF_VIEW_SPACE, TF_VIEW_SPACE, aView.width - 3 * TF_VIEW_SPACE - LABEL_WIDTH, TF_HEIGHT)];
    _nameTF.placeholder = @"请输入昵称";
    _nameTF.text = [UserInfo shareUserInfo].name;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [aView addSubview:_nameTF];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(determineModifyName:)];
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_w.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)determineModifyName:(UIBarButtonItem *)barBT
{
    [self.nameTF resignFirstResponder];
    if (self.nameTF.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"请输入昵称" duration:2];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入昵称" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if ([self.nameTF.text isEqualToString:[UserInfo shareUserInfo].name])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self downloadData];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTF resignFirstResponder];
}


- (void)downloadData
{
    NSDictionary * jsonDic = @{
                               @"Command":@20,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Name":self.nameTF.text,
                               };
    [self playPostWithDictionary:jsonDic];
    /*
     //    NSLog(@"%@, %@", self.classifyId, [UserInfo shareUserInfo].userId);
     NSString * jsonStr = [jsonDic JSONString];
     NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
     NSLog(@"%@", str);
     NSString * md5Str = [str md5];
     NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
     
     HTTPPost * httpPost = [HTTPPost shareHTTPPost];
     [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
     httpPost.delegate = self;
     */
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
        [UserInfo shareUserInfo].name = self.nameTF.text;
        _refreshBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
}

- (void)refreshUserName:(RefreshUserInfo)refreshBlock
{
    _refreshBlock = refreshBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
