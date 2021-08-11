//
//  AstVisitor.h
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import <Foundation/Foundation.h>
#import "Prog.h"
#import "FunctionDecl.h"
#import "FunctionBody.h"
#import "FunctionCall.h"


NS_ASSUME_NONNULL_BEGIN
/**
 * 对AST做遍历的Vistor。
 * 这是一个基类，定义了缺省的遍历方式。子类可以覆盖某些方法，修改遍历方式。
 */
@interface AstVisitor : NSObject

- (id)visitProg:(Prog *)prog;
- (id)visitFunctionDecl:(FunctionDecl *)functionDecl;
- (id)visitFunctionBody:(FunctionBody *)functionBody;
- (id)visitFunctionCall:(FunctionCall *)functionCall;

@end

NS_ASSUME_NONNULL_END
