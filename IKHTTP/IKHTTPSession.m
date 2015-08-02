//
//  IKHTTPSession
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "IKHTTPSession.h"
#import <AFNetworking/AFNetworking.h>
#import <IKCore/NSObject+Null.h>
#import <IKResults/AsyncResult.h>
#import <IKCore/NSError+Init.h>

@interface IKHTTPSession ()
@property (nonatomic, strong) id<IKHTTPResponseHandler> responseHandler;
@property (nonatomic, copy) httpCommonHeaders commonHeaders;
@property (nonatomic, copy) httpCommonParameters commonParameters;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation IKHTTPSession
#pragma mark - Lifecycle
-(instancetype)initWithResponseHandler:(id<IKHTTPResponseHandler>)responseHandler
                         commonHeaders:(httpCommonHeaders)commonHeaders
                      commonParameters:(httpCommonParameters)commonParameters {
    
    if (!(self = [super init])) { return nil; }
    self.commonHeaders = commonHeaders;
    self.commonParameters = commonParameters;
    self.responseHandler = responseHandler;
    return self;
}

#pragma mark - Public - MSHTTP
-(AsyncResult *)GET:(NSString *)url parameters:(NSDictionary *)parameters {
    return [self HTTP:@"GET" url:url parameters:parameters fileData:nil];
}
-(AsyncResult *)PUT:(NSString *)url parameters:(NSDictionary *)parameters {
    return [self HTTP:@"PUT" url:url parameters:parameters fileData:nil];
}
-(AsyncResult *)POST:(NSString *)url parameters:(NSDictionary *)parameters fileData:(FileData *)fileData {
    return [self HTTP:@"POST" url:url parameters:parameters fileData:fileData];
}
-(AsyncResult *)PATCH:(NSString *)url parameters:(NSDictionary *)parameters {
    return [self HTTP:@"PATCH" url:url parameters:parameters fileData:nil];
}
-(AsyncResult *)DELETE:(NSString *)url parameters:(NSDictionary *)parameters {
    return [self HTTP:@"DELETE" url:url parameters:parameters fileData:nil];
}

#pragma mark - Private - Session
-(void)configureSessionManager {
    if (self.sessionManager == nil) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    NSDictionary *headers = (self.commonHeaders() ?: @{});
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

#pragma mark - Private - Requests
-(AsyncResult *)HTTP:(NSString *)method
                 url:(NSString *)url
          parameters:(NSDictionary *)parameters
            fileData:(FileData *)fileData {
    
    [self configureSessionManager];
    
    NSError *err = nil;
    NSURLRequest *request = nil;
    
    if (![NSObject nilOrEmpty:parameters] && ![NSObject nilOrEmpty:fileData]) {
        //JSON parameters AND a file attachment are not supported (not required at time of writing but added the case in case..)
        return [AsyncResult asyncResult:[Result failure:[NSError errorWithDomain:NSStringFromClass([self class]) description:@"Unsupported request (JSON & FileData)"]]];
        
    } else if ([NSObject nilOrEmpty:parameters] && ![NSObject nilOrEmpty:fileData]) {
        //Standard file upload (no JSON body)
        request = [self basicFileUpload:self.sessionManager method:method url:url parameters:[self parametersWithCommon:parameters] fileData:fileData error:&err];
        
    } else {
        //Default request
        request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:url parameters:[self parametersWithCommon:parameters] error:&err];
    }
    
    if (err) {
        return [AsyncResult asyncResult:[Result failure:err]];
    }
    
    if (request) {
        AsyncResult *result = [AsyncResult asyncResult];
        
        [[self.sessionManager
          dataTaskWithRequest:request
          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
              
              Result *httpResult =
              [self.responseHandler
               handleResponse:request
               response:(NSHTTPURLResponse *)response
               data:responseObject
               error:error];
              
              [result fulfill:httpResult];
              
          }] resume];
        return result;
        
    } else {
        return [AsyncResult asyncResult:[Result failure:[NSError errorWithDomain:NSStringFromClass([self class]) description:@"Unable to create the HTTP request"]]];
    }
}
-(NSURLRequest *)basicFileUpload:(AFHTTPSessionManager *)manager
                          method:(NSString *)method
                             url:(NSString *)url
                      parameters:(NSDictionary *)parameters
                        fileData:(FileData *)fileData
                           error:(NSError * __autoreleasing *)err {
    
    return [manager.requestSerializer
            multipartFormRequestWithMethod:method
            URLString:url
            parameters:parameters
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:fileData.data name:fileData.fieldName fileName:fileData.fileName mimeType:fileData.mimeType];
                
            } error:err];
}
-(NSDictionary *)parametersWithCommon:(NSDictionary *)params {
    NSMutableDictionary *result =
    [NSMutableDictionary dictionaryWithDictionary:(self.commonParameters == nil ? @{} : self.commonParameters())];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        result[key] = obj;
    }];
    
    return result;
}
@end
