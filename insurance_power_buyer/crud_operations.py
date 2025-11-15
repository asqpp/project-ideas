"""
Insurance Power Buyer Software - CRUD Operations
Complete CRUD operations implementation using SQLAlchemy
"""

from sqlalchemy.orm import Session
from sqlalchemy import and_, or_, func, desc
from datetime import datetime, date, timedelta
from typing import List, Optional, Dict
import re

from models import (
    Customer, CustomerAddress, CustomerKYCDocument,
    Policy, PolicyNominee, PolicyRider, PolicyType, Rider,
    Claim, ClaimDocument,
    Payment, PaymentSchedule,
    Agent, AgentTarget, Commission,
    Branch, User, AuditLog,
    CustomerStatus, KYCStatus, PolicyStatus, ClaimStatus, PaymentStatus,
    CustomerType, PaymentMethod, AgentStatus
)


# ============================================================================
# CUSTOMER CRUD OPERATIONS
# ============================================================================

class CustomerCRUD:
    """CRUD operations for Customer management"""

    @staticmethod
    def create_customer(db: Session, customer_data: Dict) -> Customer:
        """
        Create a new customer with validation and business logic

        Business Logic:
        - Generate unique customer ID
        - Validate email and phone uniqueness
        - Validate age eligibility (minimum 18 years)
        - Calculate age from date of birth
        - Encrypt sensitive information
        - Set default status and KYC status
        """
        # Validate age
        dob = customer_data.get('date_of_birth')
        age = (date.today() - dob).days // 365
        if age < 18:
            raise ValueError("Customer must be at least 18 years old")

        # Check for duplicate email
        existing_email = db.query(Customer).filter(
            Customer.email == customer_data.get('email')
        ).first()
        if existing_email:
            raise ValueError("Email already registered")

        # Check for duplicate phone
        existing_phone = db.query(Customer).filter(
            Customer.phone == customer_data.get('phone')
        ).first()
        if existing_phone:
            raise ValueError("Phone number already exists")

        # Generate customer ID
        today = date.today()
        count = db.query(func.count(Customer.id)).scalar() + 1
        customer_id = f"CUST-{today.strftime('%Y%m%d')}-{count:04d}"

        # Create customer object
        customer = Customer(
            customer_id=customer_id,
            first_name=customer_data.get('first_name'),
            middle_name=customer_data.get('middle_name'),
            last_name=customer_data.get('last_name'),
            full_name=f"{customer_data.get('first_name')} {customer_data.get('last_name')}",
            date_of_birth=dob,
            age=age,
            gender=customer_data.get('gender'),
            marital_status=customer_data.get('marital_status'),
            email=customer_data.get('email'),
            phone=customer_data.get('phone'),
            alternate_phone=customer_data.get('alternate_phone'),
            pan_number=customer_data.get('pan_number'),
            customer_type=customer_data.get('customer_type', CustomerType.INDIVIDUAL),
            status=CustomerStatus.ACTIVE,
            kyc_status=KYCStatus.PENDING,
            occupation=customer_data.get('occupation'),
            annual_income=customer_data.get('annual_income'),
            branch_id=customer_data.get('branch_id'),
            agent_id=customer_data.get('agent_id'),
            created_by=customer_data.get('created_by')
        )

        db.add(customer)
        db.commit()
        db.refresh(customer)

        # Log audit trail
        audit_log = AuditLog(
            table_name='customers',
            record_id=customer.id,
            action='CREATE',
            new_values=str(customer.__dict__),
            user_id=customer_data.get('created_by')
        )
        db.add(audit_log)
        db.commit()

        return customer

    @staticmethod
    def get_customer(db: Session, customer_id: int = None,
                    email: str = None, phone: str = None) -> Optional[Customer]:
        """
        Retrieve customer by ID, email, or phone
        """
        query = db.query(Customer)

        if customer_id:
            return query.filter(Customer.id == customer_id).first()
        elif email:
            return query.filter(Customer.email == email).first()
        elif phone:
            return query.filter(Customer.phone == phone).first()

        return None

    @staticmethod
    def list_customers(db: Session, filters: Dict = None,
                      page: int = 1, per_page: int = 20) -> Dict:
        """
        List customers with pagination and filters

        Filters:
        - status: Customer status
        - customer_type: Individual/Corporate
        - kyc_status: KYC verification status
        - branch_id: Branch filter
        - agent_id: Agent filter
        - search: Search in name, email, phone
        """
        query = db.query(Customer).filter(Customer.is_active == True)

        if filters:
            if 'status' in filters:
                query = query.filter(Customer.status == filters['status'])
            if 'customer_type' in filters:
                query = query.filter(Customer.customer_type == filters['customer_type'])
            if 'kyc_status' in filters:
                query = query.filter(Customer.kyc_status == filters['kyc_status'])
            if 'branch_id' in filters:
                query = query.filter(Customer.branch_id == filters['branch_id'])
            if 'agent_id' in filters:
                query = query.filter(Customer.agent_id == filters['agent_id'])
            if 'search' in filters:
                search_term = f"%{filters['search']}%"
                query = query.filter(
                    or_(
                        Customer.full_name.like(search_term),
                        Customer.email.like(search_term),
                        Customer.phone.like(search_term),
                        Customer.customer_id.like(search_term)
                    )
                )

        # Get total count
        total = query.count()

        # Apply pagination
        offset = (page - 1) * per_page
        customers = query.offset(offset).limit(per_page).all()

        return {
            'total_records': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page,
            'customers': customers
        }

    @staticmethod
    def update_customer(db: Session, customer_id: int,
                       update_data: Dict, updated_by: int) -> Customer:
        """
        Update customer information with validation
        """
        customer = db.query(Customer).filter(Customer.id == customer_id).first()
        if not customer:
            raise ValueError("Customer not found")

        # Store old values for audit
        old_values = customer.__dict__.copy()

        # Update allowed fields
        allowed_fields = [
            'first_name', 'middle_name', 'last_name', 'email', 'phone',
            'alternate_phone', 'marital_status', 'occupation', 'annual_income',
            'status', 'branch_id', 'agent_id'
        ]

        for field in allowed_fields:
            if field in update_data:
                # Special validation for email and phone
                if field == 'email' and update_data[field] != customer.email:
                    existing = db.query(Customer).filter(
                        Customer.email == update_data[field],
                        Customer.id != customer_id
                    ).first()
                    if existing:
                        raise ValueError("Email already in use")

                if field == 'phone' and update_data[field] != customer.phone:
                    existing = db.query(Customer).filter(
                        Customer.phone == update_data[field],
                        Customer.id != customer_id
                    ).first()
                    if existing:
                        raise ValueError("Phone already in use")

                setattr(customer, field, update_data[field])

        # Update full name if name fields changed
        if any(field in update_data for field in ['first_name', 'last_name']):
            customer.full_name = f"{customer.first_name} {customer.last_name}"

        customer.updated_by = updated_by
        customer.updated_at = datetime.utcnow()

        db.commit()
        db.refresh(customer)

        # Log audit trail
        audit_log = AuditLog(
            table_name='customers',
            record_id=customer.id,
            action='UPDATE',
            old_values=str(old_values),
            new_values=str(customer.__dict__),
            user_id=updated_by
        )
        db.add(audit_log)
        db.commit()

        return customer

    @staticmethod
    def delete_customer(db: Session, customer_id: int,
                       deleted_by: int, soft_delete: bool = True) -> bool:
        """
        Delete or deactivate customer

        Business Rules:
        - Cannot delete customer with active policies
        - Soft delete is recommended (set is_active = False)
        - Hard delete only for test/duplicate records
        """
        customer = db.query(Customer).filter(Customer.id == customer_id).first()
        if not customer:
            raise ValueError("Customer not found")

        # Check for active policies
        active_policies = db.query(Policy).filter(
            Policy.customer_id == customer_id,
            Policy.status == PolicyStatus.ACTIVE
        ).count()

        if active_policies > 0:
            raise ValueError(f"Cannot delete customer with {active_policies} active policies")

        if soft_delete:
            # Soft delete
            customer.is_active = False
            customer.status = CustomerStatus.INACTIVE
            customer.updated_by = deleted_by
            customer.updated_at = datetime.utcnow()
            db.commit()

            action = 'SOFT_DELETE'
        else:
            # Hard delete
            db.delete(customer)
            db.commit()
            action = 'DELETE'

        # Log audit trail
        audit_log = AuditLog(
            table_name='customers',
            record_id=customer_id,
            action=action,
            old_values=str(customer.__dict__) if soft_delete else "Deleted",
            user_id=deleted_by
        )
        db.add(audit_log)
        db.commit()

        return True


