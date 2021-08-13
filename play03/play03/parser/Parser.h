//
//  Parser.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"
#import "Prog.h"
#import "Scanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parser : NSObject

- (instancetype)initWithTokenizer:(Tokenizer *)tokenizer;
- (instancetype)initWithScanner:(Scanner *)scanner;

- (Prog *)parseProg;
@end

NS_ASSUME_NONNULL_END
