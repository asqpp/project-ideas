"""
Insurance Power Buyer Software - SQLAlchemy Models
Database models for comprehensive insurance management system
"""

from datetime import datetime
from sqlalchemy import (
    Column, Integer, String, Float, DateTime, Boolean,
    Text, Date, ForeignKey, Enum, Numeric, Index
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import enum

Base = declarative_base()

# ============================================================================
# ENUMERATIONS
# ============================================================================

class CustomerType(enum.Enum):
    INDIVIDUAL = "Individual"
    CORPORATE = "Corporate"

class CustomerStatus(enum.Enum):
    ACTIVE = "Active"
    INACTIVE = "Inactive"
    BLOCKED = "Blocked"

class KYCStatus(enum.Enum):
    PENDING = "Pending"
    VERIFIED = "Verified"
    REJECTED = "Rejected"

class PolicyStatus(enum.Enum):
    ACTIVE = "Active"
    LAPSED = "Lapsed"
    PAID_UP = "Paid-up"
    MATURED = "Matured"
    SURRENDERED = "Surrendered"

class ClaimStatus(enum.Enum):
    REGISTERED = "Registered"
    UNDER_REVIEW = "Under Review"
    INVESTIGATION = "Investigation"
    APPROVED = "Approved"
    REJECTED = "Rejected"
    PAID = "Paid"

class PaymentStatus(enum.Enum):
    PENDING = "Pending"
    SUCCESS = "Success"
    FAILED = "Failed"
    REFUNDED = "Refunded"

class PaymentMethod(enum.Enum):
    CASH = "Cash"
    CHEQUE = "Cheque"
    CARD = "Card"
    NET_BANKING = "Net Banking"
    UPI = "UPI"
    AUTO_DEBIT = "Auto-Debit"

class AgentStatus(enum.Enum):
    ACTIVE = "Active"
    INACTIVE = "Inactive"
    SUSPENDED = "Suspended"
    TERMINATED = "Terminated"

# ============================================================================
# CUSTOMER/BUYER MANAGEMENT MODELS
# ============================================================================

class Customer(Base):
    __tablename__ = 'customers'

    # Primary Key
    id = Column(Integer, primary_key=True, autoincrement=True)
    customer_id = Column(String(50), unique=True, nullable=False, index=True)

    # Personal Information
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    last_name = Column(String(50), nullable=False)
    full_name = Column(String(150), nullable=False, index=True)
    date_of_birth = Column(Date, nullable=False)
    age = Column(Integer, nullable=False)
    gender = Column(Enum('Male', 'Female', 'Other', name='gender_enum'))
    marital_status = Column(Enum('Single', 'Married', 'Divorced', 'Widowed', name='marital_status_enum'))

    # Contact Information
    email = Column(String(100), unique=True, nullable=False, index=True)
    phone = Column(String(15), unique=True, nullable=False, index=True)
    alternate_phone = Column(String(15))

    # Identification
    pan_number = Column(String(20), unique=True, index=True)
    aadhaar_number = Column(String(20))  # Encrypted
    passport_number = Column(String(20))

    # Customer Classification
    customer_type = Column(Enum(CustomerType), default=CustomerType.INDIVIDUAL)
    status = Column(Enum(CustomerStatus), default=CustomerStatus.ACTIVE, index=True)
    kyc_status = Column(Enum(KYCStatus), default=KYCStatus.PENDING, index=True)

    # Business Information (for Corporate)
    company_name = Column(String(200))
    gst_number = Column(String(50))

    # Financial Information
    annual_income = Column(Numeric(15, 2))
    occupation = Column(String(100))

    # Risk Profiling
    smoking_status = Column(Boolean, default=False)
    alcohol_consumption = Column(String(20))
    risk_category = Column(Enum('Low', 'Medium', 'High', name='risk_category_enum'))

    # Agent/Branch Assignment
    branch_id = Column(Integer, ForeignKey('branches.id'))
    agent_id = Column(Integer, ForeignKey('agents.id'))

    # Loyalty & Statistics
    loyalty_points = Column(Integer, default=0)
    customer_lifetime_value = Column(Numeric(15, 2), default=0)
    active_policies_count = Column(Integer, default=0)

    # Audit Fields
    is_active = Column(Boolean, default=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = Column(Integer, ForeignKey('users.id'))
    updated_by = Column(Integer, ForeignKey('users.id'))

    # Relationships
    addresses = relationship('CustomerAddress', back_populates='customer', cascade='all, delete-orphan')
    kyc_documents = relationship('CustomerKYCDocument', back_populates='customer', cascade='all, delete-orphan')
    policies = relationship('Policy', back_populates='customer')
    branch = relationship('Branch', back_populates='customers')
    agent = relationship('Agent', back_populates='customers')

    # Indexes
    __table_args__ = (
        Index('idx_customer_search', 'full_name', 'email', 'phone'),
        Index('idx_customer_status', 'status', 'is_active', 'created_at'),
    )


class CustomerAddress(Base):
    __tablename__ = 'customer_addresses'

    id = Column(Integer, primary_key=True, autoincrement=True)
    customer_id = Column(Integer, ForeignKey('customers.id', ondelete='CASCADE'), nullable=False)

    address_type = Column(Enum('Residential', 'Office', 'Permanent', 'Mailing', name='address_type_enum'))
    address_line1 = Column(String(200), nullable=False)
    address_line2 = Column(String(200))
    city = Column(String(100), nullable=False, index=True)
    state = Column(String(100), nullable=False, index=True)
    country = Column(String(100), default='India')
    pincode = Column(String(10), nullable=False, index=True)

    is_primary = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    customer = relationship('Customer', back_populates='addresses')


class CustomerKYCDocument(Base):
    __tablename__ = 'customer_kyc_documents'

    id = Column(Integer, primary_key=True, autoincrement=True)
    customer_id = Column(Integer, ForeignKey('customers.id', ondelete='CASCADE'), nullable=False)

    document_type = Column(String(50), nullable=False)
    document_number = Column(String(100))
    document_path = Column(String(500), nullable=False)
    document_name = Column(String(200), nullable=False)

    verification_status = Column(Enum(KYCStatus), default=KYCStatus.PENDING)
    verified_by = Column(Integer, ForeignKey('users.id'))
    verified_at = Column(DateTime)
    remarks = Column(Text)

    is_active = Column(Boolean, default=True)
    uploaded_at = Column(DateTime, default=datetime.utcnow)

    customer = relationship('Customer', back_populates='kyc_documents')


# ============================================================================
# POLICY MANAGEMENT MODELS
# ============================================================================

class PolicyType(Base):
    __tablename__ = 'policy_types'

    id = Column(Integer, primary_key=True, autoincrement=True)
    policy_type_code = Column(String(20), unique=True, nullable=False)
    policy_type_name = Column(String(100), nullable=False)
    description = Column(Text)

    min_sum_assured = Column(Numeric(15, 2))
    max_sum_assured = Column(Numeric(15, 2))
    min_age = Column(Integer)
    max_age = Column(Integer)
    min_term = Column(Integer)
    max_term = Column(Integer)

    base_premium_rate = Column(Numeric(10, 4))
    has_surrender_value = Column(Boolean, default=True)
    surrender_value_factor = Column(Numeric(5, 4))

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    policies = relationship('Policy', back_populates='policy_type')


class Policy(Base):
    __tablename__ = 'policies'

    # Primary Key
    id = Column(Integer, primary_key=True, autoincrement=True)
    policy_number = Column(String(50), unique=True, nullable=False, index=True)

    # Customer & Policy Type
    customer_id = Column(Integer, ForeignKey('customers.id'), nullable=False, index=True)
    policy_type_id = Column(Integer, ForeignKey('policy_types.id'), nullable=False)

    # Policy Details
    sum_assured = Column(Numeric(15, 2), nullable=False)
    policy_term = Column(Integer, nullable=False)  # in years
    premium_payment_term = Column(Integer, nullable=False)  # in years

    # Premium Information
    annual_premium = Column(Numeric(12, 2), nullable=False)
    payment_frequency = Column(Enum('Monthly', 'Quarterly', 'Semi-Annual', 'Annual', name='payment_frequency_enum'))
    installment_premium = Column(Numeric(12, 2), nullable=False)

    # Dates
    policy_start_date = Column(Date, nullable=False, index=True)
    policy_end_date = Column(Date, nullable=False)
    maturity_date = Column(Date, nullable=False)
    next_premium_due_date = Column(Date, index=True)

    # Status
    status = Column(Enum(PolicyStatus), default=PolicyStatus.ACTIVE, index=True)
    current_policy_year = Column(Integer, default=1)

    # Values
    current_surrender_value = Column(Numeric(15, 2), default=0)
    maturity_value = Column(Numeric(15, 2))
    bonus_accumulated = Column(Numeric(15, 2), default=0)
    outstanding_loan = Column(Numeric(15, 2), default=0)

    # Assignment
    branch_id = Column(Integer, ForeignKey('branches.id'))
    agent_id = Column(Integer, ForeignKey('agents.id'), index=True)

    # Flags
    claim_pending = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True, index=True)

    # Audit Fields
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = Column(Integer, ForeignKey('users.id'))
    updated_by = Column(Integer, ForeignKey('users.id'))

    # Relationships
    customer = relationship('Customer', back_populates='policies')
    policy_type = relationship('PolicyType', back_populates='policies')
    nominees = relationship('PolicyNominee', back_populates='policy', cascade='all, delete-orphan')
    riders = relationship('PolicyRider', back_populates='policy', cascade='all, delete-orphan')
    payments = relationship('Payment', back_populates='policy')
    claims = relationship('Claim', back_populates='policy')
    branch = relationship('Branch', back_populates='policies')
    agent = relationship('Agent', back_populates='policies')

    __table_args__ = (
        Index('idx_policy_search', 'policy_number', 'customer_id', 'status'),
        Index('idx_policy_dates', 'next_premium_due_date', 'status'),
    )


class PolicyNominee(Base):
    __tablename__ = 'policy_nominees'

    id = Column(Integer, primary_key=True, autoincrement=True)
    policy_id = Column(Integer, ForeignKey('policies.id', ondelete='CASCADE'), nullable=False)

    nominee_name = Column(String(150), nullable=False)
    relationship_with_insured = Column(String(50), nullable=False)
    date_of_birth = Column(Date)
    age = Column(Integer)
    share_percentage = Column(Numeric(5, 2), nullable=False)

    # Appointee (if nominee is minor)
    appointee_name = Column(String(150))
    appointee_relationship = Column(String(50))

    contact_phone = Column(String(15))
    contact_email = Column(String(100))
    address = Column(Text)

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    policy = relationship('Policy', back_populates='nominees')


class Rider(Base):
    __tablename__ = 'riders'

    id = Column(Integer, primary_key=True, autoincrement=True)
    rider_code = Column(String(20), unique=True, nullable=False)
    rider_name = Column(String(100), nullable=False)
    description = Column(Text)
    premium_rate = Column(Numeric(10, 4))

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    policy_riders = relationship('PolicyRider', back_populates='rider')


class PolicyRider(Base):
    __tablename__ = 'policy_riders'

    id = Column(Integer, primary_key=True, autoincrement=True)
    policy_id = Column(Integer, ForeignKey('policies.id', ondelete='CASCADE'), nullable=False)
    rider_id = Column(Integer, ForeignKey('riders.id'), nullable=False)

    sum_assured = Column(Numeric(15, 2), nullable=False)
    annual_premium = Column(Numeric(12, 2), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date)

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    policy = relationship('Policy', back_populates='riders')
    rider = relationship('Rider', back_populates='policy_riders')


# ============================================================================
# CLAIMS MANAGEMENT MODELS
# ============================================================================

class Claim(Base):
    __tablename__ = 'claims'

    # Primary Key
    id = Column(Integer, primary_key=True, autoincrement=True)
    claim_number = Column(String(50), unique=True, nullable=False, index=True)

    # Policy & Customer
    policy_id = Column(Integer, ForeignKey('policies.id'), nullable=False, index=True)
    customer_id = Column(Integer, ForeignKey('customers.id'), nullable=False)

    # Claim Details
    claim_type = Column(String(50), nullable=False, index=True)
    date_of_event = Column(Date, nullable=False)
    intimation_date = Column(Date, nullable=False)
    registration_date = Column(Date, default=datetime.utcnow)

    # Claimant/Beneficiary
    claimant_name = Column(String(150), nullable=False)
    claimant_relationship = Column(String(50))
    claimant_phone = Column(String(15))
    claimant_email = Column(String(100))

    # Claim Amount
    claim_amount = Column(Numeric(15, 2), nullable=False)
    approved_amount = Column(Numeric(15, 2), default=0)
    paid_amount = Column(Numeric(15, 2), default=0)

    # Status & Priority
    status = Column(Enum(ClaimStatus), default=ClaimStatus.REGISTERED, index=True)
    priority = Column(Enum('Low', 'Medium', 'High', name='claim_priority_enum'), default='Medium')

    # Assignment
    assigned_to = Column(Integer, ForeignKey('users.id'))
    investigator_id = Column(Integer, ForeignKey('users.id'))

    # Investigation
    requires_investigation = Column(Boolean, default=False)
    investigation_status = Column(String(50))
    investigation_remarks = Column(Text)

    # Approval
    approved_by = Column(Integer, ForeignKey('users.id'))
    approved_at = Column(DateTime)
    rejection_reason = Column(Text)

    # Settlement
    settlement_date = Column(Date)
    payment_method = Column(Enum(PaymentMethod))
    transaction_reference = Column(String(100))

    # Flags
    is_active = Column(Boolean, default=True, index=True)

    # Audit Fields
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = Column(Integer, ForeignKey('users.id'))
    updated_by = Column(Integer, ForeignKey('users.id'))

    # Relationships
    policy = relationship('Policy', back_populates='claims')
    documents = relationship('ClaimDocument', back_populates='claim', cascade='all, delete-orphan')

    __table_args__ = (
        Index('idx_claim_search', 'claim_number', 'policy_id', 'status'),
        Index('idx_claim_dates', 'registration_date', 'status'),
    )


class ClaimDocument(Base):
    __tablename__ = 'claim_documents'

    id = Column(Integer, primary_key=True, autoincrement=True)
    claim_id = Column(Integer, ForeignKey('claims.id', ondelete='CASCADE'), nullable=False)

    document_type = Column(String(50), nullable=False)
    document_name = Column(String(200), nullable=False)
    document_path = Column(String(500), nullable=False)

    verification_status = Column(Enum('Pending', 'Verified', 'Rejected', name='doc_verification_enum'))
    verified_by = Column(Integer, ForeignKey('users.id'))
    verified_at = Column(DateTime)
    remarks = Column(Text)

    uploaded_at = Column(DateTime, default=datetime.utcnow)

    claim = relationship('Claim', back_populates='documents')


# ============================================================================
# PAYMENT & BILLING MODELS
# ============================================================================

class Payment(Base):
    __tablename__ = 'payments'

    # Primary Key
    id = Column(Integer, primary_key=True, autoincrement=True)
    payment_id = Column(String(50), unique=True, nullable=False, index=True)
    transaction_id = Column(String(100), unique=True, index=True)

    # Policy & Customer
    policy_id = Column(Integer, ForeignKey('policies.id'), nullable=False, index=True)
    customer_id = Column(Integer, ForeignKey('customers.id'), nullable=False)

    # Payment Details
    payment_type = Column(String(50), nullable=False)
    payment_method = Column(Enum(PaymentMethod), nullable=False)

    # Amount Breakdown
    premium_amount = Column(Numeric(12, 2), nullable=False)
    gst_amount = Column(Numeric(12, 2), default=0)
    late_fee = Column(Numeric(12, 2), default=0)
    discount_amount = Column(Numeric(12, 2), default=0)
    total_amount = Column(Numeric(12, 2), nullable=False)

    # Payment Date
    payment_date = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)
    due_date = Column(Date)

    # Status
    status = Column(Enum(PaymentStatus), default=PaymentStatus.PENDING, index=True)

    # Payment Method Specific Fields
    cheque_number = Column(String(50))
    cheque_date = Column(Date)
    bank_name = Column(String(100))
    cheque_status = Column(String(20))

    card_last_4_digits = Column(String(4))
    upi_id = Column(String(100))

    # Gateway Details
    gateway_name = Column(String(50))
    gateway_transaction_id = Column(String(100))
    gateway_response = Column(Text)

    # Receipt
    receipt_number = Column(String(50), unique=True, index=True)
    receipt_url = Column(String(500))

    # Reconciliation
    is_reconciled = Column(Boolean, default=False)
    reconciled_at = Column(DateTime)

    # Audit Fields
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = Column(Integer, ForeignKey('users.id'))

    # Relationships
    policy = relationship('Policy', back_populates='payments')

    __table_args__ = (
        Index('idx_payment_search', 'payment_id', 'transaction_id', 'policy_id'),
        Index('idx_payment_status', 'status', 'payment_date'),
    )


