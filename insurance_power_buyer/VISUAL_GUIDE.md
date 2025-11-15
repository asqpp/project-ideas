# SYSTEM ARCHITECTURE & VISUAL GUIDE
## Insurance Power Buyer Management System

---

## SYSTEM ARCHITECTURE DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────┐
│                     USER INTERFACE LAYER                             │
│  (Web App, Mobile App, Desktop App, REST API)                       │
└────────────────────┬────────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER (Python)                        │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │   Customer   │  │    Policy    │  │    Claims    │             │
│  │   CRUD       │  │    CRUD      │  │    CRUD      │             │
│  │   Module     │  │    Module    │  │    Module    │             │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘             │
│         │                 │                 │                       │
│  ┌──────────────┐  ┌──────────────┐                                │
│  │   Payment    │  │    Agent     │                                │
│  │   CRUD       │  │    CRUD      │                                │
│  │   Module     │  │    Module    │                                │
│  └──────┬───────┘  └──────┬───────┘                                │
│         │                 │                                         │
│         └────────┬────────┴────────┬────────────────┘              │
│                  │                 │                                │
│                  ▼                 ▼                                │
│       ┌──────────────────────────────────┐                         │
│       │   SQLAlchemy ORM Layer           │                         │
│       │                                   │                         │
│       │  • Model Validation              │                         │
│       │  • Relationship Management       │                         │
│       │  • Transaction Handling          │                         │
│       │  • Query Building                │                         │
│       │  • Connection Pooling            │                         │
│       └────────────┬─────────────────────┘                         │
└────────────────────┼──────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DATABASE LAYER                                  │
│                   MySQL / PostgreSQL                                 │
│                                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │Customer  │  │ Policy   │  │  Claims  │  │ Payment  │           │
│  │  Tables  │  │  Tables  │  │  Tables  │  │  Tables  │           │
│  │   (3)    │  │   (6)    │  │   (2)    │  │   (2)    │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │  Agent   │  │ Branch   │  │  User    │  │  Audit   │           │
│  │  Tables  │  │  Table   │  │  Table   │  │  Table   │           │
│  │   (3)    │  │   (1)    │  │   (1)    │  │   (1)    │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                                                                      │
│  Features: Indexes, Foreign Keys, Triggers, Views, Procedures       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## DATA FLOW DIAGRAMS

### CUSTOMER REGISTRATION FLOW

```
User Fills Registration Form
         │
         ▼
┌────────────────────────┐
│  Input Validation      │
│  • Email format        │
│  • Phone format        │
│  • Age >= 18           │
│  • PAN format          │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Duplicate Check       │
│  • Email unique        │
│  • Phone unique        │
│  • PAN unique          │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Generate Customer ID  │
│  CUST-YYYYMMDD-XXXX    │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Database Transaction  │
│  BEGIN                 │
│  ├─ Insert Customer    │
│  ├─ Insert Address     │
│  └─ Insert Audit Log   │
│  COMMIT                │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│  Post-Creation         │
│  • Send Welcome Email  │
│  • Assign Loyalty Pts  │
│  • Trigger KYC        │
└────────────────────────┘
```

### POLICY ISSUANCE FLOW

```
Agent Creates Policy Application
         │
         ▼
┌─────────────────────────────────────┐
│  Customer Validation                │
│  ├─ Customer exists?                │
│  ├─ KYC verified?                   │
│  ├─ Age eligible?                   │
│  └─ Status active?                  │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Policy Type Validation             │
│  ├─ Sum assured within limits?      │
│  ├─ Term within limits?             │
│  └─ Age within type limits?         │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Premium Calculation                │
│  ├─ Base premium                    │
│  ├─ Rider premiums                  │
│  ├─ GST/Tax                         │
│  ├─ Discounts                       │
│  └─ Total premium                   │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Underwriting (if required)         │
│  ├─ Sum assured > threshold?        │
│  ├─ Age > threshold?                │
│  ├─ Medical examination?            │
│  └─ Approval obtained?              │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Generate Policy Number             │
│  POL-[TYPE]-YYYY-XXXXXX             │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Database Transaction               │
│  BEGIN                              │
│  ├─ Insert Policy                   │
│  ├─ Insert Nominees                 │
│  ├─ Insert Riders                   │
│  ├─ Create Payment Schedule         │
│  ├─ Update Customer Policy Count    │
│  └─ Insert Audit Log                │
│  COMMIT                             │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Post-Issuance                      │
│  ├─ Generate Policy Document (PDF)  │
│  ├─ Generate Welcome Letter         │
│  ├─ Send Email to Customer          │
│  ├─ Send SMS Confirmation           │
│  ├─ Calculate Agent Commission      │
│  └─ Schedule First Reminder         │
└─────────────────────────────────────┘
```

