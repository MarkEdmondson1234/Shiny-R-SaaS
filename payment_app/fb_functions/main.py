# Your Paddle public key.
public_key = '''-----BEGIN PUBLIC KEY-----
YOUR_PUBLIC_KEY_HERE
-----END PUBLIC KEY-----'''

import collections
import base64
import logging
from google.cloud import firestore
import json

def update_firebase(data, collection, doc_id):
    logging.info('fb update - collection {} doc_id {}'.format(collection, doc_id))

    db = firestore.Client()
    doc_ref = db.collection(collection).document(doc_id)
    doc_ref.set(data)

    # add the event
    event_ref = db.collection(collection).document(doc_id).collection('event').document(data['alert_id'])
    event_ref.set(data)   

     

def verify(input_data):
    # Crypto can be found at https://pypi.org/project/pycryptodome/
    from Crypto.PublicKey import RSA
    try:
        from Crypto.Hash import SHA1
    except ImportError:
        # Maybe it's called SHA
        logging.debug('Import SHA')
        from Crypto.Hash import SHA as SHA1
    try:
        from Crypto.Signature import PKCS1_v1_5
    except ImportError:
        # Maybe it's called pkcs1_15
        logging.debug('Import pksc1_15')
        from Crypto.Signature import pkcs1_15 as PKCS1_v1_5
    import hashlib
    import phpserialize

    # Convert key from PEM to DER - Strip the first and last lines and newlines, and decode
    public_key_encoded = public_key[26:-25].replace('\n', '')
    public_key_der = base64.b64decode(public_key_encoded)

    # input_data represents all of the POST fields sent with the request
    # Get the p_signature parameter & base64 decode it.
    signature = input_data['p_signature']

    # Remove the p_signature parameter
    del input_data['p_signature']

    # Ensure all the data fields are strings
    for field in input_data:
        input_data[field] = str(input_data[field])

    # Sort the data
    sorted_data = collections.OrderedDict(sorted(input_data.items()))

    # and serialize the fields
    serialized_data = phpserialize.dumps(sorted_data)

    # verify the data
    key = RSA.importKey(public_key_der)
    digest = SHA1.new()
    digest.update(serialized_data)
    verifier = PKCS1_v1_5.new(key)
    signature = base64.b64decode(signature)
    if verifier.verify(digest, signature):
        print('Signature is valid')
        return True
    else:
        print('The signature is invalid!')
        return False

def paddle(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_data = request.form.to_dict()

    logging.info(request_data)
    
    verified = False
    try:
        verified = verify(request_data)
    except Exception as ex:
        print(ex)

    if not verified:
      return "Not Verified!"

    uid = None
    try:
        # should contain json of form {"uid":"an_id"}
        passthrough = request_data.get('passthrough')

        if passthrough:
            p_obj = json.loads(passthrough)
        else:
            return "No passthrough"
        
        uid = p_obj.get('uid')

        if not uid:
            return "No passthrough['uid']"

    except Exception as ex:
        print(ex)
        return "Error fetching passthrough uid"
    
    logging.info('passthrough uid: ' + uid)

    alert = request_data['alert_name']

    sub_events = ['subscription_created',
                  'subscription_updated',
                  'subscription_cancelled']

    if alert in sub_events and uid:
        update_firebase(request_data, 'subscriptions', uid)
        return "Subscription: " + alert

    return 'No update made'
