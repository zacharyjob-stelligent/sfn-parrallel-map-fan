# Author
# 	Zachary Job
# Editors
#
# Notes
#   Centralized securty state machine shared accounts manager 
#   TODO - Inefficient, sloppy, fix
# Description
#   Class that should be initialized then serialized
#   for use by all invocations

#import os
#import datetime
import boto3
#import dataclasses
from typing import Final
from botocore.config import Config
from pydantic import Field
from pydantic import BaseModel

class AccountData(BaseModel):

    #Final
    HOST_ACCOUNT_TAG: Final[str] = "host_account"
    HOST_REGION_TAG: Final[str] = "host_region"
    APPLY_STATUS_TAG: Final[str] = "status_updated"
    APPLY_FAILURES_TAG: Final[str] = "failed"
    CONTROL_DIS_RATIONALE: Final[str] = \
        "Conflicting rule. Disabled by centrallized security state machine."
    #Variable
    is_managed: bool = True
    fsbp_standard_id: str = "fsbp_"
    cis_standard_id: str = "cis_"
    header: str = "arn:aws:securityhub:"
    conflict_fsbp_standards: dict[str, bool] = {}
    conflict_cis_standards: dict[str, bool] = {}
    master_accounts: dict[str, str] = {}
    child_accounts: dict[str, str] = {}
    new_accounts: dict[str, bool] = {}
    managed_accounts: dict[str, bool] = {}
    temp_region_selection: list[str] = []
#    #Future, dicatates the conflict function return structure
#    enable_custom_standards: dict[str, tuple[str. bool]] = {}

class AccountsMgr():

    #NOTE
    #
    #Should define data structure and let pydantic handle more 
    #Currently handling field verif with handoff for value verif
    #
    def __init__(self, config: dict, load: bool = False) -> None:

        okay = True
        level = 0
        error = ""
        error_field = ""
        error_type = "" #See comment below
        self.__parameters = AccountData()

        if not load: #User configured data checking

            if "master_region" in config:
                self.__parameters.header += config["master_region"] + ':'
            else:
                error_field = "master_region"
                error_type = "str - Account Number"
                okay = False
            if okay:
                if "temp_region_selection" in config:
                    self.__parameters.temp_region_selection = config["temp_region_selection"]
                else:
                    error_field = "temp_region_selection"
                    error_type = "list[str] - Regions"
                    okay = False
            if okay:
                if "master_accounts" in config:
                    #TODO: Upgrade so pydantic throws
                    try:
                        self.__parameters.master_accounts = config["master_accounts"]
                    except:
                        okay = False
                        level = 3
                else:
                    okay = False
                if not okay:
                    error_field = "master_accounts "
                    error_type = "dict[str, str] - Account Number, IAM Lambda Assume Role Arn"
            if okay:
                if "child_accounts" in config:
                    #TODO: Upgrade so pydantic throws
                    try:
                        self.__parameters.child_accounts = config["child_accounts"]
                    except:
                        okay = False
                        level = 3
                else:
                    okay = False
                if not okay:
                    error_field = "child_accounts"
                    error_type = "dict[str, str] - Account Number, IAM Lambda Assume Role Arn"
            if okay:
                if "managed_standards_disable" in config:
                    if "fsbp" in config["managed_standards_disable"]:
                        if "arn_name" not in config["managed_standards_disable"]["fsbp"]:
                            error_field = "fsbp -> arn_name"
                            error_type = "str - Standard arn sub identifier"
                            okay = False
                            level = 2
                        if okay:
                            if "version" not in config["managed_standards_disable"]["fsbp"]:
                                error_field = "fsbp -> version"
                                error_type = "str - Standard version"
                                okay = False
                                level = 2
                        if okay:
                            if "controls" not in config["managed_standards_disable"]["fsbp"]:
                                error_field = "fsbp -> controls"
                                error_type = "dict[str, bool] - Standard control arns, if master"
                                okay = False
                                level = 2
                    else:
                        error_field = "fsbp"
                        error_type = "dict[str, str | str, dict[str, bool]] -" + \
                                     "arn_name(str), version(str), controls(dict)"
                        okay = False
                        level = 1
                    if okay:
                        if "cis" in config["managed_standards_disable"]:
                            if "arn_name" not in config["managed_standards_disable"]["cis"]:
                                error_field = "cis -> arn_name"
                                error_type = "str - Standard arn sub identifier"
                                okay = False
                                level = 2
                            if okay:
                                if "version" not in config["managed_standards_disable"]["cis"]:
                                    error_field = "cis -> version"
                                    error_type = "str - Standard version"
                                    okay = False
                                    level = 2
                            if okay:
                                if "controls" not in config["managed_standards_disable"]["cis"]:
                                    error_field = "cis -> controls"
                                    error_type = "dict[str, bool] - Standard control arns, if master"
                                    okay = False
                                    level = 2
                        else:
                            error_field = "cis"
                            error_type = "dict[str, str | str, dict[str, bool]] -" + \
                                         "arn_name(str), version(str), controls(dict)"
                            okay = False
                            level = 1

                    #TODO: Upgrade so pydantic throws
                    if okay:
                        try:
                            self.__parameters.fsbp_standard_id += config["managed_standards_disable"]["fsbp"]["version"] 
                            self.__parameters.cis_standard_id += config["managed_standards_disable"]["cis"]["version"] 

                            for control, master in config["managed_standards_disable"]["fsbp"]["controls"].items():
                                self.__parameters.conflict_fsbp_standards[
                                        ":control/" +
                                        config["managed_standards_disable"]["fsbp"]["arn_name"] +
                                        "/v/" +
                                        config["managed_standards_disable"]["fsbp"]["version"] +
                                        "/" +
                                        control
                                    ] = master 

                            for control, master in config["managed_standards_disable"]["cis"]["controls"].items():
                                self.__parameters.conflict_cis_standards[
                                        ":control/" +
                                        config["managed_standards_disable"]["cis"]["arn_name"] +
                                        "/v/" +
                                        config["managed_standards_disable"]["cis"]["version"] +
                                        "/" +
                                        control
                                    ] = master 
                        except Exception as ex:
                            error_field = "Control attribute"
                            error_type = str(ex) 
                            okay = False
                            level = 3
                else:
                    error_field = "managed_standards_disable"
                    error_type = "dict[" + \
                                 "str, str | " + \
                                 "str, dict[str, str] |" + \
                                 "str, dict[str, str | str, dict[str, bool]]] - " + \
                                 "master_region, " + \
                                 "master_accounts, " + \
                                 "child_accounts, " + \
                                 "managed_standards_disable"
                    okay = False

            if not okay:
                if level == 0:
                    error = ", primary key not found. Expecting "
                elif level == 1:
                    error = ", managed_standards_disable key not found. Expecting "
                elif level == 2:
                    error = ", managed_standards_disable attribute key not found. Expecting "

                if level >= 3: #values 
                    if level == 3: #controls
                        error = ", attributes value formatting issue. Expecting "
                    else: #4, attribute
                        error = ", managed_standards_disable controls formatting issue. Expecting "
                    raise TypeError(''.join([error_field, error, error_type]))
                else:
                    raise KeyError(''.join([error_field, error, error_type]))