### CLAIMS PROCESSING FLOW

```
Customer Submits Claim
         │
         ▼
┌─────────────────────────────────────┐
│  Claim Registration                 │
│  ├─ Generate Claim Number           │
│  │   CLM-YYYY-XXXXXX                │
│  ├─ Validate Policy Active          │
│  ├─ Check Waiting Period            │
│  ├─ Verify Exclusions               │
│  └─ Create Claim Record             │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Document Collection                │
│  ├─ Death Certificate               │
│  ├─ Medical Reports                 │
│  ├─ Police Report (if needed)       │
│  ├─ Nominee ID Proof                │
│  └─ Bank Details                    │
└──────────┬──────────────────────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  Document Verification              │
│  ├─ Assign to Examiner              │
│  ├─ Verify Each Document            │
│  ├─ Cross-check Information         │
│  └─ Update Status: Under Review     │
└──────────┬──────────────────────────┘
           │
           ├────────────────────┐
           │                    │
           ▼                    ▼
    ┌──────────────┐    ┌──────────────┐
    │ Investigation│    │  No          │
    │   Required?  │    │ Investigation│
    │              │    │              │
    │  Yes         │    │  Direct to   │
    └──────┬───────┘    │  Approval    │
           │            └──────┬───────┘
           ▼                   │
    ┌──────────────┐          │
    │ Investigation│          │
    │   Process    │          │
    │              │          │
    │  • Field     │          │
    │    Visit     │          │
    │  • Interviews│          │
    │  • Report    │          │
    └──────┬───────┘          │
           │                  │
           └────────┬─────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  Approval Workflow   │
         │                      │
         │  Amount < 100K:      │
         │  → Manager           │
         │                      │
         │  Amount < 500K:      │
         │  → Senior Manager    │
         │                      │
         │  Amount >= 500K:     │
         │  → Management        │
         │     Committee        │
         └──────────┬───────────┘
                    │
                    ├──────────────────┐
                    │                  │
                    ▼                  ▼
         ┌──────────────┐   ┌──────────────┐
         │   Approved   │   │   Rejected   │
         └──────┬───────┘   └──────┬───────┘
                │                  │
                ▼                  ▼
    ┌────────────────────┐  ┌──────────────┐
    │ Payment Processing │  │ Send         │
    │                    │  │ Rejection    │
    │ • Calculate Amount │  │ Letter with  │
    │ • Generate Voucher │  │ Reasons      │
    │ • Process Payment  │  │              │
    │ • Update Policy    │  └──────────────┘
    │ • Mark Claim Paid  │
    └────────────────────┘
```

### PAYMENT PROCESSING FLOW

