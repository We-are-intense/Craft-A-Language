//
//  CharStream.h
//  play02
//
//  Created by 夏二飞 on 2021/8/11.
//

#import <Foundation/Foundation.h>
#import "Position.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * 一个字符串流。其操作为：
 * peek():预读下一个字符，但不移动指针；
 * next():读取下一个字符，并且移动指针；
 * eof():判断是否已经到了结尾。
 */
@interface CharStream : NSObject

@property (nonatomic, assign, readonly) NSUInteger pos;
@property (nonatomic, assign, readonly) NSUInteger line;
@property (nonatomic, assign, readonly) NSUInteger col;

- (instancetype)initWithData:(NSString *)data;

- (unichar)peek;
- (unichar)next;
- (BOOL)eof;

- (Position *)getPosition;
@end

NS_ASSUME_NONNULL_END
