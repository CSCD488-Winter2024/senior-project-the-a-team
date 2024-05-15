import firebase_admin
from firebase_admin import auth, db, messaging, exceptions, firestore
from firebase_functions import firestore_fn


firebase_admin.initialize_app()

@firestore_fn.on_document_updated(document="_posts/{PostID}")
def send_post_notification(event: firestore_fn.Event[firestore_fn.Change]) -> None:

    postID = event.params["PostID"]
    #If deleted we exit the function.
    change = event.data
    if not change.after:
        print(f"Post removed :(")
        return
    db = firestore.client()

    #Get post info from db
    post_ref = db.collection("_posts").document(postID)
    get_header= post_ref.get({u'header'})
    header = u'{}'.format(get_header.to_dict()['header'])
    get_body= post_ref.get({u'body'})
    body = u'{}'.format(get_body.to_dict()['body'])
    if(len(body) > 20):body = body[0:20] + "..."

    #get users
    users_ref = db.collection("users").where("notificationToken","!=","none")
    users = users_ref.get()
    #get tokens
    tokens = []
    for user in users:
        token = user.get("notificationToken")
        tokens.append(token)
    #create notification
    notification = messaging.Notification(
        title="New Post: " + header,
        body=body,
    )

    # Send notifications to all tokens.
    msgs = [
        messaging.Message(token=token, notification=notification) for token in tokens
        #messaging.Message(token=token, notification=notification)
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