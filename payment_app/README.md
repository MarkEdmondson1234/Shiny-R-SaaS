## Payment app

This holds code for handling the transactions: Firebase Auth handles the userId, Paddle the subscription status and Cloud Functions handles the communication between them.

### Paddle

Payments are using [Paddle.com](https://paddle.com/) - when a payment goes through paddle it will send a webhook request to the Firebase functions as described in folder `payment_app/fb_functions/`

The [Paddle webhook docs](https://developer.paddle.com/webhook-reference/intro) give some detail on what they do.

Each time a user subscribes via the JavaScript library, a webhook will be sent to the URL you get when you deploy the Cloud Function.

### Cloud Function

The python code in `payment_app/fb_functions/` will create a webhook endpoint.  Create it in the same project as the Firebase authentication if used.

You can copy-paste the code into Cloud Functions, which should then work for all webhooks from Paddle covering the events:

```python
    sub_events = ['subscription_created',
                  'subscription_updated',
                  'subscription_cancelled']
```

The Cloud Function creates a Firebase dataset called "subscriptions" with the document Id of the uid found in the "passthrough" field in the webhook.  This passthrough will be set to a JSON string like so:

```json
{"uid":"your-user-id"}
```

This is the format the R code uses to identify which Firebase user has which subscription.

The code includes a verification step, which verifies the webhook is coming from Paddle.  To pass the step, you need to paste in your Public key as detailed in [verifying webhooks](https://developer.paddle.com/webhook-reference/verifying-webhooks) and is found in your seller dashboard.
 
