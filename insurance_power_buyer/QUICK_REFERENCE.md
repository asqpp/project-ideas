# QUICK REFERENCE GUIDE
## Insurance Power Buyer Management System

---

## 📌 QUICK START

### 1-Minute Setup
```bash
# Clone/extract project
cd insurance_power_buyer

# Import database
mysql -u root -p < schema.sql

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Configure database (edit database URL in models.py)
DATABASE_URL = "mysql+pymysql://root:password@localhost/insurance_power_buyer"

# Test connection
python -c "from models import Base; from sqlalchemy import create_engine; engine = create_engine('your_db_url'); print('Connected!')"
```

---

## 🔑 CHEAT SHEETS

### DATABASE CONNECTION

```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# MySQL
DATABASE_URL = "mysql+pymysql://user:pass@localhost/insurance_power_buyer"

# PostgreSQL
DATABASE_URL = "postgresql://user:pass@localhost/insurance_power_buyer"

# Create engine
engine = create_engine(DATABASE_URL, echo=True)

# Create session
Session = sessionmaker(bind=engine)
db = Session()
```

### CUSTOMER OPERATIONS

#### Create Customer
```python
from crud_operations import CustomerCRUD
from datetime import date

customer = CustomerCRUD.create_customer(db, {
    'first_name': 'John',
    'last_name': 'Doe',
    'email': 'john.doe@example.com',
    'phone': '9876543210',
    'date_of_birth': date(1990, 1, 15),
    'gender': 'Male',
    'marital_status': 'Married',
    'pan_number': 'ABCDE1234F',
    'occupation': 'Software Engineer',
    'annual_income': 1200000,
    'branch_id': 1,
    'agent_id': 1,
    'created_by': 1
})

print(f"Customer ID: {customer.customer_id}")
# Output: CUST-20250115-0001
```

#### Get Customer
```python
# By ID
customer = CustomerCRUD.get_customer(db, customer_id=1)

# By Email
customer = CustomerCRUD.get_customer(db, email='john@example.com')

# By Phone
customer = CustomerCRUD.get_customer(db, phone='9876543210')
```

#### List Customers
```python
# All customers (paginated)
result = CustomerCRUD.list_customers(db, page=1, per_page=20)

# With filters
result = CustomerCRUD.list_customers(db, {
    'status': 'Active',
    'kyc_status': 'Verified',
    'branch_id': 1,
    'search': 'John'
}, page=1, per_page=20)

# Access results
print(f"Total: {result['total_records']}")
print(f"Pages: {result['total_pages']}")
for customer in result['customers']:
    print(customer.full_name)
```

#### Update Customer
```python
updated = CustomerCRUD.update_customer(db,
    customer_id=1,
    {
        'email': 'newemail@example.com',
        'phone': '9876543211',
        'marital_status': 'Married',
        'annual_income': 1500000
    },
    updated_by=1
)
```

#### Delete Customer (Soft)
```python
result = CustomerCRUD.delete_customer(db,
    customer_id=1,
    deleted_by=1,
    soft_delete=True
)
```

### POLICY OPERATIONS

#### Create Policy
```python
from crud_operations import PolicyCRUD
from datetime import date

policy = PolicyCRUD.create_policy(db, {
    'customer_id': 1,
    'policy_type_id': 1,  # Term Life
    'sum_assured': 1000000,
    'policy_term': 20,
    'premium_payment_term': 15,
    'annual_premium': 15000,
    'installment_premium': 15000,
    'payment_frequency': 'Annual',
    'maturity_value': 1000000,
    'policy_start_date': date.today(),
    'branch_id': 1,
    'agent_id': 1,
    'created_by': 1
})

print(f"Policy Number: {policy.policy_number}")
# Output: POL-TERM-2025-000001
```

