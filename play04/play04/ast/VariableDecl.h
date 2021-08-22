//
//  VariableDecl.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Decl.h"

NS_ASSUME_NONNULL_BEGIN

@class Expression, AstVisitor;

@interface VariableDecl : Decl
///< 变量类型
@property (nonatomic, copy, readonly) NSString *varType;
///< 变量初始化所使用的表达式
@property (nonatomic, copy, readonly, nullable) Expression *initi;

- (instancetype)initWithName:(NSString *)name
                     varType:(NSString *)varType
                        initi:(Expression *)initi;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name
                         varType:(NSString *)varType
                           initi:(Expression * _Nullable)initi;

- (void)dump:(NSString *)prefix;
- (id)accept:(AstVisitor *)visitor additional:(id)additional;

@end

NS_ASSUME_NONNULL_END
