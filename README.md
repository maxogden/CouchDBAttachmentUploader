#CouchDbAttachmentUploader

Enables a PhoneGap app to push binary attachments straight to a CouchDB database. Built with Phonegap 1.0.0 RC2

###Installation + Usage

Drag the .h and .m into the `Plugins` folder through the XCode4 file browser. Choose `Create groups for any added folders` on the dialog.

Put this in yo HTMLz:

    <script src="pg-plugin-couchdb-attachment-upload.js"></script>

add key: `com.phonegap.CouchDBAttachmentUploader` value: `CouchDBAttachmentUploader` to the `Plugins` section of `PhoneGap.plist` in your app's `Supporting Files` directory.


    navigator.camera.getPicture(function(uri) {
      window.plugins.CouchDBAttachmentUploader.upload(
        function() { 
          console.log('success!')
        },
        function(err) { 
          console.log('err! ' + err)
        },
        {
          "filePath": uri,
          "couchURI": 'http://127.0.0.1:5984/test',
          "_id": "poo",
          "contentType": "image/jpeg",
          "httpMethod": "put",
          "attachmentName": "photo.jpg",
          "progress": function(bytes,total){
            console.log('progress: ' + (bytes/total) * 100 + 'PERCENT');
          }
        }
      );
    }, function(error) {
        console.log(error, null, "Camera Error");
    }, {quality: 50,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
    });


