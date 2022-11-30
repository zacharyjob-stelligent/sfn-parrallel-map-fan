# Author
# 	Zachary Job
# Editors
#
# Notes
#   Centralized securty state machine  
# Description
#   

import os
#import datetime
#import boto3
from shared import AccountsMgr

def lambda_handler(event, context):
    result = ""
    mgr = None

#   DDB not currently active, no need
#
#    mgr = AccountsMgr(event["result_entry"]["serialized"], True)
#    mgr.updateAccountStates(event["result_final"])

    result = \
        "State machine result:\n" + \
        str(event)

    return result