#### Add Nominees
```python
from models import PolicyNominee

# Add first nominee
nominee1 = PolicyNominee(
    policy_id=policy.id,
    nominee_name='Jane Doe',
    relationship_with_insured='Spouse',
    date_of_birth=date(1992, 5, 20),
    share_percentage=60.00,
    contact_phone='9876543211',
    contact_email='jane@example.com'
)
db.add(nominee1)

# Add second nominee
nominee2 = PolicyNominee(
    policy_id=policy.id,
    nominee_name='Jack Doe',
    relationship_with_insured='Son',
    date_of_birth=date(2015, 3, 10),
    share_percentage=40.00,
    appointee_name='Jane Doe',  # Appointee for minor
    appointee_relationship='Mother'
)
db.add(nominee2)
db.commit()
```

#### Get Policy
```python
# By ID
policy = PolicyCRUD.get_policy(db, policy_id=1)

# By Policy Number
policy = PolicyCRUD.get_policy(db, policy_number='POL-TERM-2025-000001')
```

#### List Policies
```python
# All policies
result = PolicyCRUD.list_policies(db, page=1, per_page=20)

# With filters
result = PolicyCRUD.list_policies(db, {
    'status': 'Active',
    'customer_id': 1,
    'agent_id': 1,
    'policy_type_id': 1
}, page=1, per_page=20)
```

#### Surrender Policy
```python
result = PolicyCRUD.surrender_policy(db,
    policy_id=1,
    surrendered_by=1
)

print(f"Surrender Value: {result['surrender_value']}")
print(f"Status: {result['status']}")
```

### CLAIMS OPERATIONS

#### Register Claim
```python
from crud_operations import ClaimCRUD
from datetime import date

claim = ClaimCRUD.create_claim(db, {
    'policy_id': 1,
    'claim_type': 'Death Claim',
    'date_of_event': date(2025, 1, 10),
    'intimation_date': date.today(),
    'claimant_name': 'Jane Doe',
    'claimant_relationship': 'Spouse',
    'claimant_phone': '9876543211',
    'claimant_email': 'jane@example.com',
    'claim_amount': 1000000,
    'priority': 'High',
    'created_by': 1
})

print(f"Claim Number: {claim.claim_number}")
# Output: CLM-2025-000001
```

#### Upload Claim Documents
```python
from models import ClaimDocument

# Death certificate
doc1 = ClaimDocument(
    claim_id=claim.id,
    document_type='Death Certificate',
    document_name='death_cert.pdf',
    document_path='/uploads/claims/death_cert.pdf'
)

# Medical reports
doc2 = ClaimDocument(
    claim_id=claim.id,
    document_type='Medical Reports',
    document_name='medical_reports.pdf',
    document_path='/uploads/claims/medical_reports.pdf'
)

db.add_all([doc1, doc2])
db.commit()
```

#### Update Claim Status
```python
from models import ClaimStatus

# Move to Under Review
claim = ClaimCRUD.update_claim_status(db,
    claim_id=1,
    new_status=ClaimStatus.UNDER_REVIEW,
    updated_by=1
)

# Approve claim
claim = ClaimCRUD.update_claim_status(db,
    claim_id=1,
    new_status=ClaimStatus.APPROVED,
    updated_by=1,
    approved_amount=1000000
)
```

### PAYMENT OPERATIONS

#### Process Payment
```python
from crud_operations import PaymentCRUD
from models import PaymentMethod

payment = PaymentCRUD.create_payment(db, {
    'policy_id': 1,
    'payment_method': PaymentMethod.UPI,
    'payment_type': 'Premium Payment',
    'premium_amount': 15000,
    'gst_amount': 2700,
    'total_amount': 17700,
    'transaction_id': 'UPI123456789',
    'created_by': 1
})

print(f"Payment ID: {payment.payment_id}")
print(f"Receipt No: {payment.receipt_number}")
# Output:
# PAY-2025-01-00000001
# RCP-2025-00000001
```

