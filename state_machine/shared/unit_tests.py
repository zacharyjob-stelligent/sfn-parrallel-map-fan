# Author
# 	Zachary Job
# Editors
#
# Notes
#   Unit Tests targeting user input init phase
#   TODO add blackbox
# Description
    #   Template to accomplish exercises

import unittest
import functools
from pydantic import BaseModel
from shared import AccountsMgr

#class sampleTester: # (unittest.TestCase) 
#
#    def setUp(self):
#        self._something = someObject()
#
#    def test_doSomething(self):
#        result = True
#
#        self._something.someFunction()
#        
#        return result
#
#    def tearDown(self):
#        return True

class testAccountsManager(unittest.TestCase): 

    def setUp(self):
        self._test_entry_bad_0 = {}
        self._test_entry_bad_1 = {
            "master_region": "us-east-1",
            "temp_region_selection": ["us-east-1"],
            "master_accounts": {
              "302068939047": "arn:aws:iam::302068939047:role/central_security_temp_demo"
            },
            "child_accounts": {},
            "managed_standards_disable": {
              "fsbp": {
                "version": "1.0.0",
                "arn_name": "aws-foundational-security-best-practices",
                "controlz": {
                  "Config.1": True
                }
              },
              "cis": {
                "version": "1.2.0",
                "arn_name": "cis-aws-foundations-benchmark",
                "controls": {
                  "2.7": False
                }
              }
            },
            "custom_standards_enable": {}
          }
        self._test_entry_bad_2 = {
            "master_region": "us-east-1",
            "master_accounts": {
              "302068939047": "arn:aws:iam::302068939047:role/central_security_temp_demo"
            },
            "child_accounts": {},
            "managed_standards_disable": {
              "fsbp": {
                "version": "1.0.0",
                "arn_name": "aws-foundational-security-best-practices",
                "controls": {
                  1: True
                }
              },
              "cis": {
                "version": "1.2.0",
                "arn_name": "cis-aws-foundations-benchmark",
                "controls": {
                  "2.7": False
                }
              }
            },
            "custom_standards_enable": {}
          }
        self._test_entry_bad_3 = {
            "master_region": "us-east-1",
            "temp_region_selection": ["us-east-1"],
            "master_accounts": {
              "302068939047": "arn:aws:iam::302068939047:role/central_security_temp_demo"
            },
            "child_accounts": {},
            "managed_standards_disable": {
              "fsbp": {
                "version": "1.0.0",
                "arn_name": "aws-foundational-security-best-practices",
                "controls": {
                  "x": "test"
                }
              },
              "cis": {
                "version": "1.2.0",
                "arn_name": "cis-aws-foundations-benchmark",
                "controls": {
                  "2.7": False
                }
              }
            },
            "custom_standards_enable": {}
          }
        self._test_entry_ok = {
            "master_region": "us-east-1",
            "temp_region_selection": ["us-east-1"],
            "master_accounts": {
              "302068939047": "arn:aws:iam::302068939047:role/central_security_temp_demo"
            },
            "child_accounts": {},
            "managed_standards_disable": {
              "fsbp": {
                "version": "1.0.0",
                "arn_name": "aws-foundational-security-best-practices",
                "controls": {
                  "Config.1": True,
                  "IAM.1": False,
                  "IAM.2": False,
                  "IAM.3": False,
                  "IAM.4": False,
                  "IAM.5": False,
                  "IAM.6": False,
                  "IAM.7": False,
                  "IAM.8": False,
                  "IAM.21": False,
                  "KMS.1": False,
                  "KMS.2": False
                }
              },
              "cis": {
                "version": "1.2.0",
                "arn_name": "cis-aws-foundations-benchmark",
                "controls": {
                  "2.7": False,
                  "1.2": False,
                  "1.3": False,
                  "1.4": False,
                  "1.5": False,
                  "1.6": False,
                  "1.7": False,
                  "1.8": False,
                  "1.9": False,
                  "1.10": False,
                  "1.11": False,
                  "1.12": False,
                  "1.13": False,
                  "1.14": False,
                  "1.16": False,
                  "1.20": False,
                  "1.22": False,
                  "2.5": True,
                  "1.1": True,
                  "3.1": True,
                  "3.2": True,
                  "3.3": True,
                  "3.4": True,
                  "3.5": True,
                  "3.6": True,
                  "3.7": True,
                  "3.8": True,
                  "3.9": True,
                  "3.10": True,
                  "3.11": True,
                  "3.12": True,
                  "3.13": True,
                  "3.14": True
                }
              }
            },
            "custom_standards_enable": {}
          }

    def test_Reload(self):
        result = True
        serialize_0 = ""
        serialize_1 = ""
        tester = None

        tester = AccountsMgr(self._test_entry_ok)
        print(tester.Deserialize(tester.Serialize()))
        serialize_0 = tester.Serialize()
        print(tester.Deserialize(tester.Serialize()))
        serialize_1 = tester.Serialize()

        result = serialize_0 == serialize_1

        print("Serialize Go?: " + str(result))

        return result

    def test_BlankConfig(self):
        result = False 
        tester = None

        try:
            tester = AccountsMgr(self._test_entry_bad_0)
        except Exception as ex:
            result = True
            print("BlankConfig Go: " + str(ex))

        return result

    def test_BadAttrConfig(self):
        result = False 
        tester = None

        try:
            tester = AccountsMgr(self._test_entry_bad_1)
        except Exception as ex:
            result = True
            print("BadAttrConfig Go: " + str(ex))

        return result

    def test_BadEntryKeyTypeConfig(self):
        result = False 
        tester = None

        try:
            tester = AccountsMgr(self._test_entry_bad_2)
        except Exception as ex:
            result = True
            print("BadEntryKeyTypeConfig Go: " + str(ex))

        return result

    #TODO, need validators
#    def test_BadEntryTypeConfig(self):
#        result = False 
#        tester = None
#
#        try:
#            tester = AccountsMgr(self._test_entry_bad_3)
#        except Exception as ex:
#            result = True
#            print("BadEntryValueTypeConfig Go: " + str(ex))
#
#        return result

    def test_SetsAndIterable(self):
        result = False 
        tester = None
        iterable_0 = [] 
        iterable_1 = []

        try:
            tester = AccountsMgr(self._test_entry_ok)
            tester.StatAccountsManaged()#TODO, no dynamo right now - add debug switch
            iterable_0 = tester.GetIterable()
            tester.SelectNewAccounts
            iterable_1 = tester.GetIterable()
        except Exception as ex:
            print("SetsAndIterable Fail: " + str(ex))

        result = \
            functools.reduce(
                lambda x, y: x and y,
                map(lambda i, j: i == j,
            iterable_0,iterable_1), True)

        print("SetsAndIterable Go?: " + str(result))

        return result

#    def test_Config(self):
#        result = False 
#
#        #TODO, debug switches
#
#        return result

    def tearDown(self):
        return True

if __name__ == '__main__':
    unittest.main()