```
Premium Payment Initiated
         │
         ▼
┌─────────────────────────────────────┐
│  Payment Method Selection           │
│                                     │
│  ┌─────────┐  ┌─────────┐          │
│  │  Cash   │  │ Cheque  │          │
│  └────┬────┘  └────┬────┘          │
│       │            │                │
│  ┌─────────┐  ┌─────────┐          │
│  │  Card   │  │   UPI   │          │
│  └────┬────┘  └────┬────┘          │
│       │            │                │
│  ┌─────────┐  ┌─────────┐          │
│  │  Bank   │  │ Auto-   │          │
│  │ Transfer│  │ Debit   │          │
│  └────┬────┘  └────┬────┘          │
└───────┼────────────┼────────────────┘
        │            │
        └─────┬──────┘
              │
              ▼
   ┌──────────────────────┐
   │ Payment Validation   │
   │ • Policy exists      │
   │ • Amount correct     │
   │ • Due date check     │
   └──────────┬───────────┘
              │
              ▼
   ┌──────────────────────┐
   │ Generate IDs         │
   │ • Payment ID         │
   │   PAY-YYYY-MM-XXXX   │
   │ • Receipt Number     │
   │   RCP-YYYY-XXXX      │
   │ • Transaction ID     │
   └──────────┬───────────┘
              │
              ▼
   ┌──────────────────────┐
   │ Process Payment      │
   │                      │
   │ IF Online:           │
   │ ├─ Gateway Call      │
   │ ├─ Get Response      │
   │ └─ Verify Status     │
   │                      │
   │ IF Offline:          │
   │ └─ Record Details    │
   └──────────┬───────────┘
              │
              ├────────────────┐
              │                │
              ▼                ▼
      ┌──────────┐    ┌──────────┐
      │ Success  │    │  Failed  │
      └─────┬────┘    └─────┬────┘
            │               │
            ▼               ▼
   ┌──────────────┐  ┌─────────────┐
   │ Update DB    │  │ Rollback &  │
   │              │  │ Notify User │
   │ • Save       │  └─────────────┘
   │   Payment    │
   │ • Update     │
   │   Policy     │
   │   Status     │
   │ • Update     │
   │   Schedule   │
   │ • Calculate  │
   │   Commission │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Generate     │
   │ Receipt PDF  │
   │              │
   │ • Payment    │
   │   Details    │
   │ • Policy     │
   │   Info       │
   │ • Next Due   │
   └──────┬───────┘
          │
          ▼
   ┌──────────────┐
   │ Send         │
   │ Confirmation │
   │              │
   │ • Email      │
   │ • SMS        │
   └──────────────┘
```

---

## DATABASE ENTITY-RELATIONSHIP DIAGRAM

