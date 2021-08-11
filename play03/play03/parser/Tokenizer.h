//
//  Tokenizer.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Token.h"
#import "CharStream.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 词法分析器。
 * 词法分析器的接口像是一个流，词法解析是按需进行的。
 * 支持下面两个操作：
 * next(): 返回当前的Token，并移向下一个Token。
 * peek(): 返回当前的Token，但不移动当前位置。
 */
@interface Tokenizer : NSObject

- (instancetype)initWithStream:(CharStream *)stream;
- (Token *)next;
- (Token *)peek;



@end

NS_ASSUME_NONNULL_END