class PaymentSchedule(Base):
    __tablename__ = 'payment_schedules'

    id = Column(Integer, primary_key=True, autoincrement=True)
    policy_id = Column(Integer, ForeignKey('policies.id', ondelete='CASCADE'), nullable=False)

    installment_number = Column(Integer, nullable=False)
    due_date = Column(Date, nullable=False, index=True)
    amount = Column(Numeric(12, 2), nullable=False)

    status = Column(Enum('Upcoming', 'Due', 'Paid', 'Overdue', name='schedule_status_enum'))
    payment_id = Column(Integer, ForeignKey('payments.id'))
    paid_date = Column(Date)

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    __table_args__ = (
        Index('idx_schedule_due', 'due_date', 'status'),
    )


# ============================================================================
# AGENT/BROKER MANAGEMENT MODELS
# ============================================================================

class Agent(Base):
    __tablename__ = 'agents'

    # Primary Key
    id = Column(Integer, primary_key=True, autoincrement=True)
    agent_code = Column(String(50), unique=True, nullable=False, index=True)

    # Personal Information
    first_name = Column(String(50), nullable=False)
    middle_name = Column(String(50))
    last_name = Column(String(50), nullable=False)
    full_name = Column(String(150), nullable=False, index=True)

    date_of_birth = Column(Date, nullable=False)
    age = Column(Integer)
    gender = Column(Enum('Male', 'Female', 'Other', name='agent_gender_enum'))

    # Contact Information
    email = Column(String(100), unique=True, nullable=False, index=True)
    phone = Column(String(15), unique=True, nullable=False, index=True)
    address = Column(Text)
    city = Column(String(100))
    state = Column(String(100))
    pincode = Column(String(10))

    # License Information
    license_number = Column(String(50), unique=True, nullable=False, index=True)
    license_type = Column(String(50))
    license_issue_date = Column(Date)
    license_valid_till = Column(Date, nullable=False, index=True)

    # Agent Classification
    agent_type = Column(String(50), nullable=False)
    status = Column(Enum(AgentStatus), default=AgentStatus.ACTIVE, index=True)

    # Assignment
    branch_id = Column(Integer, ForeignKey('branches.id'), nullable=False)
    reporting_manager_id = Column(Integer, ForeignKey('agents.id'))
    territory = Column(String(100))

    # Commission Structure
    commission_structure_code = Column(String(20))
    first_year_commission_percentage = Column(Numeric(5, 2))
    renewal_commission_percentage = Column(Numeric(5, 2))

    # Financial Information
    pan_number = Column(String(20), nullable=False, unique=True)
    bank_name = Column(String(100))
    bank_account_number = Column(String(50))
    bank_ifsc_code = Column(String(20))

    # Performance Metrics
    total_policies_sold = Column(Integer, default=0)
    total_premium_collected = Column(Numeric(15, 2), default=0)
    total_commission_earned = Column(Numeric(15, 2), default=0)
    persistency_ratio = Column(Numeric(5, 2), default=0)

    # Dates
    joining_date = Column(Date, nullable=False)
    termination_date = Column(Date)

    # Flags
    is_active = Column(Boolean, default=True, index=True)

    # Audit Fields
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    created_by = Column(Integer, ForeignKey('users.id'))
    updated_by = Column(Integer, ForeignKey('users.id'))

    # Relationships
    customers = relationship('Customer', back_populates='agent')
    policies = relationship('Policy', back_populates='agent')
    branch = relationship('Branch', back_populates='agents')
    commissions = relationship('Commission', back_populates='agent')
    targets = relationship('AgentTarget', back_populates='agent')

    # Self-referential relationship for hierarchy
    team_members = relationship('Agent', backref='reporting_manager', remote_side=[id])

    __table_args__ = (
        Index('idx_agent_search', 'agent_code', 'full_name', 'email'),
        Index('idx_agent_status', 'status', 'is_active', 'branch_id'),
    )


