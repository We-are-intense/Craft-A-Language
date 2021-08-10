//
//  Prog.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "AstNode.h"
#import "Statement.h"

NS_ASSUME_NONNULL_BEGIN

@interface Prog : AstNode

@property (nonatomic, copy, readonly) NSArray <Statement *>*stmts;

- (instancetype)initWithStmts:(NSArray <Statement *>*)stmts;

@end

NS_ASSUME_NONNULL_END
