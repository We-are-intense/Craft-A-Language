//
//  Token.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Position.h"


#define SEqual(aa, bb) [aa isEqualToString:bb]
#define SChar(cc) [NSString stringWithFormat:@"%c",cc]

#define NToken(kd, txt, posi, codee) [Token createWithKind:kd text:txt pos:posi code:codee]


NS_ASSUME_NONNULL_BEGIN

@interface Token : NSObject

@property (nonatomic, assign, readonly) NSUInteger kind;
@property (nonatomic, copy,   readonly) NSString *text;
@property (nonatomic, strong, readonly) Position *pos;
@property (nonatomic, assign, readonly) NSUInteger code;

+ (instancetype)createWithKind:(NSUInteger)kind
                          text:(NSString *)text
                           pos:(nullable Position *)pos
                          code:(NSUInteger)code;


@end

NS_ASSUME_NONNULL_END