class AgentTarget(Base):
    __tablename__ = 'agent_targets'

    id = Column(Integer, primary_key=True, autoincrement=True)
    agent_id = Column(Integer, ForeignKey('agents.id', ondelete='CASCADE'), nullable=False)

    target_period = Column(String(20))  # Monthly, Quarterly, Annual
    target_year = Column(Integer, nullable=False)
    target_month = Column(Integer)
    target_quarter = Column(Integer)

    premium_target = Column(Numeric(15, 2), nullable=False)
    policies_target = Column(Integer)

    premium_achieved = Column(Numeric(15, 2), default=0)
    policies_achieved = Column(Integer, default=0)
    achievement_percentage = Column(Numeric(5, 2), default=0)

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    agent = relationship('Agent', back_populates='targets')


class Commission(Base):
    __tablename__ = 'commissions'

    id = Column(Integer, primary_key=True, autoincrement=True)
    commission_id = Column(String(50), unique=True, nullable=False, index=True)

    agent_id = Column(Integer, ForeignKey('agents.id'), nullable=False, index=True)
    policy_id = Column(Integer, ForeignKey('policies.id'), nullable=False)
    payment_id = Column(Integer, ForeignKey('payments.id'))

    commission_type = Column(Enum('First Year', 'Renewal', 'Override', name='commission_type_enum'))
    premium_amount = Column(Numeric(12, 2), nullable=False)
    commission_rate = Column(Numeric(5, 2), nullable=False)
    commission_amount = Column(Numeric(12, 2), nullable=False)

    tds_amount = Column(Numeric(12, 2), default=0)
    net_commission = Column(Numeric(12, 2), nullable=False)

    status = Column(Enum('Pending', 'Approved', 'Paid', name='commission_status_enum'))
    payment_date = Column(Date)
    payment_reference = Column(String(100))

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    agent = relationship('Agent', back_populates='commissions')