```
┌──────────────────┐
│     BRANCHES     │
│──────────────────│
│ PK id            │
│    branch_code   │
│    branch_name   │
│    city          │
│    state         │
└────────┬─────────┘
         │
         │ 1:M
         │
    ┌────┴──────┬──────────────┬───────────────┐
    │           │              │               │
    ▼           ▼              ▼               ▼
┌─────────┐ ┌────────┐  ┌──────────┐   ┌─────────┐
│ AGENTS  │ │CUSTOMER│  │ POLICIES │   │  USERS  │
└─────────┘ └────────┘  └──────────┘   └─────────┘


DETAILED ER DIAGRAM:

┌───────────────────────┐       ┌───────────────────────┐
│      CUSTOMERS        │       │    CUSTOMER_         │
│──────────────────────│       │    ADDRESSES         │
│ PK id                 │───────│──────────────────────│
│    customer_id        │ 1:M   │ PK id                │
│    first_name         │       │ FK customer_id       │
│    last_name          │       │    address_type      │
│    email              │       │    address_line1     │
│    phone              │       │    city              │
│    date_of_birth      │       │    state             │
│    pan_number         │       │    pincode           │
│ FK branch_id          │       └──────────────────────┘
│ FK agent_id           │
│    kyc_status         │       ┌───────────────────────┐
│    status             │       │    CUSTOMER_KYC_     │
│    is_active          │       │    DOCUMENTS         │
└───────┬───────────────┘       │──────────────────────│
        │                       │ PK id                │
        │ 1:M                   │ FK customer_id       │
        │                       │    document_type     │
        └───────────────────────│    document_path     │
                                │    verification_     │
                                │    status            │
                                └──────────────────────┘

┌───────────────────────┐       ┌───────────────────────┐
│    POLICY_TYPES       │       │      POLICIES         │
│──────────────────────│       │──────────────────────│
│ PK id                 │       │ PK id                 │
│    policy_type_code   │───────│ FK policy_type_id     │
│    policy_type_name   │ 1:M   │ FK customer_id        │
│    min_sum_assured    │       │    policy_number      │
│    max_sum_assured    │       │    sum_assured        │
│    min_age            │       │    policy_term        │
│    max_age            │       │    annual_premium     │
│    base_premium_rate  │       │    status             │
│    surrender_value_   │       │    maturity_date      │
│    factor             │       │    current_policy_    │
└───────────────────────┘       │    year               │
                                │ FK agent_id           │
                                │ FK branch_id          │
                                └───────┬───────────────┘
                                        │
                        ┌───────────────┼────────────────┐
                        │               │                │
                        ▼               ▼                ▼
              ┌─────────────┐  ┌──────────────┐  ┌────────────┐
              │   POLICY_   │  │   POLICY_    │  │  PAYMENT_  │
              │  NOMINEES   │  │   RIDERS     │  │  SCHEDULES │
              │─────────────│  │──────────────│  │────────────│
              │ PK id       │  │ PK id        │  │ PK id      │
              │ FK policy_id│  │ FK policy_id │  │FK policy_id│
              │    nominee_ │  │ FK rider_id  │  │ installment│
              │    name     │  │    sum_      │  │ _number    │
              │    relation-│  │    assured   │  │ due_date   │
              │    ship     │  │    annual_   │  │ amount     │
              │    share_%  │  │    premium   │  │ status     │
              └─────────────┘  └──────────────┘  └────────────┘

┌───────────────────────┐       ┌───────────────────────┐
│       CLAIMS          │       │    CLAIM_            │
│──────────────────────│       │    DOCUMENTS         │
│ PK id                 │───────│──────────────────────│
│    claim_number       │ 1:M   │ PK id                │
│ FK policy_id          │       │ FK claim_id          │
│ FK customer_id        │       │    document_type     │
│    claim_type         │       │    document_path     │
│    date_of_event      │       │    verification_     │
│    claim_amount       │       │    status            │
│    approved_amount    │       └──────────────────────┘
│    status             │
│    priority           │
│ FK assigned_to        │
│ FK investigator_id    │
│ FK approved_by        │
└───────────────────────┘

┌───────────────────────┐       ┌───────────────────────┐
│      PAYMENTS         │       │      AGENTS           │
│──────────────────────│       │──────────────────────│
│ PK id                 │       │ PK id                 │
│    payment_id         │       │    agent_code         │
│    transaction_id     │       │    first_name         │
│ FK policy_id          │       │    last_name          │
│ FK customer_id        │       │    email              │
│    payment_method     │       │    phone              │
│    premium_amount     │       │    license_number     │
│    gst_amount         │       │    license_valid_till │
│    total_amount       │       │    pan_number         │
│    payment_date       │       │    first_year_comm_%  │
│    status             │       │    renewal_comm_%     │
│    receipt_number     │       │ FK branch_id          │
│    is_reconciled      │       │    status             │
└───────────────────────┘       │    is_active          │
                                └───────┬───────────────┘
                                        │
                                ┌───────┴────────┐
                                │                │
                                ▼                ▼
                        ┌───────────────┐  ┌──────────────┐
                        │    AGENT_     │  │  COMMISSIONS │
                        │   TARGETS     │  │──────────────│
                        │───────────────│  │ PK id        │
                        │ PK id         │  │FK agent_id   │
                        │ FK agent_id   │  │FK policy_id  │
                        │ target_period │  │FK payment_id │
                        │ premium_      │  │ commission_  │
                        │ target        │  │ type         │
                        │ premium_      │  │ commission_  │
                        │ achieved      │  │ amount       │
                        │ achievement_% │  │ tds_amount   │
                        └───────────────┘  │ net_comm     │
                                           │ status       │
                                           └──────────────┘
```

---

## WORKFLOW STATE MACHINES

### CUSTOMER STATUS WORKFLOW

