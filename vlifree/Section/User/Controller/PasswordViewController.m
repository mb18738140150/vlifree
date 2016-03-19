
//
//  PasswordViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PasswordViewController.h"
#import "PasswordVIewHelpView.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define PASS_HEIGHT 50
#define TF_HEIGHT 30
#define TF_VIEW_TOP_SPACE 10
#define TF_VIEW_LEFT_SPACE 20
#define VIEW_HEIGHT (TF_HEIGHT + ((TF_VIEW_TOP_SPACE) * 2))

@interface PasswordViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)PasswordVIewHelpView * accountView;// 账户
@property (nonatomic, strong)PasswordVIewHelpView * oldPasswordTF;// 旧密码
@property (nonatomic, strong)PasswordVIewHelpView * nPasswordTF;// 新密码
@property (nonatomic, strong)PasswordVIewHelpView * sPasswordTF;// 确认密码

@property (nonatomic, strong)JGProgressHUD * hud;


@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                    };
    self.navigationItem.title = @"修改密码";
    
    /*
//    UIView * oldView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
//    oldView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
//    oldView.layer.borderWidth = 1;
//    oldView.layer.cornerRadius = 3;
//    [self.view addSubview:oldView];
//    
//    self.oldPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, oldView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
//    _oldPasswordTF.placeholder = @"当前密码";
//    _oldPasswordTF.secureTextEntry = YES;
//    _oldPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _oldPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [oldView addSubview:_oldPasswordTF];
//    
//    UIView * modifyView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + oldView.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
//    modifyView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
//    modifyView.layer.borderWidth = 1;
//    modifyView.layer.cornerRadius = 3;
//    [self.view addSubview:modifyView];
//    
//    self.modifyPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, modifyView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
//    _modifyPasswordTF.placeholder = @"新密码";
//    _modifyPasswordTF.secureTextEntry = YES;
//    _modifyPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _modifyPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [modifyView addSubview:_modifyPasswordTF];
//    
//    
//    UIView * confirmView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + modifyView.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
//    confirmView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
//    confirmView.layer.borderWidth = 1;
//    confirmView.layer.cornerRadius = 3;
//    [self.view addSubview:confirmView];
//    
//    self.confirmPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, confirmView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
//    _confirmPasswordTF.placeholder = @"确认密码";
//    _confirmPasswordTF.secureTextEntry = YES;
//    _confirmPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _confirmPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    [confirmView addSubview:_confirmPasswordTF];
//    
//    
//    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmButton.frame = CGRectMake(LEFT_SPACE, confirmView.bottom + TOP_SPACE, confirmView.width, VIEW_HEIGHT);
//    [confirmButton setTitle:@"确认提交" forState:UIControlStateNormal];
//    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    confirmButton.backgroundColor = MAIN_COLOR;
//    [confirmButton addTarget:self action:@selector(confirmChangePassword:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmButton];
//
    */
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.accountView = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, TOP_SPACE + 64, self.view.width, PASS_HEIGHT)];
    self.accountView.nameLabel.text = @"账户";
    self.accountView.nameLabel.textColor = [UIColor grayColor];
    self.accountView.passwordTF.text = [NSString stringWithFormat:@"%@", [UserInfo shareUserInfo].phoneNumber];
    self.accountView.passwordTF.textColor = [UIColor grayColor];
    self.accountView.passwordTF.enabled = NO;
    [self.view addSubview:_accountView];
    
    
    self.oldPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0,_accountView.bottom + 1 , self.view.width, PASS_HEIGHT)];
    self.oldPasswordTF.nameLabel.text = @"当前密码";
    self.oldPasswordTF.passwordTF.placeholder = @"请输入您的原始密码";
    _oldPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_oldPasswordTF];
    
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, _oldPasswordTF.bottom + TOP_SPACE, self.view.width - 2 * TOP_SPACE,30)];
    tipLabel.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    tipLabel.text = @"请重新设置登录密码";
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    
    
    self.nPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, tipLabel.bottom + TOP_SPACE / 2, self.view.width, PASS_HEIGHT)];
    _nPasswordTF.nameLabel.text = @"设置密码";
    _nPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _nPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_nPasswordTF];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _nPasswordTF.bottom, self.view.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:line];
    
    self.sPasswordTF = [[PasswordVIewHelpView alloc]initWithFrame:CGRectMake(0, line.bottom, self.view.width, PASS_HEIGHT)];
    _sPasswordTF.nameLabel.text = @"确认密码";
    _sPasswordTF.passwordTF.placeholder = @"6-16字符,区分大小写";
    _sPasswordTF.passwordTF.secureTextEntry = YES;
    [self.view addSubview:_sPasswordTF];
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(TOP_SPACE * 2, _sPasswordTF.bottom + TOP_SPACE, self.view.width - LEFT_SPACE * 4, VIEW_HEIGHT);
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.backgroundColor = MAIN_COLOR;
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmChangePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    
    self.navigationItem.title = @"修改登录密码";

    
    self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    
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

- (void)confirmChangePassword:(UIButton *)button
{
    if (self.oldPasswordTF.passwordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入旧密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (self.nPasswordTF.passwordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (self.sPasswordTF.passwordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入确认密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (![self.nPasswordTF.passwordTF.text isEqualToString:self.sPasswordTF.passwordTF.text]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码和确认密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else
    {
        [self downloadData];
    }
    [self.oldPasswordTF.passwordTF resignFirstResponder];
    [self.nPasswordTF.passwordTF resignFirstResponder];
    [self.sPasswordTF.passwordTF resignFirstResponder];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldPasswordTF.passwordTF resignFirstResponder];
    [self.nPasswordTF.passwordTF resignFirstResponder];
    [self.sPasswordTF.passwordTF resignFirstResponder];
}

- (void)downloadData
{
    [self.hud showInView:self.view];
    NSDictionary * jsonDic = @{
                               @"Command":@21,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"OldPassword":self.oldPasswordTF.passwordTF.text,
                               @"Password":self.sPasswordTF.passwordTF.text
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
    [self.hud dismiss];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
//    [SVProgressHUD dismiss];
}

- (void)failWithError:(NSError *)error
{
//    [SVProgressHUD dismiss];
    NSLog(@"%@", error);
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
