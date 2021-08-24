//
//  VariableDecl.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Decl.h"
#import "SysTypes.h"
NS_ASSUME_NONNULL_BEGIN

@class Expression, AstVisitor;

@interface VariableDecl : Decl
///< 变量类型
@property (nonatomic, copy, readonly) SimpleType *varType;
///< 变量初始化所使用的表达式
@property (nonatomic, copy, readonly, nullable) Expression *initi;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name
                         varType:(SimpleType * _Nonnull)varType
                           initi:(Expression * _Nullable)initi;

- (void)dump:(NSString *)prefix;
- (id)accept:(AstVisitor *)visitor additional:(id)additional;

@end

NS_ASSUME_NONNULL_END
