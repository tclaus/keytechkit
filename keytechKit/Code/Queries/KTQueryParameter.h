//
//  KTQueryParameter.h
//  keytechkit
//
//  Created by Thorsten Claus on 03.07.18.
//

#import <Foundation/Foundation.h>

@interface KTQueryParameter : NSObject

@property (nonatomic) NSString *attributeName;
@property (nonatomic) NSString *attributeType;
@property (nonatomic) NSString *attributeText;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *operatorType;
@property (nonatomic) NSString *operatorLocalizedText;
@property (nonatomic) NSString *operatorConcatLocalizedText;
@property (nonatomic) NSArray<NSString*> *originalValues;

@end
