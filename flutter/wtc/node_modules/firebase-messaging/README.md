# firebase-messaging
[![npm](https://img.shields.io/npm/v/firebase-messaging.svg)](https://www.npmjs.com/package/firebase-messaging)

NodeJS module to send firebase messages

# Install
`npm install firebase-messaging`

## topic(topic, data, [, options, callback])
Send message to topic

## message(to, data, [, options, callback])
Send message to device
 
# Options
- *collapse_key* [**String**]
- *priority* [**String**]
- *time_to_live* [**Number**]
- *delay_while_idle* [**Boolean**]
- *notification* [**Object**]

[See Firebase Docs](https://firebase.google.com/docs/cloud-messaging/http-server-ref)

# Usage

```javascript

const firebase = require("firebase-messaging");

var client = new firebase(CLOUD_MESSAGING_KEY);

var data = {
    title: "@Test",
    content: "@Content"
};

var options = {
	delay_while_idle : true	
};

client.topic("news", data, options, function(result){
	// request err or message id
	console.log(result);	
});

client.message(DEVICE_TOKEN, data);

```