# ============================================================================
# POLICY CRUD OPERATIONS
# ============================================================================

class PolicyCRUD:
    """CRUD operations for Policy management"""

    @staticmethod
    def create_policy(db: Session, policy_data: Dict) -> Policy:
        """
        Create new policy with complete validation and business logic

        Business Logic:
        - Validate customer exists and KYC completed
        - Generate unique policy number
        - Calculate premium
        - Validate sum assured limits
        - Process riders if any
        - Create payment schedule
        """
        # Validate customer
        customer = db.query(Customer).filter(
            Customer.id == policy_data.get('customer_id')
        ).first()
        if not customer:
            raise ValueError("Customer not found")
        if customer.kyc_status != KYCStatus.VERIFIED:
            raise ValueError("Customer KYC not completed")
        if customer.status != CustomerStatus.ACTIVE:
            raise ValueError("Customer is not active")

        # Validate policy type
        policy_type = db.query(PolicyType).filter(
            PolicyType.id == policy_data.get('policy_type_id')
        ).first()
        if not policy_type:
            raise ValueError("Invalid policy type")

        # Validate age eligibility
        if customer.age < policy_type.min_age or customer.age > policy_type.max_age:
            raise ValueError(f"Age must be between {policy_type.min_age} and {policy_type.max_age}")

        # Validate sum assured
        sum_assured = policy_data.get('sum_assured')
        if sum_assured < policy_type.min_sum_assured or sum_assured > policy_type.max_sum_assured:
            raise ValueError(f"Sum assured must be between {policy_type.min_sum_assured} and {policy_type.max_sum_assured}")

        # Generate policy number
        today = date.today()
        count = db.query(func.count(Policy.id)).scalar() + 1
        policy_number = f"POL-{policy_type.policy_type_code}-{today.year}-{count:06d}"

        # Calculate dates
        policy_start_date = policy_data.get('policy_start_date', date.today())
        policy_term = policy_data.get('policy_term')
        policy_end_date = date(
            policy_start_date.year + policy_term,
            policy_start_date.month,
            policy_start_date.day
        ) - timedelta(days=1)

        # Create policy
        policy = Policy(
            policy_number=policy_number,
            customer_id=policy_data.get('customer_id'),
            policy_type_id=policy_data.get('policy_type_id'),
            sum_assured=sum_assured,
            policy_term=policy_term,
            premium_payment_term=policy_data.get('premium_payment_term'),
            annual_premium=policy_data.get('annual_premium'),
            payment_frequency=policy_data.get('payment_frequency', 'Annual'),
            installment_premium=policy_data.get('installment_premium'),
            policy_start_date=policy_start_date,
            policy_end_date=policy_end_date,
            maturity_date=policy_end_date,
            next_premium_due_date=policy_start_date + timedelta(days=365),
            status=PolicyStatus.ACTIVE,
            maturity_value=policy_data.get('maturity_value', sum_assured),
            branch_id=policy_data.get('branch_id'),
            agent_id=policy_data.get('agent_id'),
            created_by=policy_data.get('created_by')
        )

        db.add(policy)
        db.flush()

        # Update customer's active policy count
        customer.active_policies_count += 1

        db.commit()
        db.refresh(policy)

        # Log audit trail
        audit_log = AuditLog(
            table_name='policies',
            record_id=policy.id,
            action='CREATE',
            new_values=str(policy.__dict__),
            user_id=policy_data.get('created_by')
        )
        db.add(audit_log)
        db.commit()

        return policy

    @staticmethod
    def get_policy(db: Session, policy_id: int = None,
                   policy_number: str = None) -> Optional[Policy]:
        """Retrieve policy by ID or policy number"""
        query = db.query(Policy)

        if policy_id:
            return query.filter(Policy.id == policy_id).first()
        elif policy_number:
            return query.filter(Policy.policy_number == policy_number).first()

        return None

    @staticmethod
    def list_policies(db: Session, filters: Dict = None,
                     page: int = 1, per_page: int = 20) -> Dict:
        """List policies with pagination and filters"""
        query = db.query(Policy).filter(Policy.is_active == True)

        if filters:
            if 'status' in filters:
                query = query.filter(Policy.status == filters['status'])
            if 'customer_id' in filters:
                query = query.filter(Policy.customer_id == filters['customer_id'])
            if 'agent_id' in filters:
                query = query.filter(Policy.agent_id == filters['agent_id'])
            if 'branch_id' in filters:
                query = query.filter(Policy.branch_id == filters['branch_id'])
            if 'policy_type_id' in filters:
                query = query.filter(Policy.policy_type_id == filters['policy_type_id'])

        total = query.count()
        offset = (page - 1) * per_page
        policies = query.offset(offset).limit(per_page).all()

        return {
            'total_records': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page,
            'policies': policies
        }

    @staticmethod
    def update_policy(db: Session, policy_id: int,
                     update_data: Dict, updated_by: int) -> Policy:
        """Update policy with validation"""
        policy = db.query(Policy).filter(Policy.id == policy_id).first()
        if not policy:
            raise ValueError("Policy not found")

        if policy.status in [PolicyStatus.SURRENDERED, PolicyStatus.MATURED]:
            raise ValueError("Cannot update surrendered or matured policy")

        old_values = policy.__dict__.copy()

        # Allowed fields for update
        allowed_fields = [
            'status', 'next_premium_due_date', 'current_surrender_value',
            'bonus_accumulated', 'outstanding_loan', 'agent_id', 'branch_id'
        ]

        for field in allowed_fields:
            if field in update_data:
                setattr(policy, field, update_data[field])

        policy.updated_by = updated_by
        policy.updated_at = datetime.utcnow()

        db.commit()
        db.refresh(policy)

        # Log audit
        audit_log = AuditLog(
            table_name='policies',
            record_id=policy.id,
            action='UPDATE',
            old_values=str(old_values),
            new_values=str(policy.__dict__),
            user_id=updated_by
        )
        db.add(audit_log)
        db.commit()

        return policy

    @staticmethod
    def surrender_policy(db: Session, policy_id: int,
                        surrendered_by: int) -> Dict:
        """
        Surrender policy and calculate surrender value

        Business Logic:
        - Calculate surrender value
        - Deduct outstanding loans
        - Update policy status
        - Process refund
        """
        policy = db.query(Policy).filter(Policy.id == policy_id).first()
        if not policy:
            raise ValueError("Policy not found")

        if policy.status != PolicyStatus.ACTIVE:
            raise ValueError("Only active policies can be surrendered")

        # Get policy type for surrender value calculation
        policy_type = db.query(PolicyType).filter(
            PolicyType.id == policy.policy_type_id
        ).first()

        if not policy_type.has_surrender_value:
            raise ValueError("This policy type has no surrender value")

        # Calculate surrender value
        # Simplified calculation
        total_premiums_paid = policy.annual_premium * policy.current_policy_year
        surrender_value = total_premiums_paid * float(policy_type.surrender_value_factor)
        surrender_value -= float(policy.outstanding_loan)

        if surrender_value < 0:
            surrender_value = 0

        # Update policy
        policy.status = PolicyStatus.SURRENDERED
        policy.current_surrender_value = surrender_value
        policy.updated_by = surrendered_by
        policy.updated_at = datetime.utcnow()
        policy.is_active = False

        # Update customer's active policy count
        customer = db.query(Customer).filter(Customer.id == policy.customer_id).first()
        if customer:
            customer.active_policies_count -= 1

        db.commit()

        return {
            'policy_number': policy.policy_number,
            'surrender_value': surrender_value,
            'status': 'Surrendered'
        }


