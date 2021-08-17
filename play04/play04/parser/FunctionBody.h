//
//  FunctionBody.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "AstNode.h"

NS_ASSUME_NONNULL_BEGIN
@class FunctionCall;
@interface FunctionBody : AstNode
@property (nonatomic, copy, readonly) NSArray <FunctionCall *> *stmts;


- (instancetype)initWithStmts:(NSArray <FunctionCall *> *)stmts;

- (void)dump:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
