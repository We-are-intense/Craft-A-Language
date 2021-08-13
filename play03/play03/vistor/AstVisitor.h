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


NS_ASSUME_NONNULL_BEGIN
@class Prog;
/**
 * 对AST做遍历的Vistor。
 * 这是一个基类，定义了缺省的遍历方式。子类可以覆盖某些方法，修改遍历方式。
 */
@interface AstVisitor : NSObject
- (id)visit:(AstNode * _Nullable)node;
- (id)visitProg:(Prog *)prog;
- (id)visitVariableDecl:(VariableDecl *)variableDecl;
- (id)visitBinary:(Binary *)exp;
- (id)visitIntegerLiteral:(IntegerLiteral *)exp;
- (id)visitDecimalLiteral:(DecimalLiteral *)exp;
- (id)visitStringLiteral:(StringLiteral *)exp;
- (id)visitNullLiteral:(NullLiteral *)exp;
- (id)visitBooleanLiteral:(BooleanLiteral *)exp;
- (id)visitVariable:(Variable *)exp;
- (id)visitBlock:(Block *)block;
- (id)visitFunctionDecl:(FunctionDecl *)functionDecl;
- (id)visitFunctionBody:(FunctionBody *)functionBody;
- (id)visitFunctionCall:(FunctionCall *)functionCall;

@end

NS_ASSUME_NONNULL_END
