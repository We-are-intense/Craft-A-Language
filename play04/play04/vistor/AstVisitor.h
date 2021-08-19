//
//  AstVisitor.h
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import <Foundation/Foundation.h>
#import "FunctionDecl.h"
#import "FunctionBody.h"
#import "FunctionCall.h"
#import "VariableDecl.h"
#import "ExpressionStatement.h"
#import "Binary.h"
#import "IntegerLiteral.h"
#import "DecimalLiteral.h"
#import "StringLiteral.h"
#import "NullLiteral.h"
#import "BooleanLiteral.h"
#import "Variable.h"
#import "ParameterList.h"
#import "CallSignature.h"
#import "ReturnStatement.h"
#import "IfStatement.h"

NS_ASSUME_NONNULL_BEGIN
@class Prog;
/**
 * 对AST做遍历的Vistor。
 * 这是一个基类，定义了缺省的遍历方式。子类可以覆盖某些方法，修改遍历方式。
 */
@interface AstVisitor : NSObject
- (id)visit:(AstNode * _Nullable)node additional:(id _Nullable)additional;
- (id)visitProg:(Prog *)prog additional:(id _Nullable)additional;
- (id)visitVariableDecl:(VariableDecl *)variableDecl additional:(id _Nullable)additional;
- (id)visitBinary:(Binary *)exp additional:(id _Nullable)additional;
- (id)visitIntegerLiteral:(IntegerLiteral *)exp additional:(id _Nullable)additional;
- (id)visitDecimalLiteral:(DecimalLiteral *)exp additional:(id _Nullable)additional;
- (id)visitStringLiteral:(StringLiteral *)exp additional:(id _Nullable)additional;
- (id)visitNullLiteral:(NullLiteral *)exp additional:(id _Nullable)additional;
- (id)visitBooleanLiteral:(BooleanLiteral *)exp additional:(id _Nullable)additional;
- (id)visitVariable:(Variable *)exp additional:(id _Nullable)additional;
- (id)visitBlock:(Block *)block additional:(id _Nullable)additional;
- (id)visitFunctionDecl:(FunctionDecl *)functionDecl additional:(id _Nullable)additional;
- (id)visitFunctionBody:(FunctionBody *)functionBody additional:(id _Nullable)additional;
- (id)visitFunctionCall:(FunctionCall *)functionCall additional:(id _Nullable)additional;
- (id)visitExpressionStatement:(ExpressionStatement *)stmt additional:(id _Nullable)additional;
- (id)visitParameterList:(ParameterList *)paramList additional:(id _Nullable)additional;
- (id)visitCallSignature:(CallSignature *)callSignature additional:(id _Nullable)additional;
- (id)visitReturnStatement:(ReturnStatement *)stmt additional:(id _Nullable)additional;
- (id)visitIfStatement:(IfStatement *)stmt additional:(id _Nullable)additional;
@end

NS_ASSUME_NONNULL_END
