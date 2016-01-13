//
//  CreateCommentViewController.m
//  vlifree
//
//  Created by 仙林 on 15/7/27.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CreateCommentViewController.h"


#define LEFT_SPACE 10
#define TOP_SPACE 15
#define IMAGE_SIZE 50
#define LABEL_HEIGHT 20

@interface CreateCommentViewController ()<HTTPPostDelegate, UITextViewDelegate>
{
    int _starCount;
}

@property (nonatomic, strong)UILabel * evaluateLB;//评价(满意程度)

@property (nonatomic, strong)UITextView * contentView;

@property (nonatomic, strong)UIButton * anonymousBT;
@property (nonatomic, strong)JGProgressHUD * hud;

@end

@implementation CreateCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _starCount = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    [self createSubview];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
}


- (void)createSubview
{
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + self.navigationController.navigationBar.bottom, IMAGE_SIZE, IMAGE_SIZE)];
    __weak UIImageView * aIcon = icon;
    [icon setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:[UIImage imageNamed:@"placeholderIM.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error) {
            aIcon.image = [UIImage imageNamed:@"load_fail.png"];
        }
    }];
    [self.view addSubview:icon];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.right + LEFT_SPACE, icon.top, self.view.width - 2 * LEFT_SPACE - icon.right, icon.height / 3)];
    nameLabel.text = self.storeName;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = TEXT_COLOR;
    [self.view addSubview:nameLabel];
    
    UILabel * decribeLB = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, icon.height - nameLabel.height)];
    decribeLB.font = [UIFont systemFontOfSize:13];
    decribeLB.numberOfLines = 0;
    decribeLB.text = self.decribe;
    decribeLB.textColor = TEXT_COLOR;
    [self.view addSubview:decribeLB];
    
    UILabel * totleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, icon.bottom + 2 * TOP_SPACE, 100, LABEL_HEIGHT)];
    totleLabel.font = [UIFont systemFontOfSize:15];
    totleLabel.textColor = TEXT_COLOR;
    totleLabel.text = @"总体评级:";
    [self.view addSubview:totleLabel];
    
    for (int i = 0; i < 5; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(LEFT_SPACE + i * (LEFT_SPACE + 19.5), totleLabel.bottom + TOP_SPACE, 19.5, 19);
        button.tag = 1000 + i;
        [button setBackgroundImage:[UIImage imageNamed:@"starBT_n.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"starBT_s.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(starCountChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    self.evaluateLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE * 2 + 5 * (19.5 + LEFT_SPACE), totleLabel.bottom + TOP_SPACE, 50, LABEL_HEIGHT)];
    _evaluateLB.textColor = [UIColor orangeColor];
    _evaluateLB.text = @"0分";
    [self.view addSubview:_evaluateLB];
    
    UILabel * alerLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _evaluateLB.bottom + 10, 150, LABEL_HEIGHT)];
    alerLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.7];
    alerLabel.text = @"请给星星打分";
    alerLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:alerLabel];
    
    
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_SPACE, alerLabel.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 150)];
    _contentView.layer.cornerRadius = 10;
    _contentView.delegate = self;
    _contentView.text = @"请, 写点什么吧, 您的意见很宝贵的哦~";
    _contentView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    _contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:_contentView];
    
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 40, self.view.width, 40)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self.view addSubview:bottomView];
    
    self.anonymousBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _anonymousBT.frame = CGRectMake(LEFT_SPACE, 10, 80, 20);
    [_anonymousBT setTitle:@"匿名评价" forState:UIControlStateNormal];
    [_anonymousBT setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    _anonymousBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [_anonymousBT setImage:[UIImage imageNamed:@"anonymous_n.png"] forState:UIControlStateNormal];
    [_anonymousBT setImage:[UIImage imageNamed:@"anonymous_s.png"] forState:UIControlStateSelected];
    [_anonymousBT addTarget:self action:@selector(anonymousAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_anonymousBT];
    
    UIButton * publishBT = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBT.frame = CGRectMake(bottomView.width - 100, 0, 100, bottomView.height);
    publishBT.backgroundColor = MAIN_COLOR;
    [publishBT setTitle:@"发表评价" forState:UIControlStateNormal];
    [publishBT addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:publishBT];
    
    
}


- (void)starCountChange:(UIButton *)button
{
    for (int i = 0; i < 5; i++) {
        UIButton * starButton = (UIButton *)[self.view viewWithTag:1000 + i];
        starButton.selected = NO;
    }
    for (int i = 0; i < button.tag - 999; i++) {
        UIButton * starButton = (UIButton *)[self.view viewWithTag:1000 + i];
        starButton.selected = YES;
        self.evaluateLB.text = [NSString stringWithFormat:@"%d分", i + 1];
    }
    _starCount = (int)(button.tag - 999);
    NSLog(@"%d", _starCount);
}

- (void)anonymousAction:(UIButton *)button
{
    button.selected = !button.selected;
}


- (void)publishAction:(UIButton *)button
{
    NSLog(@"发表评论");
    if (_starCount != 0 && self.contentView.text.length != 0 && ![self.contentView.text isEqualToString:@"请, 写点什么吧, 您的意见很宝贵的哦~"]) {
        NSNumber * anonymous = @2;
        if (self.anonymousBT.selected) {
            anonymous = @1;
        }
        NSDictionary * jsonDic = @{
                                   @"Command":@40,
                                   @"StoreId":self.storeId,
                                   @"OrderId":self.orderId,
                                   @"BusType":@2,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"StarCount":[NSNumber numberWithInt:_starCount],
                                   @"CommentContent":self.contentView.text,
                                   @"Anonymous":anonymous
                                   };
        [self.hud showInView:self.view];
        [self playPostWithDictionary:jsonDic];
    }else if (_starCount == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"您真的忍心给0分吗?给打点分吧!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.contentView.text.length == 0 || [self.contentView.text isEqualToString:@"请, 写点什么吧, 您的意见很宝贵的哦~"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲, 说点什么吧!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请, 写点什么吧, 您的意见很宝贵的哦~"]) {
        textView.text = @"";
        textView.textColor = TEXT_COLOR;
    }
    return YES;
}


#pragma mark-  数据请求
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
    NSLog(@"+++%@", data);
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
    [self.hud dismiss];
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

- (void)failWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [self.hud dismiss];
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