#### Different Payment Methods
```python
# Cash Payment
payment = PaymentCRUD.create_payment(db, {
    'policy_id': 1,
    'payment_method': PaymentMethod.CASH,
    'premium_amount': 15000,
    'gst_amount': 2700,
    'total_amount': 17700,
    'created_by': 1
})

# Cheque Payment
payment = PaymentCRUD.create_payment(db, {
    'policy_id': 1,
    'payment_method': PaymentMethod.CHEQUE,
    'premium_amount': 15000,
    'gst_amount': 2700,
    'total_amount': 17700,
    'cheque_number': 'CHQ123456',
    'cheque_date': date.today(),
    'bank_name': 'HDFC Bank',
    'created_by': 1
})

# Card Payment
payment = PaymentCRUD.create_payment(db, {
    'policy_id': 1,
    'payment_method': PaymentMethod.CARD,
    'premium_amount': 15000,
    'gst_amount': 2700,
    'total_amount': 17700,
    'card_last_4_digits': '1234',
    'gateway_name': 'Razorpay',
    'gateway_transaction_id': 'pay_123456789',
    'created_by': 1
})
```

### AGENT OPERATIONS

#### Register Agent
```python
from crud_operations import AgentCRUD
from datetime import date

agent = AgentCRUD.create_agent(db, {
    'first_name': 'Rajesh',
    'last_name': 'Kumar',
    'email': 'rajesh@example.com',
    'phone': '9876543210',
    'date_of_birth': date(1985, 6, 15),
    'gender': 'Male',
    'license_number': '12345678',
    'license_valid_till': date(2026, 12, 31),
    'agent_type': 'Individual Agent',
    'pan_number': 'ABCDE1234F',
    'branch_id': 1,
    'branch_code': 'MUM',
    'bank_name': 'HDFC Bank',
    'bank_account_number': '12345678901234',
    'bank_ifsc_code': 'HDFC0001234',
    'first_year_commission_percentage': 10,
    'renewal_commission_percentage': 5,
    'created_by': 1
})

print(f"Agent Code: {agent.agent_code}")
# Output: AGT-MUM-2025-0001
```

#### Assign Target
```python
from models import AgentTarget

target = AgentTarget(
    agent_id=agent.id,
    target_period='Monthly',
    target_year=2025,
    target_month=1,
    premium_target=500000,
    policies_target=20
)
db.add(target)
db.commit()
```

#### Calculate Commission
```python
from models import Commission

# When payment is received, commission is auto-calculated
commission = Commission(
    agent_id=agent.id,
    policy_id=policy.id,
    payment_id=payment.id,
    commission_type='First Year',
    premium_amount=15000,
    commission_rate=10,  # 10%
    commission_amount=1500,  # 15000 * 0.10
    tds_amount=150,  # 10% TDS
    net_commission=1350,  # 1500 - 150
    status='Pending'
)
db.add(commission)
db.commit()
```

---

## 📊 COMMON QUERIES

### Customer Queries

```python
from models import Customer, CustomerStatus, KYCStatus

# Active customers with verified KYC
active_customers = db.query(Customer).filter(
    Customer.status == CustomerStatus.ACTIVE,
    Customer.kyc_status == KYCStatus.VERIFIED,
    Customer.is_active == True
).all()

# Customers by branch
branch_customers = db.query(Customer).filter(
    Customer.branch_id == 1
).all()

# Top customers by lifetime value
top_customers = db.query(Customer).order_by(
    Customer.customer_lifetime_value.desc()
).limit(10).all()

# Customers with pending KYC
pending_kyc = db.query(Customer).filter(
    Customer.kyc_status == KYCStatus.PENDING
).all()
```

### Policy Queries