#        if "custom_standards_enable" in config:
#
#            #TODO
#            #Placeholder
#            #
#            self.__parameters.enabled_custom_standards = config["custom_standards_enable"] 

        else:
            self.Deserialize(config)

    def Serialize(self) -> str:
        result = None

        #Let pydantic throw
        result = self.__parameters.dict()

        return result

    #Allow pydantic to handle errors now
    def Deserialize(self, serialized_dict: dict) -> None:
        #Let pydantic throw, show not have been modified
        self.__parameters = AccountData.parse_obj(serialized_dict)

    def __GetControlArn(self, account: str, control: str) -> str:
        return ''.join([self.__parameters.header, account, control])

    def GetIterable(self) -> list:
        result = []

#       TODO DDB get accounts under management
#       Removed hacked state, anticipate DDB light state ops
#
#       try:
#           print("TODO: " + str(todo_var))
#       except Exception as ex:
#           print("Error: " + str(ex))

        if self.__parameters.is_managed:
            result = list(self.__parameters.managed_accounts.keys())
        else:
            result = list(self.__parameters.new_accounts.keys())

        return result

    def StatAccountsManaged(self) -> dict:
        result = True

#       TODO DDB get accounts under management
#       Removed hacked state, anticipate DDB light state ops
#
#       try:
#           print("TODO: " + str(todo_var))
#       except Exception as ex:
#           print("Error: " + str(ex))

        #TODO update, no state - treating all as new
        for account in self.__parameters.master_accounts:
            if account not in self.__parameters.managed_accounts:
                self.__parameters.new_accounts[account] = True
        for account in self.__parameters.child_accounts:
            if account not in self.__parameters.managed_accounts:
                self.__parameters.new_accounts[account] = False

        self.__parameters.is_managed = True 

        return result

    def SelectNewAccounts(self) -> None:
        self.__parameters.is_managed = False 

    def InitNewAccountStates(self) -> bool:
        result = True

#        TODO DDB add new account states
#        Removed hacked state, anticipate DDB light state ops
#
#        try:
#            print("TODO: " + str(todo_var))
#        except Exception as ex:
#            print("Error: " + str(ex))

        return result

    def UpdateAccountStates(self, results: list) -> bool:
        result = True

