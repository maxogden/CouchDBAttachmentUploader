//
//  CouchDBAttachmentUploader.h
//
//  Created by Andrew on 19/02/2011.
//  Copyright 2011 Red Robot Studios Ltd. All rights reserved.
//


#import "CouchDBAttachmentUploader.h"

@implementation CouchDBAttachmentUploadDelegate

@synthesize successCallback, failureCallback, responseData, uploader;

- (id)init {
    self = [super init];
    if(self) {
        responseData = [[NSMutableData data] retain];
    }
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:self.responseData 
                                               encoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"%@(\"%@\");", 
                    self.successCallback, 
                    [response stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [uploader writeJavascript:js];
    [response release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [uploader writeJavascript:[NSString stringWithFormat:@"%@(\"%@\");", 
                              self.failureCallback, 
                              [[error localizedDescription] 
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)dealloc {
    [successCallback release];
    [failureCallback release];
    [responseData release];
    [uploader release];
    [super dealloc];
}


@end;


@implementation CouchDBAttachmentUploader

- (void)upload:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options 
{
    if ([arguments count] < 2 ) {
        return;
    }
        
    NSString *successCallback = [arguments objectAtIndex:0];
    NSString *failureCallback = [arguments objectAtIndex:1];
    
    NSURL *filepath = [NSURL URLWithString:[options valueForKey:@"filepath"]];
    NSString *couchURI = [options valueForKey:@"couchURI"];
    NSString *docID = [options valueForKey:@"_id"];
    NSString *docRevision = [options valueForKey:@"_rev"];
    NSString *contentType = [options valueForKey:@"contentType"];
    NSString *httpMethod = [[options valueForKey:@"httpMethod"] uppercaseString];
    
    NSString *attachmentName = [options valueForKey:@"attachmentName"];
            
    if(contentType == nil)
        contentType = @"image/jpeg";
    
    if(httpMethod == nil)
        httpMethod = @"PUT";
    
    if(attachmentName == nil)
        attachmentName = @"attachment";
    
    if (![filepath isFileURL]) {
        [self writeJavascript:[NSString stringWithFormat:@"%@(\"Invalid file\");", failureCallback]];
        return;
    }
    
    NSString *couchPath = [[NSString pathWithComponents:
                            [NSArray arrayWithObjects:couchURI, 
                             docID, attachmentName, nil]] stringByStandardizingPath];
    
    NSString *urlprepare = [NSString stringWithFormat:@"%@", couchPath];
    
    if(docRevision != nil) {
        urlprepare = [NSString stringWithFormat:@"%@?rev=%@", urlprepare, docRevision];
    }
    
    NSURL *url = [NSURL URLWithString:urlprepare];

    NSLog(@"args: %@ %@", url, couchPath);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:httpMethod];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:filepath options:0 error:&error];
    if(data == nil) {
        [self writeJavascript:[NSString stringWithFormat:@"%@(\"%@\");", 
                               failureCallback, 
                               [[error localizedDescription] 
                                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return;
    }
    [req setHTTPBody:data];
    
    CouchDBAttachmentUploadDelegate *delegate = [[CouchDBAttachmentUploadDelegate alloc] init];
    delegate.uploader = self;
    delegate.successCallback = successCallback;
    delegate.failureCallback = failureCallback;
    
    [NSURLConnection connectionWithRequest:req delegate:delegate];
    [delegate release];
}

@end
