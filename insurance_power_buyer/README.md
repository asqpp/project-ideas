# Insurance Power Buyer Software

## Complete CRUD Operations Logic and Implementation

### Project Overview
This is a comprehensive Insurance Power Buyer Management System designed for insurance companies and brokers. The system provides complete CRUD (Create, Read, Update, Delete) operations for managing insurance policies, customers, claims, payments, and agents.

### Directory Structure
```
insurance_power_buyer/
├── 01_SYSTEM_OVERVIEW.txt              # Complete system architecture and overview
├── 02_CUSTOMER_BUYER_MANAGEMENT_CRUD.txt # Customer CRUD operations logic
├── 03_POLICY_MANAGEMENT_CRUD.txt       # Policy CRUD operations logic
├── 04_CLAIMS_MANAGEMENT_CRUD.txt       # Claims CRUD operations logic
├── 05_PAYMENT_BILLING_CRUD.txt         # Payment & Billing CRUD logic
├── 06_AGENT_MANAGEMENT_CRUD.txt        # Agent management CRUD logic
├── models.py                            # SQLAlchemy ORM models
├── crud_operations.py                   # Python CRUD operations implementation
├── schema.sql                           # Complete MySQL/PostgreSQL database schema
├── requirements.txt                     # Python dependencies
└── README.md                            # This file
```

### Core Modules

1. **Customer/Buyer Management**
   - Customer registration with KYC
   - Address management
   - Document verification
   - Customer lifecycle management

2. **Policy Management**
   - Policy issuance
   - Premium calculation
   - Rider management
   - Nominee management
   - Policy surrender/revival

3. **Claims Management**
   - Claim registration
   - Document verification
   - Investigation workflow
   - Approval process
   - Settlement processing

4. **Payment & Billing**
   - Multiple payment methods support
   - Payment gateway integration
   - Receipt generation
   - Payment reconciliation
   - Commission calculation

5. **Agent/Broker Management**
   - Agent registration
   - License management
   - Target tracking
   - Commission management
   - Performance analytics

### Technology Stack

- **Backend**: Python 3.8+
- **ORM**: SQLAlchemy 2.0+
- **Database**: MySQL 8.0+ / PostgreSQL 13+ / MariaDB 10.5+
- **API Framework**: FastAPI / Flask (recommended)
- **Authentication**: JWT Token-based
- **Documentation**: Comprehensive text files with business logic

### Database Setup

#### Using MySQL/MariaDB:
```bash
# Create database
mysql -u root -p

# Run schema
mysql -u root -p < schema.sql
```

#### Using PostgreSQL:
```bash
# Create database
psql -U postgres

# Run schema (after converting to PostgreSQL syntax)
psql -U postgres -d insurance_power_buyer -f schema.sql
```

### Python Environment Setup

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/Mac:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Database Configuration

Edit the database connection string in your application:

```python
# For MySQL
DATABASE_URL = "mysql+pymysql://username:password@localhost/insurance_power_buyer"

# For PostgreSQL
DATABASE_URL = "postgresql://username:password@localhost/insurance_power_buyer"
```

### Usage Examples

#### Create a Customer
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from crud_operations import CustomerCRUD
from datetime import date

engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)
db = Session()

customer_data = {
    'first_name': 'John',
    'last_name': 'Doe',
    'email': 'john.doe@example.com',
    'phone': '9876543210',
    'date_of_birth': date(1990, 1, 15),
    'gender': 'Male',
    'pan_number': 'ABCDE1234F',
    'occupation': 'Software Engineer',
    'annual_income': 1200000,
    'created_by': 1
}

customer = CustomerCRUD.create_customer(db, customer_data)
print(f"Customer created: {customer.customer_id}")
```

#### Create a Policy
```python
from crud_operations import PolicyCRUD
from datetime import date

policy_data = {
    'customer_id': 1,
    'policy_type_id': 1,
    'sum_assured': 1000000,
    'policy_term': 20,
    'premium_payment_term': 15,
    'annual_premium': 15000,
    'installment_premium': 15000,
    'payment_frequency': 'Annual',
    'policy_start_date': date.today(),
    'branch_id': 1,
    'agent_id': 1,
    'created_by': 1
}