#        TODO DDB updated with run status
#
#        try:
#            print("TODO: " + str(todo_var))
#        except Exception as ex:
#            print("Error: " + str(ex))

        return result

    #TODO
    #
    #Needs region update, recommend just forcing
    #explicit region definition for now
    #
    def ConfigAccount(self, account: str) -> dict:
        is_master = False
        result = {}
        session = None
        config_sts = None
        config_hub = None
        sts_session = None
        response = None
        hub_client = None
        sts_client = None
        fsbp_complete = True
        cis_complete = True
        fsbp_failures = set()
        cis_failures = set()
        assume_role_arn = ""
#        customs_complete = True

        #Decided to just let this throw, map fanning prevents
        #Not subject to user error, initial config generates 
        #this path and an error would be a source issue
        if self.__parameters.is_managed:
            if self.__parameters.managed_accounts[account]:
                assume_role_arn = self.__parameters.master_accounts[account] 
            else:
                assume_role_arn = self.__parameters.child_accounts[account] 
        else:
            if self.__parameters.new_accounts[account]:
                assume_role_arn = self.__parameters.master_accounts[account] 
            else:
                assume_role_arn = self.__parameters.child_accounts[account]

        if self.__parameters.is_managed:
            is_master = self.__parameters.managed_accounts[account]
        else:
            is_master = self.__parameters.new_accounts[account]

        result[self.__parameters.APPLY_FAILURES_TAG] = {}
        result[self.__parameters.APPLY_FAILURES_TAG][self.__parameters.fsbp_standard_id] = []
        result[self.__parameters.APPLY_FAILURES_TAG][self.__parameters.cis_standard_id] = []
#        result[self.__parameters.APPLY_FAILURES_TAG][self.__parameters.customs_standard_id] = set() 
        result[self.__parameters.APPLY_STATUS_TAG] = True

        #Decided to use native and play with adaptive
        #Standard for prod
        #Not much benefit from a custom handler, run short
        #and let the next pickup interval when eventbridge
        #kicks dictate durability
        config_sts = Config(
           retries={
              'max_attempts': 5,
              'mode': 'adaptive'
           }
        )

        session = boto3.Session()
        sts_client = session.client("sts", config=config_sts)
        response = sts_client.assume_role(
                RoleArn=assume_role_arn,
                RoleSessionName="central-security-sfn-" + str(account) 
            )

        sts_session = boto3.Session(
            aws_access_key_id=response['Credentials']['AccessKeyId'],
            aws_secret_access_key=response['Credentials']['SecretAccessKey'],
            aws_session_token=response['Credentials']['SessionToken'])

        #Disjoint hub multiple region capability demo
        #not intended for prod
        for temp_region in self.__parameters.temp_region_selection:
            config_hub = Config(
               retries={
                  'max_attempts': 5,
                  'mode': 'adaptive'
               },
               region_name=temp_region
            )

            try:
                hub_client = sts_session.client("securityhub", config=config_hub)
            except Exception as ex:
                print("STS error getting credentials: " + str(ex))
                fsbp_failures.add("-1")
                cis_failures.add("-1")
                break

            for fsbp_arn, for_master in self.__parameters.conflict_fsbp_standards.items():
                try:
                    if (is_master and for_master) or not is_master:
                        hub_client.update_standards_control(
                            StandardsControlArn=self.__GetControlArn(account, fsbp_arn),
                            ControlStatus='DISABLED',
                            DisabledReason=self.__parameters.CONTROL_DIS_RATIONALE)
                except Exception as ex:
                    print("Error apply fsbp: " + str(ex))
                    fsbp_failures.add(fsbp_arn)
                    fsbp_complete = False
                    result[self.__parameters.APPLY_STATUS_TAG] = False

            for cis_arn, for_master in self.__parameters.conflict_cis_standards.items():
                try:
                    if (is_master and for_master) or not is_master:
                        hub_client.update_standards_control(
                            StandardsControlArn=self.__GetControlArn(account, cis_arn),
                            ControlStatus='DISABLED',
                            DisabledReason=self.__parameters.CONTROL_DIS_RATIONALE)
                except Exception as ex:
                    print("Error apply cis: " + str(ex))
                    cis_failures.add(cis_arn)
                    cis_complete = False
                    result[self.__parameters.APPLY_STATUS_TAG] = False

        if cis_complete: 
            result[self.__parameters.APPLY_FAILURES_TAG].pop(self.__parameters.cis_standard_id)
        else:
            result[self.__parameters.APPLY_FAILURES_TAG][self.__parameters.cis_standard_id] = list(cis_failures)

        if fsbp_complete: 
            result[self.__parameters.APPLY_FAILURES_TAG].pop(self.__parameters.fsbp_standard_id)
        else:
            result[self.__parameters.APPLY_FAILURES_TAG][self.__parameters.fsbp_standard_id] = list(fsbp_failures)

        #TODO
        #
        #Enable customs here
#        result[self.__parameters.APPLY_FAILURES_TAG].pop(self.__parameters.customs_standard_id)

        if result[self.__parameters.APPLY_STATUS_TAG]:
            result.pop(self.__parameters.APPLY_FAILURES_TAG)

        return result
