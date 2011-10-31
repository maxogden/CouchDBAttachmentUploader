/*
*   PhoneGap CouchDB Attachment Uploader Plugin
*   Copyright 2011 Red Robot Studios Ltd. All rights reserved.
*   Based on Matt Kane's File Upload Plugin
*/


var CouchDBAttachmentUploader = function() {}

CouchDBAttachmentUploader.prototype.upload = function(err, success, options) {
    
    if(!options.progress) options.progress = function(bytes, total) {};
    
    var key = 'f' + CouchDBAttachmentUploader.callbackIdx++;
    CouchDBAttachmentUploader.callbackMap[key] = {
        success: function(result) {
            if (success) success(result);
            delete CouchDBAttachmentUploader.callbackMap[key]
        },
        failure: function(result) {
            if (err) err(result);
            delete CouchDBAttachmentUploader.callbackMap[key]
        },
        progress: options.progress
    }
    
    options.progressCallback = 'CouchDBAttachmentUploader.callbackMap.' + key + '.progress';
    
    var callback = CouchDBAttachmentUploader.callbackMap[key];
    return PhoneGap.exec(callback['success'], callback['failure'], 'com.phonegap.CouchDBAttachmentUploader', 'upload', [options]);
}

CouchDBAttachmentUploader.callbackMap = {};
CouchDBAttachmentUploader.callbackIdx = 0;

PhoneGap.addConstructor(function()  {
    if(!window.plugins) {
        window.plugins = {};
    }
    window.plugins.CouchDBAttachmentUploader = new CouchDBAttachmentUploader();
});