```
    ┌──────────────────────────────────────────────┐
    │                                              │
    │            CUSTOMER LIFECYCLE                │
    │                                              │
    └──────────────────────────────────────────────┘

              ┌─────────────┐
              │   PENDING   │
              │ (New Regis- │
              │  tration)   │
              └──────┬──────┘
                     │
                     │ KYC Submitted
                     ▼
              ┌─────────────┐
              │   ACTIVE    │◄────────────┐
              │ (KYC        │             │
              │  Verified)  │             │
              └──────┬──────┘             │
                     │                    │
                ┌────┼────┐               │
                │         │               │
   Deactivated  │         │ Blocked       │ Reactivated
   (Admin)      │         │ (Fraud/       │
                │         │  Violation)   │
                ▼         ▼               │
         ┌──────────┐  ┌──────────┐      │
         │ INACTIVE │  │ BLOCKED  │      │
         └────┬─────┘  └────┬─────┘      │
              │             │             │
              └─────────────┴─────────────┘
```

### POLICY STATUS WORKFLOW

```
    ┌──────────────────────────────────────────────┐
    │                                              │
    │              POLICY LIFECYCLE                │
    │                                              │
    └──────────────────────────────────────────────┘

              ┌─────────────┐
              │   ACTIVE    │
              │ (In Force)  │
              └──────┬──────┘
                     │
       ┌─────────────┼─────────────┬───────────────┐
       │             │             │               │
       │Premium not  │Premium paid │Term completed │Customer
       │paid in      │             │               │requests
       │grace period │             │               │
       │             │             │               │
       ▼             ▼             ▼               ▼
  ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌────────────┐
  │ LAPSED  │  │ ACTIVE  │  │ MATURED  │  │SURRENDERED │
  │         │  │ (Cont.) │  │          │  │            │
  └────┬────┘  └─────────┘  └──────────┘  └────────────┘
       │
       │Revival premium
       │paid within
       │revival period
       │
       ▼
  ┌─────────┐
  │ ACTIVE  │
  │(Revived)│
  └─────────┘
       │
       │No revival
       │after period
       │
       ▼
  ┌─────────┐
  │ PAID-UP │
  │(Reduced │
  │Coverage)│
  └─────────┘
```

### CLAIM STATUS WORKFLOW

```
    ┌──────────────────────────────────────────────┐
    │                                              │
    │            CLAIMS PROCESSING                 │
    │                                              │
    └──────────────────────────────────────────────┘

              ┌──────────────┐
              │ REGISTERED   │
              │ (New Claim)  │
              └──────┬───────┘
                     │
                     │Documents
                     │Submitted
                     ▼
              ┌──────────────┐
              │ UNDER REVIEW │
              │ (Examiner    │
              │  Assigned)   │
              └──────┬───────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         │Investigation          │No Investigation
         │Required               │Required
         │                       │
         ▼                       ▼
  ┌──────────────┐        ┌─────────────┐
  │INVESTIGATION │        │  REVIEWED   │
  │ (Field Visit,│        │             │
  │  Interviews) │        └──────┬──────┘
  └──────┬───────┘               │
         │                       │
         │Report                 │
         │Received               │
         │                       │
         └───────────┬───────────┘
                     │
                     │Management
                     │Review
                     │
         ┌───────────┴───────────┐
         │                       │
         │Approved               │Rejected
         │                       │
         ▼                       ▼
  ┌──────────────┐        ┌─────────────┐
  │  APPROVED    │        │  REJECTED   │
  │ (Amount      │        │ (With       │
  │  Determined) │        │  Reason)    │
  └──────┬───────┘        └─────────────┘
         │
         │Payment
         │Processing
         │
         ▼
  ┌──────────────┐
  │    PAID      │
  │ (Settled)    │
  └──────────────┘
```

### PAYMENT STATUS WORKFLOW

