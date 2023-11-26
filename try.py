import base64
import numpy 
# import nacl

# # Replace these with your actual base64-encoded keys
# base64_public_key = "d5EhtScHawK1i0mkZHvn6SthePGIuyc6LbufFpuLkKo="
# base64_private_key = "D1c8G11lV1xJnFaeE5mAdFHWyVIQecvrmMCeDCzAApg="
# base64_signature = "fDQnPC/tjQ7t1kKGzMb1PYGHXQmQ2Nhs6M298TVCgGKqcdP6q5AtmdDmqUh/Hk4J1OMJmM1oA4MNArZegZ3IDg=="

# # Decode the base64-encoded keys and signature
# public_key = base64.b64decode(base64_public_key)
# private_key = base64.b64decode(base64_private_key)
# signature = base64.b64decode(base64_signature)

# # Your raw message string
# message = "callMEcrazy"

# # Verify the signature
# try:
#     verifying_key = signing.VerifyKey(public_key, encoder=encoding.Base64Encoder)
#     verifying_key.verify(message.encode('utf-8'), signature)
#     print("Signature is valid!")
# except Exception as e:
#     print(f"Signature verification failed: {e}")
