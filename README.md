# Central Security Hub State Machine

## Description

Stating the obvious, mvp

## Use

See Tools, deploy ECR, then build/upload containers, then deploy IaC

## Design

Environment
- Working in existing CT Environment
- Decided on severing an account into an isolated sandbox

Constrained Design
- Actions OIDC Deploys master IaC and updates the state machine from a gh environment
  - Variables can be set to indicate configuration dev/prod, and more
	- Terraform vends primary resources for deletion/state
    - Enable GuardDuty, Detector+
    - Enable Security Hub, Hub+ using defaults - Foundational & CIS
    - VPC when/if ECS
    - Vend/Update Step Function for managing config
      - Update Lambda images
      - Ignore layers to constrain to monolith QL/Security processes unless requested otherwise. Layers - immediate future.
    - Create DynamoDB Table(s)
    - Actions/RIE/UT/ECR Scan container QL loop for now, ECS future optional
    - X-Ray and CWM time constrained
    - S3/DDB lookup for custom configs for remediation - future/optional
    - Config delta if time
- Step Function for managing config
  - Interval/Event check & remediate
  - DDB for account state tracking at memeber init and update
  - Baseline and Config steps 
  - HealthCheck for state status and tracking
  - X-Ray & CWM metrics - Time Constrained
  - HealthCheck Config dump delta blob if time

### HLD Hosting
#### Env Phase 0
![Diagram HLD_Hosting](/assets/hld_hosting.jpg?raw=true "Diagram HLD Hosting")
##### Description
The following shows the overall environment hosting my demo. The account exists under it's own Sandbox OU nearly untethered from central services in the account.

Github Actions IaC design
- Init w/ OIDC as Auth
- Spec Docker, AWS+, Terraform, Ubuntu
- Deploy IaC/Delta
- State Machine if delta or IaC delta
  - Test Step Function UT
  - Package Lambda Images
  - Test Lambda Images with RIE
  - Deploy Images to ECR
  - Scan from ECR
  - Update State Machine if go
  - (Future) define on premise testing

### HLD Account
#### Account Phase 0
![Diagram LLD Phase 0](/assets/hld_account.jpg?raw=true "Diagram HLD Account")
##### Description
One simple environment to rule them all! No redundancy or excess, mvp. Assumes the enviornment is constrained to few enough regions to manage explcitily. Here it's USE 1&2. Ask was to make one master and auto other. I may hard code for demo.

Resources
- Existing Account OIDC Role
- Vend GuardDuty, Detector and depens
- Vend Security Hub, Hub and depens
- Configure master Security Hub and GuardDuty account
  - Plenty of Tf modules to augment this for master/multi-account configuration, ignoring for demo unless requested
- Vend VPC (Optional, For Future ECS)
  - IGW
  - Subnet Private
    - (Optional Future) ECS, Fargate - fractional intermittent
    - (For ECS/Future Compat) Lambda  
  - Subnet Public
    - NGW
- Configure ECR, Repository and depens
- Deploy DDB Table(s)
- Deploy State Machine with initial state in DDB
- Deploy S3 DDB Value Store (Optional, for future config expansion) 

### LLD Step Function Loop
#### App Loop Phase 0
![Diagram LLD App Loop Phase 0](/assets/lld_step_func_loop.jpg?raw=true "Diagram LLD Step Function Loop Phase 0")
##### Description
Details on how Actions needs to permit State Machine updates separate of general IaC, but also in sync with initial and subsequent IaC deployments. To start State Machine updates can be rigged to always trigger. The only conditional is the IaC phase.

Steps
- Action step checks on Python payload or IaC delta 
- State Machine
  - Action step runs UT
  - Action step RIE testing, basic/environmental
  - Action step loads ECR
  - Action step scans from ECR
  - Action step prime State Machine if go

### LLD Step Function App
#### App Phase 0
![Diagram LLD App Phase 0](/assets/lld_step_func.jpg?raw=true "Diagram LLD Step Function Phase 0")
![Diagram LLD App DB Phase 0](/assets/lld_step_func_ddb.jpg?raw=true "Diagram LLD Step Function DDB Phase 0")
##### Description
The State Machine is designed to acknowledge new organizational accounts and baseline them. The prompt also requests that configuration updates can be propogated requiring state. DDB has been requested as the state mechanism. Tracking failure is important. Leading with DDB state tracking is easier than upgrading later. Lastly, this state machine should be designed for safe concurrent executions. The design should ideally notify of an active failure in expected use, but not break if abusively triggered. If something isn't failed by time of HealthCheck, the design shouldn't concern itself with who are why. If a newer execution runs prior to an earlier, the latest run should not be the version cataloged. The latest version should be kept.

NFA
- **Entry** Check for member accounts and config changes
  - Notes
    - Runs on interval and events
    - Checks if new config exists, takes list
    - Checks if new members exist
  - Paths
    - **Baseline** if new members, for new members
    - **Config** if new configuration, for all accounts that existed prior
- **Baseline** Configure new member list
  - Notes
    - Adds members, LastRun, and FailedFrom status
    - Executes **Config**, for new members
  - Paths
    - **Config** for each new account
- **Config**
  - Notes
    - Gathers updates queued per account provided
    - Updates state per account in post
  - Paths
    - **Update** for each account with pending
    - **HealthCheck** for all in state in post
- **Update**
  - Notes
    - Applies update list to an account
  - Paths
    - **Config** returns status only
- **HealthCheck**
  - Notes
    - Iterates state noting outstanding in current run 
    - Updates state with total status
  - Path
    - **Exit**

DynamoDB Structure
- Status
  - Total
    - Type: Number
    - Total accounts
  - Failed
    - Type: Number
    - Total accounts failing
  - LatestVersion
    - Type: Number
    - Latest deployment version
  - AccountsManaged
    - Type: NumberSet
    - List accounts managed
  - ConfigList (can be broken into lookup and reference "Configs" to customs in s3 for complex - future)
    - Type: Map(String)
    - Configs apply list
- Account
  - Number
    - Type: Number
    - Account number
  - Role - Per prompt single account demo guidelines, but safe for future updates
    - Type: String 
    - Role to associate with run
  - LastRun
    - Type: Number
    - Last version run
  - FailedFrom
    - Type: Number
    - If failed, first version failed in sequence else None
