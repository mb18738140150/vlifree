
@protocol UCSVerifyEventDelegate<NSObject>


// 云获取验证码成功  0：已经验证成功，1:已下发验证码到用户
- (void) onGetValiateCodeSuccessful:(NSInteger)nResult;
// 云获取验证码失败
- (void) onGetValiateCodeFailed:(NSInteger)reason;

// 云验证成功
- (void) onDoValiateCodeSuccessful:(NSInteger)nResult;
// 云验证失败
- (void) onDoValiateCodeFailed:(NSInteger)reason;

@end