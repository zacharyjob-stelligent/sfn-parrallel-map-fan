# Author
# 	Zachary Job
# Editors
#
# Notes
#   Centralized securty state machine  
# Description
#   

import datetime
import boto3
from shared import AccountsMgr

def lambda_handler(event, context):
    result = {}
    mgr = None

    mgr = AccountsMgr(event["result_entry"]["serialized"], True)
    result = mgr.ConfigAccount(event["result_config"])

    return result