```
    ┌──────────────────────────────────────────────┐
    │                                              │
    │          PAYMENT PROCESSING                  │
    │                                              │
    └──────────────────────────────────────────────┘

              ┌──────────────┐
              │   PENDING    │
              │ (Initiated)  │
              └──────┬───────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         │Gateway Success        │Gateway Failed
         │OR                     │OR
         │Cash/Cheque Received   │Cheque Bounced
         │                       │
         ▼                       ▼
  ┌──────────────┐        ┌─────────────┐
  │   SUCCESS    │        │   FAILED    │
  │              │        │             │
  └──────┬───────┘        └─────────────┘
         │
         │
         ▼
  ┌──────────────┐
  │ RECONCILED   │
  │ (Matched with│
  │  Bank Stmt)  │
  └──────┬───────┘
         │
         │Customer
         │Requests
         │Refund
         │
         ▼
  ┌──────────────┐
  │  REFUNDED    │
  │              │
  └──────────────┘
```

---

## MODULE INTERACTION FLOW

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER ACTIONS                              │
└────┬────────┬────────┬────────┬────────┬────────┬───────────────┘
     │        │        │        │        │        │
     ▼        ▼        ▼        ▼        ▼        ▼
  Register Create  Register Process  Register Generate
  Customer Policy   Claim   Payment  Agent    Reports
     │        │        │        │        │        │
     │        │        │        │        │        │
     ▼        ▼        ▼        ▼        ▼        ▼
┌─────────┐┌───────┐┌───────┐┌────────┐┌───────┐┌────────┐
│Customer ││Policy ││Claims ││Payment ││Agent  ││Reports │
│ CRUD    ││ CRUD  ││ CRUD  ││ CRUD   ││ CRUD  ││Module  │
└────┬────┘└───┬───┘└───┬───┘└───┬────┘└───┬───┘└───┬────┘
     │         │        │        │         │        │
     └─────────┼────────┼────────┼─────────┼────────┘
               │        │        │         │
               ▼        ▼        ▼         ▼
         ┌────────────────────────────────────┐
         │      SQLAlchemy ORM Engine         │
         │                                    │
         │  • Transaction Management          │
         │  • Validation & Business Logic     │
         │  • Relationship Handling           │
         │  • Query Optimization              │
         └────────────┬───────────────────────┘
                      │
                      ▼
            ┌─────────────────┐
            │    DATABASE     │
            │  (MySQL/PgSQL)  │
            └─────────────────┘
```

---

## COMMISSION CALCULATION FLOW

```
Policy Premium Received
         │
         ▼
┌────────────────────────┐
│ Is First Premium?      │
├────────────────────────┤
│ YES │            │ NO  │
│     │            │     │
│     ▼            ▼     │
│  First Year   Renewal  │
│  Commission   Commiss. │
└──────┬──────────┬──────┘
       │          │
       │          │
       ▼          ▼
┌──────────────────────────┐
│ Get Agent Commission %   │
│                          │
│ First Year: 10-15%       │
│ Renewal: 3-7%            │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ Calculate Gross Comm.    │
│                          │
│ Gross = Premium × Rate%  │
│                          │
│ Example:                 │
│ Premium: ₹15,000         │
│ Rate: 10%                │
│ Gross: ₹1,500            │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ Calculate TDS (10%)      │
│                          │
│ TDS = Gross × 10%        │
│                          │
│ Example:                 │
│ Gross: ₹1,500            │
│ TDS: ₹150                │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ Calculate Net Commission │
│                          │
│ Net = Gross - TDS        │
│                          │
│ Example:                 │
│ Gross: ₹1,500            │
│ TDS: ₹150                │
│ Net: ₹1,350              │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ Create Commission Record │
│                          │
│ • Agent ID               │
│ • Policy ID              │
│ • Payment ID             │
│ • Commission Type        │
│ • Gross Amount           │
│ • TDS Amount             │
│ • Net Amount             │
│ • Status: Pending        │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ Update Agent Stats       │
│                          │
│ • Total Commission Earned│
│ • Policies Sold          │
│ • Premium Collected      │
└──────────────────────────┘
```

---

## PREMIUM CALCULATION FLOW

```
Customer Applies for Policy
         │
         ▼
