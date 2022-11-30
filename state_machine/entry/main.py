# Author
# 	Zachary Job
# Editors
#
# Notes
#   Centralized securty state machine entry 
# Description
#   Gather information for the state machine to
#   appropriately branch

import os
import datetime
import boto3
from shared import AccountsMgr
       
def lambda_handler(event, context):
    result = {}
    mgr = None

    mgr = AccountsMgr(event["parameters"])
    mgr.StatAccountsManaged()

    result["serialized"] = mgr.Serialize()
    result["iterable"] = mgr.GetIterable()

    return result
