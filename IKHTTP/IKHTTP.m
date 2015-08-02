//
//  IKHTTP
//
//  Created by Ian Keen on 5/06/2015.
//  Copyright (c) 2015 IanKeen. All rights reserved.
//

#import "IKHTTP.h"

@implementation FileData
+(instancetype)fileWithMimeType:(NSString *)mimeType fieldName:(NSString *)filedName fileName:(NSString *)fileName data:(NSData *)data {
    FileData *instance = [[FileData alloc] initWithMimeType:mimeType fieldName:filedName fileName:fileName data:data];
    return instance;
}

-(instancetype)initWithMimeType:(NSString *)mimeType fieldName:(NSString *)fieldName fileName:(NSString *)fileName data:(NSData *)data {
    if (!(self = [super init])) { return nil; }
    _mimeType = mimeType;
    _fieldName = fieldName;
    _fileName = fileName;
    _data = data;
    return self;
}
@end