┌────────────────────────────┐
│ Input Parameters           │
│ • Age: 35                  │
│ • Sum Assured: ₹10,00,000  │
│ • Term: 20 years           │
│ • Policy Type: Term Life   │
│ • Payment Frequency: Annual│
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Get Base Premium Rate      │
│ From Policy Type Master    │
│                            │
│ Term Life Rate: 0.0015     │
│ (per ₹1,000 sum assured)   │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Calculate Base Premium     │
│                            │
│ Base = (Sum Assured ÷ 1000)│
│        × Rate × Term       │
│                            │
│ = (1000000 ÷ 1000)         │
│   × 0.0015 × 20            │
│ = ₹30,000                  │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Apply Age Factor           │
│                            │
│ Age 18-30: No loading      │
│ Age 31-40: +10% loading    │
│ Age 41-50: +25% loading    │
│ Age 51-60: +50% loading    │
│                            │
│ Age 35 → 10% loading       │
│ = ₹30,000 + ₹3,000         │
│ = ₹33,000                  │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Add Risk Loadings          │
│                            │
│ Smoker: +30%               │
│ High-risk Occupation: +20% │
│ Pre-existing Condition:+15%│
│                            │
│ If Smoker:                 │
│ = ₹33,000 + ₹9,900         │
│ = ₹42,900                  │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Add Rider Premiums         │
│                            │
│ Critical Illness: ₹2,000   │
│ Accidental Death: ₹1,000   │
│                            │
│ Total Riders: ₹3,000       │
│ = ₹42,900 + ₹3,000         │
│ = ₹45,900                  │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Apply Discounts            │
│                            │
│ Loyalty Discount: -5%      │
│ Online Purchase: -2%       │
│ Bulk Discount: -3%         │
│                            │
│ Total Discount: -10%       │
│ = ₹45,900 - ₹4,590         │
│ = ₹41,310                  │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Add GST (18%)              │
│                            │
│ GST = ₹41,310 × 0.18       │
│     = ₹7,436               │
│                            │
│ Total Premium = ₹48,746    │
│                            │
│ Rounded: ₹48,750           │
└──────────┬─────────────────┘
           │
           ▼
┌────────────────────────────┐
│ Adjust for Payment         │
│ Frequency                  │
│                            │
│ Annual: No adjustment      │
│ Semi-Annual: +2%           │
│ Quarterly: +3%             │
│ Monthly: +5%               │
│                            │
│ Selected: Annual           │
│ Final Premium: ₹48,750     │
└────────────────────────────┘
```

---

## SYSTEM SCALABILITY ARCHITECTURE

```
                         ┌──────────────────┐
                         │   LOAD BALANCER  │
                         │   (Nginx/HAProxy)│
                         └────────┬─────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
            ┌───────────┐ ┌───────────┐ ┌───────────┐
            │ APP       │ │ APP       │ │ APP       │
            │ SERVER 1  │ │ SERVER 2  │ │ SERVER 3  │
            │ (Python)  │ │ (Python)  │ │ (Python)  │
            └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
                  │             │             │
                  └──────┬──────┴──────┬──────┘
                         │             │
                         ▼             ▼
                  ┌──────────┐  ┌──────────┐
                  │  REDIS   │  │ MEMCACHED│
                  │  CACHE   │  │  CACHE   │
                  └──────────┘  └──────────┘
                         │
                         ▼
                  ┌──────────────────┐
                  │ DATABASE CLUSTER │
                  │                  │
                  │  ┌────────────┐  │
                  │  │   MASTER   │  │
                  │  │ (Write)    │  │
                  │  └──────┬─────┘  │
                  │         │        │
                  │    ┌────┴────┐   │
                  │    │         │   │
                  │    ▼         ▼   │
                  │ ┌──────┐ ┌──────┐│
                  │ │SLAVE1│ │SLAVE2││
                  │ │(Read)│ │(Read)││
                  │ └──────┘ └──────┘│
                  └──────────────────┘