policy = PolicyCRUD.create_policy(db, policy_data)
print(f"Policy created: {policy.policy_number}")
```

#### Register a Claim
```python
from crud_operations import ClaimCRUD
from datetime import date

claim_data = {
    'policy_id': 1,
    'claim_type': 'Death Claim',
    'date_of_event': date(2025, 1, 10),
    'intimation_date': date.today(),
    'claimant_name': 'Jane Doe',
    'claimant_relationship': 'Spouse',
    'claimant_phone': '9876543211',
    'claim_amount': 1000000,
    'created_by': 1
}

claim = ClaimCRUD.create_claim(db, claim_data)
print(f"Claim registered: {claim.claim_number}")
```

#### Process a Payment
```python
from crud_operations import PaymentCRUD

payment_data = {
    'policy_id': 1,
    'payment_method': 'UPI',
    'premium_amount': 15000,
    'gst_amount': 2700,
    'total_amount': 17700,
    'transaction_id': 'TXN123456789',
    'created_by': 1
}

payment = PaymentCRUD.create_payment(db, payment_data)
print(f"Payment processed: {payment.payment_id}")
```

### Business Logic Documentation

Each text file (01-06) contains detailed business logic including:

- **Input Validation Rules**
- **Business Rules & Constraints**
- **Workflow State Machines**
- **Calculation Formulas**
- **Error Handling**
- **Audit Trail Requirements**
- **Security Considerations**

### Features

✅ Complete CRUD operations for all modules
✅ Business logic validation
✅ Audit trail logging
✅ Soft delete support
✅ Role-based access control
✅ Transaction management
✅ Error handling
✅ Data integrity constraints
✅ Performance optimization with indexes
✅ Reporting views
✅ Stored procedures for complex calculations
✅ Database triggers for automation

### Security Features

- Password hashing (bcrypt/argon2)
- JWT token-based authentication
- Role-based access control (RBAC)
- Data encryption for sensitive fields
- Audit logging for all operations
- SQL injection prevention
- Input validation and sanitization

### Performance Optimizations

- Database indexing on frequently queried fields
- Composite indexes for complex queries
- Connection pooling
- Query optimization
- Materialized views for reporting
- Pagination support
- Caching mechanisms

### API Recommendations

For production deployment, create RESTful APIs using FastAPI:

```python
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

app = FastAPI(title="Insurance Power Buyer API")

@app.post("/api/v1/customers")
def create_customer(customer_data: dict, db: Session = Depends(get_db)):
    return CustomerCRUD.create_customer(db, customer_data)

@app.get("/api/v1/customers/{customer_id}")
def get_customer(customer_id: int, db: Session = Depends(get_db)):
    return CustomerCRUD.get_customer(db, customer_id)

# ... more endpoints
```

### Testing

```bash
# Run unit tests
pytest tests/

# Run integration tests
pytest tests/integration/

# Run with coverage
pytest --cov=. tests/
```

### Deployment

1. Set up production database
2. Configure environment variables
3. Run database migrations
4. Set up application server (Gunicorn/uWSGI)
5. Configure reverse proxy (Nginx)
6. Set up SSL certificates
7. Configure monitoring and logging
8. Set up backup procedures

### Compliance & Regulations

This system is designed to comply with:
- IRDAI (Insurance Regulatory and Development Authority of India) guidelines
- GDPR (General Data Protection Regulation)
- Data retention policies
- PCI DSS for payment processing
- KYC/AML regulations

### Support & Documentation

For detailed business logic and implementation details, refer to the text files:
- System architecture: `01_SYSTEM_OVERVIEW.txt`
- Customer operations: `02_CUSTOMER_BUYER_MANAGEMENT_CRUD.txt`
- Policy operations: `03_POLICY_MANAGEMENT_CRUD.txt`
- Claims operations: `04_CLAIMS_MANAGEMENT_CRUD.txt`
- Payment operations: `05_PAYMENT_BILLING_CRUD.txt`
- Agent operations: `06_AGENT_MANAGEMENT_CRUD.txt`

### License

Proprietary - All Rights Reserved

### Version

Version 1.0.0 - January 2025

---

**Note**: This is a comprehensive insurance management system. Customize and extend as per your specific business requirements.
