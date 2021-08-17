//
//  Block.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "AstNode.h"
#import "Statement.h"
#import "AstVisitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Block : AstNode

@property (nonatomic, copy, readonly) NSArray <Statement *> *stmts;

- (instancetype)initWithStmts:(NSArray <Statement *> *)stmts;

@end

NS_ASSUME_NONNULL_END