```

---

## SECURITY ARCHITECTURE

```
┌─────────────────────────────────────────────────────────┐
│                   SECURITY LAYERS                        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  LAYER 1: NETWORK SECURITY                              │
│  ├─ Firewall                                            │
│  ├─ SSL/TLS Encryption                                  │
│  ├─ DDoS Protection                                     │
│  └─ IP Whitelisting                                     │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  LAYER 2: APPLICATION SECURITY                          │
│  ├─ Authentication (JWT/Session)                        │
│  ├─ Multi-Factor Authentication (MFA)                   │
│  ├─ Password Hashing (bcrypt/argon2)                    │
│  └─ Session Management                                  │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  LAYER 3: AUTHORIZATION                                 │
│  ├─ Role-Based Access Control (RBAC)                    │
│  │  ├─ Admin: Full Access                              │
│  │  ├─ Manager: Limited Access                         │
│  │  ├─ Agent: Own Data Only                            │
│  │  └─ Customer: Personal Data Only                    │
│  └─ Permission Matrix                                   │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  LAYER 4: DATA SECURITY                                 │
│  ├─ Field-Level Encryption (PAN, Aadhaar)              │
│  ├─ Data Masking (Phone, Email)                        │
│  ├─ SQL Injection Prevention (ORM)                     │
│  └─ Input Validation & Sanitization                    │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  LAYER 5: AUDIT & MONITORING                            │
│  ├─ Complete Audit Trail                               │
│  ├─ User Activity Logging                              │
│  ├─ Fraud Detection Algorithms                         │
│  └─ Anomaly Detection                                   │
└─────────────────────────────────────────────────────────┘
```

---

## DATA BACKUP & RECOVERY STRATEGY

```
┌────────────────────────────────────────────────────────┐
│              BACKUP STRATEGY                            │
└────────────────────────────────────────────────────────┘

PRODUCTION DATABASE
        │
        ├─────────────────────────┬──────────────────────┐
        │                         │                      │
        ▼                         ▼                      ▼
┌──────────────┐         ┌──────────────┐      ┌──────────────┐
│   DAILY      │         │   WEEKLY     │      │   MONTHLY    │
│   BACKUP     │         │   BACKUP     │      │   BACKUP     │
│              │         │              │      │              │
│ • Full       │         │ • Full       │      │ • Full       │
│   Backup     │         │   Backup     │      │   Backup     │
│ • 2 AM       │         │ • Sunday 2AM │      │ • 1st of     │
│ • Retention: │         │ • Retention: │      │   Month      │
│   7 days     │         │   4 weeks    │      │ • Retention: │
│              │         │              │      │   12 months  │
└──────┬───────┘         └──────┬───────┘      └──────┬───────┘
       │                        │                     │
       └────────────┬───────────┴──────────────┬──────┘
                    │                          │
                    ▼                          ▼
            ┌───────────────┐         ┌────────────────┐
            │   LOCAL       │         │    CLOUD       │
            │   STORAGE     │         │    STORAGE     │
            │               │         │                │
            │ • Primary     │────────▶│  • Secondary   │
            │   Location    │  Sync   │    Location    │
            │ • RAID 10     │         │  • S3/Azure    │
            └───────────────┘         └────────────────┘

RECOVERY POINT OBJECTIVE (RPO): 24 hours
RECOVERY TIME OBJECTIVE (RTO): 4 hours

DISASTER RECOVERY PLAN:
1. Identify failure
2. Restore from latest backup
3. Replay transaction logs
4. Verify data integrity
5. Switch to recovered database
6. Notify stakeholders
```

---

This visual guide provides comprehensive diagrams and flowcharts to understand
the Insurance Power Buyer Management System architecture, data flows, and
operational workflows. Use it alongside the implementation files for complete
system understanding.

═══════════════════════════════════════════════════════════════════════

END OF VISUAL GUIDE

═══════════════════════════════════════════════════════════════════════
