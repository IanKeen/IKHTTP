//
//  IKHTTP
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IKResults/AsyncResult.h>

@interface FileData : NSObject
+(instancetype)fileWithMimeType:(NSString *)mimeType fieldName:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)data;
@property (nonatomic, strong, readonly) NSString *mimeType;
@property (nonatomic, strong, readonly) NSString *fieldName;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSData *data;
@end

@protocol IKHTTP <NSObject>
-(AsyncResult *)GET:(NSString *)url parameters:(NSDictionary *)parameters;
-(AsyncResult *)PUT:(NSString *)url parameters:(NSDictionary *)parameters;
-(AsyncResult *)POST:(NSString *)url parameters:(NSDictionary *)parameters fileData:(FileData *)fileData;
-(AsyncResult *)PATCH:(NSString *)url parameters:(NSDictionary *)parameters;
-(AsyncResult *)DELETE:(NSString *)url parameters:(NSDictionary *)parameters;
@end