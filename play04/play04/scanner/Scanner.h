//
//  scanner.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import "CharStream.h"
#import "Token.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * 词法分析器。
 * 词法分析器的接口像是一个流，词法解析是按需进行的。
 * 支持下面两个操作：
 * next(): 返回当前的Token，并移向下一个Token。
 * peek(): 预读当前的Token，但不移动当前位置。
 * peek2(): 预读第二个Token。
 */
@interface Scanner : NSObject

@property (nonatomic, strong, readonly) CharStream *stream;

- (instancetype)initWithStream:(CharStream *)stream;

- (Token *)next;
- (Token *)peek;
- (Token *)peek2;
@end

NS_ASSUME_NONNULL_END