```python
from models import Policy, PolicyStatus
from sqlalchemy import func

# Active policies
active_policies = db.query(Policy).filter(
    Policy.status == PolicyStatus.ACTIVE,
    Policy.is_active == True
).all()

# Policies due for renewal this month
from datetime import date, timedelta

today = date.today()
end_of_month = date(today.year, today.month + 1, 1) - timedelta(days=1)

due_policies = db.query(Policy).filter(
    Policy.next_premium_due_date >= today,
    Policy.next_premium_due_date <= end_of_month,
    Policy.status == PolicyStatus.ACTIVE
).all()

# Total sum assured by policy type
sum_by_type = db.query(
    PolicyType.policy_type_name,
    func.sum(Policy.sum_assured).label('total')
).join(Policy).group_by(PolicyType.policy_type_name).all()

# Policies by agent
agent_policies = db.query(Policy).filter(
    Policy.agent_id == 1,
    Policy.status == PolicyStatus.ACTIVE
).all()
```

### Claims Queries

```python
from models import Claim, ClaimStatus

# Pending claims
pending_claims = db.query(Claim).filter(
    Claim.status.in_([
        ClaimStatus.REGISTERED,
        ClaimStatus.UNDER_REVIEW,
        ClaimStatus.INVESTIGATION
    ]),
    Claim.is_active == True
).all()

# Claims by priority
high_priority = db.query(Claim).filter(
    Claim.priority == 'High',
    Claim.status != ClaimStatus.PAID
).all()

# Claims requiring investigation
investigation_claims = db.query(Claim).filter(
    Claim.requires_investigation == True,
    Claim.status == ClaimStatus.INVESTIGATION
).all()

# Paid claims this month
import datetime

this_month_start = date.today().replace(day=1)
paid_claims = db.query(Claim).filter(
    Claim.status == ClaimStatus.PAID,
    Claim.settlement_date >= this_month_start
).all()
```

### Payment Queries

```python
from models import Payment, PaymentStatus
from sqlalchemy import func

# Successful payments today
today_payments = db.query(Payment).filter(
    func.date(Payment.payment_date) == date.today(),
    Payment.status == PaymentStatus.SUCCESS
).all()

# Total collection today
total_today = db.query(
    func.sum(Payment.total_amount)
).filter(
    func.date(Payment.payment_date) == date.today(),
    Payment.status == PaymentStatus.SUCCESS
).scalar()

# Pending reconciliation
pending_recon = db.query(Payment).filter(
    Payment.status == PaymentStatus.SUCCESS,
    Payment.is_reconciled == False
).all()

# Payment by method
from collections import defaultdict
payment_by_method = defaultdict(float)

payments = db.query(Payment).filter(
    func.date(Payment.payment_date) == date.today()
).all()

for payment in payments:
    payment_by_method[payment.payment_method.value] += float(payment.total_amount)
```

### Agent Queries

```python
from models import Agent, AgentStatus, Commission

# Active agents
active_agents = db.query(Agent).filter(
    Agent.status == AgentStatus.ACTIVE,
    Agent.is_active == True
).all()

# Top performing agents
top_agents = db.query(Agent).order_by(
    Agent.total_commission_earned.desc()
).limit(10).all()

# Agents with expiring licenses (next 30 days)
from datetime import timedelta

expiry_date = date.today() + timedelta(days=30)
expiring_licenses = db.query(Agent).filter(
    Agent.license_valid_till <= expiry_date,
    Agent.status == AgentStatus.ACTIVE
).all()

# Commission summary for agent
agent_commission = db.query(
    func.sum(Commission.commission_amount).label('gross'),
    func.sum(Commission.tds_amount).label('tds'),
    func.sum(Commission.net_commission).label('net')
).filter(
    Commission.agent_id == 1
).first()
```

---

## 🔄 COMPLETE WORKFLOWS

### Complete Customer Onboarding

