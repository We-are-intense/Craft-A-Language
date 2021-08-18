//
//  Position.h
//  play04
//
//  Created by 夏二飞 on 2021/8/18.
//

#import <Foundation/Foundation.h>

#define NPosition(aa, bb, cc, dd) [[Position alloc] initWithBegin:aa end:bb line:cc col:dd]

NS_ASSUME_NONNULL_BEGIN

@interface Position : NSObject

@property (nonatomic, assign) NSUInteger begin;///< 开始于哪个字符，从1开始计数
@property (nonatomic, assign) NSUInteger end;///< 结束于哪个字符
@property (nonatomic, assign) NSUInteger line;///< 所在的行号，从1开始
@property (nonatomic, assign) NSUInteger col;///< 所在的列号，从1开始


- (instancetype)initWithBegin:(NSUInteger)begin
                          end:(NSUInteger)end
                         line:(NSUInteger)line
                          col:(NSUInteger)col;

- (NSString *)toString;

@end

NS_ASSUME_NONNULL_END
