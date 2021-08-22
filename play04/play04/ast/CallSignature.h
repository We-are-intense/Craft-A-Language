//
//  CallSignature.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "AstNode.h"
#import "ParameterList.h"
#import "Type.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 调用签名
 * 可以用在函数声明等多个地方。
 */
@interface CallSignature : AstNode

@property (nonatomic, strong) ParameterList *paramList;
@property (nonatomic, strong) Type *type; // 返回值类型

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                       paramList:(ParameterList * _Nullable)paramList
                            type:(Type * _Nullable)type;


@end

NS_ASSUME_NONNULL_END