```python
from datetime import date

# Step 1: Create customer
customer = CustomerCRUD.create_customer(db, {
    'first_name': 'Alice',
    'last_name': 'Smith',
    'email': 'alice@example.com',
    'phone': '9876543210',
    'date_of_birth': date(1988, 3, 20),
    'gender': 'Female',
    'pan_number': 'ABCDE1234F',
    'created_by': 1
})

# Step 2: Add address
from models import CustomerAddress

address = CustomerAddress(
    customer_id=customer.id,
    address_type='Residential',
    address_line1='123 Main Street',
    address_line2='Apt 4B',
    city='Mumbai',
    state='Maharashtra',
    pincode='400001',
    is_primary=True
)
db.add(address)

# Step 3: Upload KYC documents
from models import CustomerKYCDocument

pan_doc = CustomerKYCDocument(
    customer_id=customer.id,
    document_type='PAN Card',
    document_number='ABCDE1234F',
    document_path='/uploads/kyc/pan_123.pdf',
    document_name='pan_card.pdf'
)

aadhaar_doc = CustomerKYCDocument(
    customer_id=customer.id,
    document_type='Aadhaar Card',
    document_number='1234 5678 9012',
    document_path='/uploads/kyc/aadhaar_123.pdf',
    document_name='aadhaar_card.pdf'
)

db.add_all([pan_doc, aadhaar_doc])

# Step 4: Update KYC status (after verification)
customer.kyc_status = KYCStatus.VERIFIED
customer.updated_by = 1

db.commit()

print(f"Customer {customer.customer_id} onboarded successfully!")
```

### Complete Policy Sale Process

```python
# Step 1: Verify customer
customer = CustomerCRUD.get_customer(db, customer_id=1)

if customer.kyc_status != KYCStatus.VERIFIED:
    print("KYC not verified. Cannot issue policy.")
    exit()

# Step 2: Create policy
policy = PolicyCRUD.create_policy(db, {
    'customer_id': customer.id,
    'policy_type_id': 1,
    'sum_assured': 2000000,
    'policy_term': 25,
    'premium_payment_term': 20,
    'annual_premium': 35000,
    'installment_premium': 35000,
    'payment_frequency': 'Annual',
    'agent_id': 1,
    'created_by': 1
})

# Step 3: Add nominees
nominee = PolicyNominee(
    policy_id=policy.id,
    nominee_name='Bob Smith',
    relationship_with_insured='Spouse',
    share_percentage=100.00
)
db.add(nominee)

# Step 4: Add riders
from models import PolicyRider

rider = PolicyRider(
    policy_id=policy.id,
    rider_id=1,  # Critical Illness
    sum_assured=500000,
    annual_premium=5000,
    start_date=date.today()
)
db.add(rider)

# Step 5: Process first premium
payment = PaymentCRUD.create_payment(db, {
    'policy_id': policy.id,
    'payment_method': PaymentMethod.UPI,
    'premium_amount': 40000,  # Base + Rider
    'gst_amount': 7200,
    'total_amount': 47200,
    'transaction_id': 'UPI987654321',
    'created_by': 1
})

# Step 6: Calculate agent commission
commission = Commission(
    agent_id=policy.agent_id,
    policy_id=policy.id,
    payment_id=payment.id,
    commission_type='First Year',
    premium_amount=40000,
    commission_rate=10,
    commission_amount=4000,
    tds_amount=400,
    net_commission=3600,
    status='Pending'
)
db.add(commission)

db.commit()

print(f"Policy {policy.policy_number} issued successfully!")
print(f"Payment {payment.payment_id} processed!")
print(f"Commission {commission.commission_amount} calculated!")
```

### Complete Claims Process