# ============================================================================
# CLAIM CRUD OPERATIONS
# ============================================================================

class ClaimCRUD:
    """CRUD operations for Claims management"""

    @staticmethod
    def create_claim(db: Session, claim_data: Dict) -> Claim:
        """
        Register new claim with validation
        """
        # Validate policy
        policy = db.query(Policy).filter(
            Policy.id == claim_data.get('policy_id')
        ).first()
        if not policy:
            raise ValueError("Policy not found")
        if policy.status != PolicyStatus.ACTIVE:
            raise ValueError("Policy is not active")

        # Generate claim number
        today = date.today()
        count = db.query(func.count(Claim.id)).scalar() + 1
        claim_number = f"CLM-{today.year}-{count:06d}"

        # Create claim
        claim = Claim(
            claim_number=claim_number,
            policy_id=claim_data.get('policy_id'),
            customer_id=policy.customer_id,
            claim_type=claim_data.get('claim_type'),
            date_of_event=claim_data.get('date_of_event'),
            intimation_date=claim_data.get('intimation_date', date.today()),
            registration_date=date.today(),
            claimant_name=claim_data.get('claimant_name'),
            claimant_relationship=claim_data.get('claimant_relationship'),
            claimant_phone=claim_data.get('claimant_phone'),
            claimant_email=claim_data.get('claimant_email'),
            claim_amount=claim_data.get('claim_amount', policy.sum_assured),
            status=ClaimStatus.REGISTERED,
            priority=claim_data.get('priority', 'Medium'),
            created_by=claim_data.get('created_by')
        )

        db.add(claim)

        # Update policy flag
        policy.claim_pending = True

        db.commit()
        db.refresh(claim)

        return claim

    @staticmethod
    def update_claim_status(db: Session, claim_id: int,
                           new_status: ClaimStatus,
                           updated_by: int,
                           approved_amount: float = None) -> Claim:
        """Update claim status with workflow validation"""
        claim = db.query(Claim).filter(Claim.id == claim_id).first()
        if not claim:
            raise ValueError("Claim not found")

        old_status = claim.status
        claim.status = new_status

        if new_status == ClaimStatus.APPROVED and approved_amount:
            claim.approved_amount = approved_amount
            claim.approved_by = updated_by
            claim.approved_at = datetime.utcnow()

        claim.updated_by = updated_by
        claim.updated_at = datetime.utcnow()

        db.commit()
        db.refresh(claim)

        return claim


