import firebase_admin
from firebase_admin import auth, db, messaging, exceptions
from firebase_functions import firestore_fn

firebase_admin.initialize_app()

@firestore_fn.on_document_updated(document="_posts/{PostID}")
def send_post_notification(event: firestore_fn.Event[firestore_fn.Change]) -> None:
    #post_uid = event.params["postID"]

    #If deleted we exit the function.
    change = event.data
    if not change.after:
        print(f"Post removed :(")
        return

    print(f"Post is now posted")
    #get all tokens
    #tokens_ref = firestore_fn.DocumentReference(f"users/taterstimmy@gmail.com/notificationToken")
    #notification_tokens = tokens_ref.get()
    #if (not isinstance(notification_tokens, dict) or len(notification_tokens) < 1):
    #    print("There are no tokens to send notifications to.")
    #    return
    #print(f"There are {len(notification_tokens)} tokens to send notifications to.")
    #create notification
    notification = messaging.Notification(
        title="New Post",
        body=f"New post has been posted",
    )
    token = "dlxLoRG4Q76iu-QHlcHEwX:APA91bHZxUoOCo_hIq62f-r4jXilmp2CfP4tn6ZASba9i74TTz7fYLBrgypaZRexzhjq9MHJ1zhi4dHRfxcNA5wGkOteTANT-vRJc_8brTM_XtJpaFYb6JnCnX0MvVvY2FXA8MNK1g7T"
    # Send notifications to all tokens.
    msgs = [
        #messaging.Message(token=token, notification=notification) for token in notification_tokens
        messaging.Message(token=token, notification=notification)
    ]
    batch_response: messaging.BatchResponse = messaging.send_each(msgs)
    if batch_response.failure_count < 1:
        # Messages sent successfully. We're done!
        return

    # Clean up the tokens that are not registered any more.
    for i in range(len(batch_response.responses)):
        exception = batch_response.responses[i].exception
        if not isinstance(exception, exceptions.FirebaseError):
            continue
        message = exception.http_response.json()["error"]["message"]
        #if (isinstance(exception, messaging.UnregisteredError) or
            #    message == "The registration token is not a valid FCM registration token"):
            #tokens_ref.child(msgs[i].token).delete()