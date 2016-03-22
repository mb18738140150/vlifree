//
//  CommentViewCell.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/25.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CommentViewCell.h"
#import "CommentModel.h"

#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LABEL_HEIGHT 20
#define FONT_LABEL [UIFont systemFontOfSize:15]


@interface CommentViewCell ()

@property (nonatomic, strong)UILabel * nameLB;
@property (nonatomic, strong)UILabel * contentLB;
@property (nonatomic, strong)UILabel * timeLB;
@property (nonatomic, strong)UILabel * replyLB;


@end


@implementation CommentViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview
{
    self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT)];
    //    _timeLB.text = @"2015-07-25";
    _timeLB.textAlignment = NSTextAlignmentRight;
    _timeLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    _timeLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLB];
    
    self.nameLB = [[UILabel alloc] initWithFrame:CGRectMake(_timeLB.right, TOP_SPACE, 150, LABEL_HEIGHT)];
    self.nameLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
//    self.nameLB.text = @"郑*秋*实";
    _nameLB.font = FONT_LABEL;
    [self.contentView addSubview:_nameLB];
    
    for (int i = 0; i < 5; i++) {
        UIImageView * aImageV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - LEFT_SPACE - (5 - i) * 13.5, TOP_SPACE, 11.5, 11)];
        aImageV.centerY = _nameLB.centerY;
        aImageV.tag = i + 1000;
        aImageV.image = [UIImage imageNamed:@"colect_n.png"];
        [self.contentView addSubview:aImageV];
    }
    
    self.contentLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _nameLB.bottom + TOP_SPACE, WINDOW_WIDHT - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _contentLB.textColor = [UIColor grayColor];
//    _contentLB.text = @"还行, 就是才有点咸,希望能少放盐。";
    _contentLB.numberOfLines = 0;
    _contentLB.font = FONT_LABEL;
    [self.contentView addSubview:_contentLB];
    
    
    self.replyLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, _contentLB.bottom + TOP_SPACE, WINDOW_WIDHT - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    _replyLB.textColor = [UIColor grayColor];
    _replyLB.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:243 / 255.0 blue:252 / 255.0 alpha:1];
//    _replyLB.text = @"[店家回复]感谢的评价, 我们会改进的.";
    _replyLB.numberOfLines = 0;
    _replyLB.font = FONT_LABEL;
    [self.contentView addSubview:_replyLB];
}


+ (CGFloat)cellHeightWithCommentMD:(CommentModel *)commentMD
{
    CGSize contentSize = [commentMD.commentContent boundingRectWithSize:CGSizeMake(WINDOW_WIDHT - 2 * LEFT_SPACE, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_LABEL, NSFontAttributeName, nil] context:nil].size;
    NSString * reply = [NSString stringWithFormat:@"[店家回复]:%@", commentMD.reply];
    CGSize replySize = [reply boundingRectWithSize:CGSizeMake(WINDOW_WIDHT - 2 * LEFT_SPACE, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_LABEL, NSFontAttributeName, nil] context:nil].size;
    if (commentMD.reply.length == 0) {
        return LABEL_HEIGHT + 3 * TOP_SPACE + contentSize.height;
    }
    return  LABEL_HEIGHT + 4 * TOP_SPACE + contentSize.height + replySize.height;
}


- (void)setCommentMD:(CommentModel *)commentMD
{
    _commentMD = commentMD;
    self.timeLB.text = commentMD.commentTime;
    CGRect timerectangle = [self.timeLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.timeLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.timeLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE, timerectangle.size.width, LABEL_HEIGHT);
    
    if ([commentMD.anonymous isEqualToNumber:@1]) {
        self.nameLB.text = @"匿名";
    }else
    {
        self.nameLB.text = commentMD.commentName;
    }
    CGRect nameRecg = [self.timeLB.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.timeLB.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    self.nameLB.frame = CGRectMake(_timeLB.right + 2, TOP_SPACE, nameRecg.size.width, LABEL_HEIGHT);
    
    
    self.contentLB.text = commentMD.commentContent;
    CGSize size = [_contentLB sizeThatFits:CGSizeMake(_contentLB.width, CGFLOAT_MAX)];
    _contentLB.height = size.height;
    
    _replyLB.top = _contentLB.bottom + TOP_SPACE;
    if (commentMD.reply.length == 0) {
        _replyLB.hidden = YES;
    }else
    {
        NSString * replyString = [NSString stringWithFormat:@"[店家回复]:%@", commentMD.reply];
        
        NSMutableAttributedString * replyStr = [[NSMutableAttributedString alloc]initWithString:replyString];
        NSDictionary * attribute = @{NSForegroundColorAttributeName:BACKGROUNDCOLOR};
        [replyStr setAttributes:attribute range:NSMakeRange(0, 7)];
        self.replyLB.attributedText = replyStr;
        CGSize replySize = [_replyLB sizeThatFits:CGSizeMake(_replyLB.width, CGFLOAT_MAX)];
        _replyLB.size = replySize;
        _replyLB.hidden = NO;
    }
    int starC = commentMD.starCount.intValue;
    for (int i = 0; i < starC; i++) {
        UIImageView * imageV = (UIImageView *)[self.contentView viewWithTag:1000 + i];
        imageV.image = [UIImage imageNamed:@"colect_s.png"];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
