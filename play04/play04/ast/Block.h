//
//  Block.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "AstNode.h"
#import "Statement.h"
#import "AstVisitor.h"
#import "Scope.h"

NS_ASSUME_NONNULL_BEGIN

@interface Block : Statement

@property (nonatomic, copy, readonly) NSArray <Statement *> *stmts;

@property (nonatomic, copy, readonly) Scope *scope;

- (instancetype)initWithStmts:(NSArray <Statement *> *)stmts;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           stmts:(NSArray <Statement *> * _Nullable)stmts;

@end

NS_ASSUME_NONNULL_END
