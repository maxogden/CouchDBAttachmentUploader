#CouchDbAttachmentUploader

Enables a PhoneGap app to push binary attachments straight to a CouchDB database. Built with Phonegap 1.0.0 RC2

###Usage

add key: `com.phonegap.CouchDBAttachmentUploader` value: `CouchDBAttachmentUploader` to the `Plugins` section of `PhoneGap.plist` in your app's `Supporting Files` directory.

Put the .h and .m files of the plugin in your Xcode project and add the .js file to your www folder.

    navigator.camera.getPicture(function(uri) {
      window.plugins.CouchDBAttachmentUploader.upload(
        {
          "filepath": uri,
          "couchURI": 'http://127.0.0.1:5984/test',
          "_id": "poo",
          "contentType": "image/jpeg",
          "httpMethod": "put",
          "attachmentName": "photo.jpg"
        },
        function() { 
          console.log('success!')
        },
        function(error) {
          console.log('error!', error)
        }
      );
    }, function(error) {
        console.log(error, null, "Camera Error");
    }, {quality: 50,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
    });