# ============================================================================
# BRANCH & ORGANIZATION MODELS
# ============================================================================

class Branch(Base):
    __tablename__ = 'branches'

    id = Column(Integer, primary_key=True, autoincrement=True)
    branch_code = Column(String(20), unique=True, nullable=False, index=True)
    branch_name = Column(String(100), nullable=False)

    address = Column(Text)
    city = Column(String(100), nullable=False)
    state = Column(String(100), nullable=False)
    pincode = Column(String(10))

    phone = Column(String(15))
    email = Column(String(100))

    manager_id = Column(Integer, ForeignKey('users.id'))

    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    customers = relationship('Customer', back_populates='branch')
    policies = relationship('Policy', back_populates='branch')
    agents = relationship('Agent', back_populates='branch')


# ============================================================================
# USER & ACCESS CONTROL MODELS
# ============================================================================

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50), unique=True, nullable=False, index=True)
    email = Column(String(100), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)

    full_name = Column(String(150), nullable=False)
    phone = Column(String(15))

    role = Column(String(50), nullable=False)
    department = Column(String(50))

    is_active = Column(Boolean, default=True)
    last_login = Column(DateTime)

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


# ============================================================================
# AUDIT TRAIL MODEL
# ============================================================================

class AuditLog(Base):
    __tablename__ = 'audit_logs'

    id = Column(Integer, primary_key=True, autoincrement=True)

    table_name = Column(String(100), nullable=False, index=True)
    record_id = Column(Integer, nullable=False)
    action = Column(Enum('CREATE', 'UPDATE', 'DELETE', name='audit_action_enum'), nullable=False)

    old_values = Column(Text)
    new_values = Column(Text)

    user_id = Column(Integer, ForeignKey('users.id'))
    ip_address = Column(String(50))
    user_agent = Column(String(200))

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False, index=True)

    __table_args__ = (
        Index('idx_audit_search', 'table_name', 'record_id', 'created_at'),
    )
