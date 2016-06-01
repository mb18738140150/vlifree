//
//  SettingController.m
//  vlifree
//
//  Created by 仙林 on 16/3/28.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "SettingController.h"
#import "ModifyNameViewController.h"
#import "PasswordViewController.h"
#import "PhoneViewController.h"
#define TOP_SPACE 10
#define VIEW_HEIGHT 45
#define LEFT_SPACE 10
#define LABEL_HEIGHT 15

@interface SettingController ()<HTTPPostDelegate>

@end

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    [self creatSubviews];
    
}
- (void)creatSubviews
{
    UIScrollView * myscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    myscrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:myscrollView];
    
    UIView * nameview = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width, VIEW_HEIGHT)];
    nameview.backgroundColor = [UIColor whiteColor];
    [myscrollView addSubview:nameview];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, LABEL_HEIGHT, nameview.width - 2 * LEFT_SPACE - 50, LABEL_HEIGHT)];
    nameLabel.text = @"修改用户名";
    [nameview addSubview:nameLabel];
    
    UIButton * nameBt = [UIButton buttonWithType:UIButtonTypeCustom];
    nameBt.frame = CGRectMake(nameview.width - 40, nameview.height / 2 - 15, 30, 30);
    [nameBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
    [nameview addSubview:nameBt];
    [nameBt addTarget:self action:@selector(setupnameAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * passWordview = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + nameview.bottom, self.view.width, VIEW_HEIGHT)];
    passWordview.backgroundColor = [UIColor whiteColor];
    [myscrollView addSubview:passWordview];
    
    UILabel * passWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, LABEL_HEIGHT, passWordview.width - 2 * LEFT_SPACE - 50, LABEL_HEIGHT)];
    passWordLabel.text = @"修改密码";
    [passWordview addSubview:passWordLabel];
    
    UIButton * passWordBt = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordBt.frame = CGRectMake(passWordview.width - 40, passWordview.height / 2 - 15, 30, 30);
    [passWordBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
    [passWordview addSubview:passWordBt];
    [passWordBt addTarget:self action:@selector(setuppassWordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * phoneview = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + passWordview.bottom, self.view.width, VIEW_HEIGHT)];
    phoneview.backgroundColor = [UIColor whiteColor];
    [myscrollView addSubview:phoneview];
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, LABEL_HEIGHT, phoneview.width - 2 * LEFT_SPACE - 50, LABEL_HEIGHT)];
    phoneLabel.text = @"修改电话";
    [phoneview addSubview:phoneLabel];
    
    UIButton * phoneBt = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBt.frame = CGRectMake(phoneview.width - 40, phoneview.height / 2 - 15, 30, 30);
    [phoneBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
    [phoneview addSubview:phoneBt];
    [phoneBt addTarget:self action:@selector(setupphoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * serverphoneview = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + phoneview.bottom, self.view.width, VIEW_HEIGHT)];
    serverphoneview.backgroundColor = [UIColor whiteColor];
    [myscrollView addSubview:serverphoneview];
    
    UILabel * serverphoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, LABEL_HEIGHT, serverphoneview.width - 2 * LEFT_SPACE - 50, LABEL_HEIGHT)];
    NSString * serverphoneStr = [NSString stringWithFormat:@"客服电话 %@", [UserInfo shareUserInfo].servicePhone];
    NSMutableAttributedString * serverphoneStrM = [[NSMutableAttributedString alloc]initWithString:serverphoneStr];
    [serverphoneStrM setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:.6 alpha:1]} range:NSMakeRange(5, serverphoneStr.length - 5)];
    serverphoneLabel.attributedText = serverphoneStrM;
    [serverphoneview addSubview:serverphoneLabel];
    
    
    UIButton * exitBT = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBT.frame = CGRectMake(0, serverphoneview.bottom + TOP_SPACE, myscrollView.width, VIEW_HEIGHT);
    exitBT.backgroundColor = [UIColor whiteColor];
    [exitBT setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBT setTitleColor:BACKGROUNDCOLOR forState:UIControlStateNormal];
    [exitBT addTarget:self action:@selector(exitLogInAciton:) forControlEvents:UIControlEventTouchUpInside];
    [myscrollView addSubview:exitBT];
    
    
    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
    backBT.frame = CGRectMake(0, 0, 15, 20);
    [backBT setBackgroundImage:[UIImage imageNamed:@"back_black.png"] forState:UIControlStateNormal];
    [backBT addTarget:self action:@selector(backLastVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
//    UIButton * serverphoneBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    serverphoneBt.frame = CGRectMake(serverphoneview.width - 40, serverphoneview.height / 2 - 15, 30, 30);
//    [serverphoneBt setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
//    [serverphoneview addSubview:serverphoneBt];
//    [serverphoneBt addTarget:self action:@selector(setupserverphoneAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupnameAction:(UIButton *)button
{
    ModifyNameViewController * modiVC = [[ModifyNameViewController alloc]init];
    
    [self.navigationController pushViewController:modiVC animated:YES];
}

- (void)setuppassWordAction:(UIButton *)button
{
    PasswordViewController * passWordVC = [[PasswordViewController alloc]init];
    
    [self.navigationController pushViewController:passWordVC animated:YES];
}

- (void)setupphoneAction:(UIButton *)button
{
    PhoneViewController * phoneVC = [[PhoneViewController alloc]init];
    
    [self.navigationController pushViewController:phoneVC animated:YES];
}
- (void)exitLogInAciton:(UIButton *)button
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]) {
        NSDictionary * dic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]
                               };
        [self requestDataWithDictionary:dic];
    }else
    {
        NSDictionary * dic = @{
                               @"Command":@37,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Device":@1,
                               @"CID":[NSNull null]
                               };
        [self requestDataWithDictionary:dic];
    }
//    [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogIn"];
//    [UserInfo shareUserInfo].userId = nil;
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 数据请求

- (void)requestDataWithDictionary:(NSDictionary *)dic
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
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
         if ([[data objectForKey:@"Command"] isEqualToNumber:@10037])
        {
            NSLog(@"解除绑定");
            [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"haveLogIn"];
            [UserInfo shareUserInfo].userId = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    //    [SVProgressHUD dismiss];
}
- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end