```python
# Step 1: Register claim
claim = ClaimCRUD.create_claim(db, {
    'policy_id': 1,
    'claim_type': 'Critical Illness Claim',
    'date_of_event': date(2025, 1, 5),
    'intimation_date': date(2025, 1, 7),
    'claimant_name': 'Alice Smith',
    'claimant_relationship': 'Self',
    'claimant_phone': '9876543210',
    'claim_amount': 500000,  # Rider amount
    'priority': 'High',
    'created_by': 1
})

# Step 2: Upload documents
documents = [
    ('Medical Report', 'medical_report.pdf'),
    ('Hospital Bill', 'hospital_bill.pdf'),
    ('Doctor Certificate', 'doctor_cert.pdf'),
    ('Diagnostic Reports', 'diagnostic.pdf')
]

for doc_type, doc_name in documents:
    doc = ClaimDocument(
        claim_id=claim.id,
        document_type=doc_type,
        document_name=doc_name,
        document_path=f'/uploads/claims/{doc_name}',
        verification_status='Pending'
    )
    db.add(doc)

# Step 3: Assign to examiner
claim.assigned_to = 5  # User ID of examiner
claim = ClaimCRUD.update_claim_status(db,
    claim_id=claim.id,
    new_status=ClaimStatus.UNDER_REVIEW,
    updated_by=1
)

# Step 4: Verify documents
for doc in claim.documents:
    doc.verification_status = 'Verified'
    doc.verified_by = 5
    doc.verified_at = datetime.utcnow()

# Step 5: Approve claim
claim = ClaimCRUD.update_claim_status(db,
    claim_id=claim.id,
    new_status=ClaimStatus.APPROVED,
    updated_by=6,  # Manager
    approved_amount=500000
)

# Step 6: Process payment
claim_payment = Payment(
    policy_id=claim.policy_id,
    customer_id=claim.customer_id,
    payment_type='Claim Settlement',
    payment_method=PaymentMethod.NET_BANKING,
    premium_amount=500000,
    total_amount=500000,
    status=PaymentStatus.SUCCESS
)
db.add(claim_payment)

# Step 7: Mark claim as paid
claim.status = ClaimStatus.PAID
claim.paid_amount = 500000
claim.settlement_date = date.today()
claim.transaction_reference = 'NEFT123456789'

db.commit()

print(f"Claim {claim.claim_number} processed and settled!")
```

---

## 🛠️ TROUBLESHOOTING

### Common Issues & Solutions

#### Issue: Database Connection Error
```python
# Problem
sqlalchemy.exc.OperationalError: (2003, "Can't connect to MySQL server")

# Solution
# 1. Check if MySQL is running
# 2. Verify connection string
DATABASE_URL = "mysql+pymysql://user:pass@localhost:3306/db_name"
#                                            ^^^^
#                                            port number

# 3. Test connection
from sqlalchemy import create_engine
engine = create_engine(DATABASE_URL)
try:
    conn = engine.connect()
    print("Connection successful!")
    conn.close()
except Exception as e:
    print(f"Error: {e}")
```

#### Issue: Import Error
```python
# Problem
ModuleNotFoundError: No module named 'sqlalchemy'

# Solution
pip install sqlalchemy
# OR
pip install -r requirements.txt
```

#### Issue: Age Validation Error
```python
# Problem
ValueError: Customer must be at least 18 years old

# Solution
# Ensure date_of_birth makes customer >= 18
from datetime import date, timedelta

valid_dob = date.today() - timedelta(days=18*365)
customer_data['date_of_birth'] = valid_dob
```

#### Issue: Duplicate Email
```python
# Problem
ValueError: Email already registered

# Solution
# Check if email exists before creating
existing = db.query(Customer).filter(
    Customer.email == 'test@example.com'
).first()

if existing:
    print("Email already registered!")
    # Use different email
else:
    # Proceed with registration
    pass
```

---

## 📈 REPORTING EXAMPLES

### Daily Sales Report
```python
from datetime import date
from sqlalchemy import func

# Get today's policy sales
today = date.today()

daily_sales = db.query(
    func.count(Policy.id).label('policies_sold'),
    func.sum(Policy.sum_assured).label('total_coverage'),
    func.sum(Policy.annual_premium).label('total_premium')
).filter(
    func.date(Policy.created_at) == today
).first()

print(f"Policies Sold Today: {daily_sales.policies_sold}")
print(f"Total Coverage: ₹{daily_sales.total_coverage:,.2f}")
print(f"Total Premium: ₹{daily_sales.total_premium:,.2f}")
```