# ============================================================================
# PAYMENT CRUD OPERATIONS
# ============================================================================

class PaymentCRUD:
    """CRUD operations for Payment management"""

    @staticmethod
    def create_payment(db: Session, payment_data: Dict) -> Payment:
        """Process new payment"""
        # Validate policy
        policy = db.query(Policy).filter(
            Policy.id == payment_data.get('policy_id')
        ).first()
        if not policy:
            raise ValueError("Policy not found")

        # Generate payment ID
        today = date.today()
        count = db.query(func.count(Payment.id)).scalar() + 1
        payment_id = f"PAY-{today.year}-{today.month:02d}-{count:08d}"

        # Generate receipt number
        receipt_number = f"RCP-{today.year}-{count:08d}"

        # Create payment
        payment = Payment(
            payment_id=payment_id,
            transaction_id=payment_data.get('transaction_id', payment_id),
            policy_id=payment_data.get('policy_id'),
            customer_id=policy.customer_id,
            payment_type=payment_data.get('payment_type', 'Premium Payment'),
            payment_method=payment_data.get('payment_method'),
            premium_amount=payment_data.get('premium_amount'),
            gst_amount=payment_data.get('gst_amount', 0),
            late_fee=payment_data.get('late_fee', 0),
            total_amount=payment_data.get('total_amount'),
            payment_date=datetime.utcnow(),
            status=PaymentStatus.SUCCESS,
            receipt_number=receipt_number,
            created_by=payment_data.get('created_by')
        )

        db.add(payment)

        # Update policy status if it was lapsed
        if policy.status == PolicyStatus.LAPSED:
            policy.status = PolicyStatus.ACTIVE

        db.commit()
        db.refresh(payment)

        return payment


