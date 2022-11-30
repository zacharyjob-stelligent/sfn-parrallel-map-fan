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
    mgr.SelectNewAccounts()
    mgr.InitNewAccountStates()

    result["serialized"] = mgr.Serialize()
    result["iterable"] = mgr.GetIterable()

    return result
