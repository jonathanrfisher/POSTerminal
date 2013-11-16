//
//  SOAPConnection.m
//  POSTerminal
//
//  Created by Katherine Fisher on 11/5/13.
//  Copyright (c) 2013 Jonathan Fisher. All rights reserved.
//

#import "SOAPConnection.h"
#import "convertXMLtoJSON.h"

@interface SOAPConnection ()

@property (nonatomic) NSMutableData *webData;
@property (nonatomic) NSURLConnection *conn;
//@property (nonatomic) NSString *userName;
//@property (nonatomic) NSString *password;
@property (nonatomic) NSURL *urlToUse;
@property (nonatomic) NSString *methodType;
@property (nonatomic) NSDictionary *params;
@property (nonatomic) NSString *soapAction;
@property (nonatomic) id JSONObject;
//@property (nonatomic) BOOL connectionFinished;

@end


@implementation SOAPConnection

//userName: 2546
//password: 2546

- (NSMutableData *) resultData
{
    if(!_resultData)
    {
        if (!_webData)
        {
            _resultData = [NSMutableData data];
        }
        else
        {
            _resultData = self.webData;
        }
    }
    return _resultData;
}

//- (NSString*) userName
//{
//    if (!_userName){
//        _userName = @"2546";
//    }
//    return _userName;
//}
//
//- (NSString*) password
//{
//    if (!_password){
//        _password = @"2546";
//    }
//    return _password;
//}

- (NSURL *) urlToUse
{
    if (!_urlToUse)
    {
        _urlToUse = [NSURL URLWithString:@"http://jt.serveftp.net/Datacom/Server.asmx"];
    }
    return _urlToUse;
}

- (NSString *) methodType
{
    if (!_methodType)
    {
        _methodType = @"ValidateCredential";
    }
    return _methodType;
}

- (NSDictionary *) params
{
    if (!_params)
    {
        _params = @{@"Password" : [NSNumber numberWithInt:2546],
                    @"Username" : [NSNumber numberWithInt:2546],
                    };
    }
    return _params;
}


//- (id) makeConnection: (NSURL *) inputURL
- (void) makeConnection: (NSURL *) inputURL
         withMethodType: (NSString *) methodType
             withParams: (NSDictionary *) params
        usingParamOrder: (NSArray *) paramOrder
         withSOAPAction: (NSString *) soapAction;
{
//    if(!params)
//    {
//        [self makeConnection:inputURL withMethodType:methodType withSOAPAction:soapAction];
//    }
    
    self.urlToUse = inputURL;
    self.methodType = methodType;
    self.params = params;
    self.soapAction = soapAction;
    
    //NSLog(@"makeConnection PARAMETERS:\ninpuURL = %@\nmethodType = %@\nparams = %@\nparamOrder = %@\nsoapAction = %@",[inputURL description],methodType,[params description],[paramOrder description],soapAction);
    
    // Get the SOAP message format from the CRM Developer's Guide
    NSString *soapMsg =    [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n" "<soap:Body>\n<"];
                            
    soapMsg = [soapMsg stringByAppendingString:self.methodType];
    soapMsg = [soapMsg stringByAppendingString:@" xmlns=\"http://tempuri.org/\">\n"];
    
    //NSArray *dictKeys = [self.params allKeys];
    
    for (NSString *key in paramOrder)
    {
        NSString *keyName = key;
        NSString *keyValue = [[self.params objectForKey:key] description];
        
        soapMsg = [soapMsg stringByAppendingFormat:@"<%@>%@</%@>\n",keyName,keyValue,keyName];
    }
    
    
    
    soapMsg = [soapMsg stringByAppendingFormat:@"</%@>\n",self.methodType];
    
    soapMsg = [soapMsg stringByAppendingString:@"</soap:Body>\n</soap:Envelope>\n"];
    
    NSURL *url = self.urlToUse;
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMsg length]];
    
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:self.soapAction forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"req description:  %@",[req description]);
    //NSLog(@"soapMsg Contents:  %@",soapMsg);
    
    self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (self.conn) {
        self.webData = [NSMutableData data];
    }
    
//    dispatch_queue_t q = dispatch_queue_create("com.foo.samplequeue", NULL);
//    
//    dispatch_sync(q,
//                  ^{
//                      self.JSONObject = [soap makeConnection:self.url withMethodType:@"ValidateCredential" withParams:dict  usingParamOrder:paramOrder withSOAPAction:@"\"http://tempuri.org/ValidateCredential\""];
//                  }
//                  );

    //return self.JSONObject;
}

//- (void) makeConnection: (NSURL *) inputURL
//         withMethodType: (NSString *) methodType
//         withSOAPAction: (NSString *) soapAction;
//{
//    NSLog(@"Called make connection with no params");
//    
//    
//    
//    
//}



-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response
{
    [self.webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data
{
    [self.webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
    NSLog(@"connection didFailWithError: %@ %@", error.localizedDescription,[error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    //NSLog(@"DONE. Received Bytes: %d", [self.webData length]);
    NSString *theXML = [[NSString alloc]
                        initWithBytes:[self.webData mutableBytes]
                        length:[self.webData length]
                        encoding:NSUTF8StringEncoding];
    
    //---shows the XML--
    //NSLog(@"%@",theXML);
    
    NSString *JSONString = [self getSubstring:theXML betweenString:[self.methodType stringByAppendingString:@"Result"]];
    
    NSRange rangeToGetFromJSONString = NSMakeRange(1, JSONString.length - 3);
    
    JSONString = [JSONString substringWithRange:rangeToGetFromJSONString];
    
    //NSLog(@"%@",JSONString);
    
    convertXMLtoJSON *JSONConverter = [[convertXMLtoJSON alloc] init];
    
    id JSONObject = [JSONConverter convertToJSON:JSONString];
    
    self.JSONObject = JSONObject;
    
    //NSLog(@"Inside SOAPConnection after conversion from XML to JSON, self.JSONObject description = %@",[self.JSONObject description]);
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"playNotification" object:stuff];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isTheJSONReady" object:nil];
    //NSLog(@"INSIDE CONNECTIONDIDFINISH AFTER notification has been sent...");
    //self.connectionFinished = true;
    
//    NSData *JSONData = [NSJSONSerialization
//                        dataWithJSONObject:dictionary
//                        // Converts data - i.e. NSString, NSArray, NSDictionary - into JSON
//                        options:NSJSONWritingPrettyPrinted
//                        error:&error];
}

- (id) returnJSON
{
    return self.JSONObject;
}

- (NSString *)getSubstring:(NSString *)value betweenString:(NSString *)separator
{
    NSRange firstInstance = [value rangeOfString:separator];
    NSRange secondInstance = [[value substringFromIndex:firstInstance.location + firstInstance.length] rangeOfString:separator];
    NSRange finalRange = NSMakeRange(firstInstance.location + separator.length, secondInstance.location);
    
    return [value substringWithRange:finalRange];
}
    
@end