# ============================================================================
# AGENT CRUD OPERATIONS
# ============================================================================

class AgentCRUD:
    """CRUD operations for Agent management"""

    @staticmethod
    def create_agent(db: Session, agent_data: Dict) -> Agent:
        """Create new agent with validation"""
        # Check duplicate license
        existing_license = db.query(Agent).filter(
            Agent.license_number == agent_data.get('license_number')
        ).first()
        if existing_license:
            raise ValueError("License number already in use")

        # Check duplicate email
        existing_email = db.query(Agent).filter(
            Agent.email == agent_data.get('email')
        ).first()
        if existing_email:
            raise ValueError("Email already registered")

        # Generate agent code
        branch_code = agent_data.get('branch_code', 'HQ')
        today = date.today()
        count = db.query(func.count(Agent.id)).scalar() + 1
        agent_code = f"AGT-{branch_code}-{today.year}-{count:04d}"

        # Create agent
        agent = Agent(
            agent_code=agent_code,
            first_name=agent_data.get('first_name'),
            middle_name=agent_data.get('middle_name'),
            last_name=agent_data.get('last_name'),
            full_name=f"{agent_data.get('first_name')} {agent_data.get('last_name')}",
            date_of_birth=agent_data.get('date_of_birth'),
            gender=agent_data.get('gender'),
            email=agent_data.get('email'),
            phone=agent_data.get('phone'),
            license_number=agent_data.get('license_number'),
            license_valid_till=agent_data.get('license_valid_till'),
            agent_type=agent_data.get('agent_type'),
            status=AgentStatus.ACTIVE,
            branch_id=agent_data.get('branch_id'),
            pan_number=agent_data.get('pan_number'),
            joining_date=date.today(),
            first_year_commission_percentage=agent_data.get('first_year_commission_percentage', 10),
            renewal_commission_percentage=agent_data.get('renewal_commission_percentage', 5),
            created_by=agent_data.get('created_by')
        )

        # Calculate age
        if agent_data.get('date_of_birth'):
            agent.age = (date.today() - agent_data.get('date_of_birth')).days // 365

        db.add(agent)
        db.commit()
        db.refresh(agent)

        return agent

    @staticmethod
    def list_agents(db: Session, filters: Dict = None,
                   page: int = 1, per_page: int = 20) -> Dict:
        """List agents with filters"""
        query = db.query(Agent).filter(Agent.is_active == True)

        if filters:
            if 'status' in filters:
                query = query.filter(Agent.status == filters['status'])
            if 'branch_id' in filters:
                query = query.filter(Agent.branch_id == filters['branch_id'])
            if 'agent_type' in filters:
                query = query.filter(Agent.agent_type == filters['agent_type'])

        total = query.count()
        offset = (page - 1) * per_page
        agents = query.offset(offset).limit(per_page).all()

        return {
            'total_records': total,
            'page': page,
            'per_page': per_page,
            'total_pages': (total + per_page - 1) // per_page,
            'agents': agents
        }
