//
//  SimpleType.h
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import "Type.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimpleType : Type

@property (nonatomic, copy) NSArray <SimpleType *> *upperTypes;

- (instancetype)initWithName:(NSString *)name
                  upperTypes:(NSArray <SimpleType *>*)upperTypes;



@end

NS_ASSUME_NONNULL_END