### Agent Performance Report
```python
# Agent performance for current month
from datetime import datetime

current_month = datetime.now().month
current_year = datetime.now().year

agent_performance = db.query(
    Agent.agent_code,
    Agent.full_name,
    func.count(Policy.id).label('policies_sold'),
    func.sum(Policy.annual_premium).label('premium_collected'),
    func.sum(Commission.net_commission).label('commission_earned')
).join(Policy, Policy.agent_id == Agent.id)\
 .join(Commission, Commission.agent_id == Agent.id)\
 .filter(
    func.month(Policy.created_at) == current_month,
    func.year(Policy.created_at) == current_year
).group_by(Agent.id).all()

for agent in agent_performance:
    print(f"{agent.full_name}: {agent.policies_sold} policies, "
          f"₹{agent.premium_collected:,.2f} premium, "
          f"₹{agent.commission_earned:,.2f} commission")
```

### Claims Status Report
```python
# Claims summary by status
claims_summary = db.query(
    Claim.status,
    func.count(Claim.id).label('count'),
    func.sum(Claim.claim_amount).label('total_amount')
).group_by(Claim.status).all()

print("Claims Status Summary:")
for status in claims_summary:
    print(f"{status.status.value}: {status.count} claims, "
          f"₹{status.total_amount:,.2f}")
```

---

## 💾 BACKUP & RESTORE

### Backup Database
```bash
# MySQL backup
mysqldump -u root -p insurance_power_buyer > backup_$(date +%Y%m%d).sql

# Compress backup
gzip backup_$(date +%Y%m%d).sql
```

### Restore Database
```bash
# Restore from backup
mysql -u root -p insurance_power_buyer < backup_20250115.sql

# From compressed backup
gunzip < backup_20250115.sql.gz | mysql -u root -p insurance_power_buyer
```

---

## 🔐 SECURITY BEST PRACTICES

### Password Hashing
```python
from passlib.hash import bcrypt

# Hash password
password = "SecurePassword123"
hashed = bcrypt.hash(password)

# Verify password
is_valid = bcrypt.verify("SecurePassword123", hashed)
```

### Data Masking
```python
def mask_pan(pan):
    """Mask PAN: ABCDE1234F -> AXXXE1234X"""
    if len(pan) == 10:
        return f"{pan[0]}XXX{pan[4:9]}X"
    return pan

def mask_phone(phone):
    """Mask phone: 9876543210 -> 98XXXXXX10"""
    if len(phone) == 10:
        return f"{phone[:2]}XXXXXX{phone[-2:]}"
    return phone

# Usage
masked_pan = mask_pan(customer.pan_number)
masked_phone = mask_phone(customer.phone)
```

---

## 📞 SUPPORT & RESOURCES

### Documentation
- **README.md** - Main documentation
- **PROJECT_SUMMARY.md** - Complete overview
- **VISUAL_GUIDE.md** - Architecture diagrams
- **FILE_NAVIGATION.md** - File structure

### Business Logic
- **01_SYSTEM_OVERVIEW.txt**
- **02_CUSTOMER_BUYER_MANAGEMENT_CRUD.txt**
- **03_POLICY_MANAGEMENT_CRUD.txt**
- **04_CLAIMS_MANAGEMENT_CRUD.txt**
- **05_PAYMENT_BILLING_CRUD.txt**
- **06_AGENT_MANAGEMENT_CRUD.txt**

---

**Version:** 1.0.0
**Last Updated:** November 15, 2025

═══════════════════════════════════════════════════════════════════════

END OF QUICK REFERENCE GUIDE

═══════════════════════════════════════════════════════════════════════
