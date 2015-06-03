
//
//  PasswordViewController.m
//  vlifree
//
//  Created by 仙林 on 15/5/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "PasswordViewController.h"


#define LEFT_SPACE 10
#define TOP_SPACE 20
#define TF_HEIGHT 30
#define TF_VIEW_TOP_SPACE 10
#define TF_VIEW_LEFT_SPACE 20
#define VIEW_HEIGHT (TF_HEIGHT + ((TF_VIEW_TOP_SPACE) * 2))

@interface PasswordViewController ()


@property (nonatomic, strong)UITextField * oldPasswordTF;//当前密码
@property (nonatomic, strong)UITextField * modifyPasswordTF;//新密码
@property (nonatomic, strong)UITextField * confirmPasswordTF;//确认密码


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
    self.title = @"修改密码";
    UIView * oldView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    oldView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    oldView.layer.borderWidth = 1;
    oldView.layer.cornerRadius = 3;
    [self.view addSubview:oldView];
    
    self.oldPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, oldView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
    _oldPasswordTF.placeholder = @"当前密码";
    _oldPasswordTF.secureTextEntry = YES;
    _oldPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _oldPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [oldView addSubview:_oldPasswordTF];
    
    UIView * modifyView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + oldView.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    modifyView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    modifyView.layer.borderWidth = 1;
    modifyView.layer.cornerRadius = 3;
    [self.view addSubview:modifyView];
    
    self.modifyPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, modifyView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
    _modifyPasswordTF.placeholder = @"新密码";
    _modifyPasswordTF.secureTextEntry = YES;
    _modifyPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _modifyPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [modifyView addSubview:_modifyPasswordTF];
    
    
    UIView * confirmView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + modifyView.bottom, self.view.width - 2 * LEFT_SPACE, VIEW_HEIGHT)];
    confirmView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.7].CGColor;
    confirmView.layer.borderWidth = 1;
    confirmView.layer.cornerRadius = 3;
    [self.view addSubview:confirmView];
    
    self.confirmPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(TF_VIEW_LEFT_SPACE, TF_VIEW_TOP_SPACE, confirmView.width - 2 * TF_VIEW_LEFT_SPACE, TF_HEIGHT)];
    _confirmPasswordTF.placeholder = @"确认密码";
    _confirmPasswordTF.secureTextEntry = YES;
    _confirmPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmPasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [confirmView addSubview:_confirmPasswordTF];
    
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(LEFT_SPACE, confirmView.bottom + TOP_SPACE, confirmView.width, VIEW_HEIGHT);
    [confirmButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.backgroundColor = MAIN_COLOR;
    [confirmButton addTarget:self action:@selector(confirmChangePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    
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
    if (self.oldPasswordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入旧密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (self.modifyPasswordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (self.confirmPasswordTF.text.length == 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入确认密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [alertView performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1];
    }else if (self.confirmPasswordTF.text.length && self.oldPasswordTF.text.length && self.modifyPasswordTF.text.length){
        [self.navigationController popViewControllerAnimated:YES];

    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldPasswordTF resignFirstResponder];
    [self.modifyPasswordTF resignFirstResponder];
    [self.confirmPasswordTF resignFirstResponder];
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
