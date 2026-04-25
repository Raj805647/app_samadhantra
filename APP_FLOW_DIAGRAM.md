# Samadhantra App - Complete Flow Diagram

## 🔄 Complete User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPLASH SCREEN                                 │
│              (Check if first time / logged in)                  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  ONBOARDING SCREEN                               │
│            (App introduction, features)                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    LOGIN/REGISTRATION                           │
│  ┌────────────────────┐      ┌────────────────────┐           │
│  │   STAKEHOLDER      │      │ SERVICE PROVIDER    │           │
│  │   (Demand Side)    │      │  (Supply Side)      │           │
│  └─────────┬──────────┘      └──────────┬─────────┘           │
└────────────┼─────────────────────────────┼─────────────────────┘
             │                              │
             ▼                              ▼
```

---

## 📱 STAKEHOLDER MODULE FLOW

```
┌─────────────────────────────────────────────────────────────────┐
│                    ROLE SELECTION                                │
│  (Startup, MSME, Corporate, Institute, Student, Freelancer)     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  COMPLETE PROFILE                                │
│         (Personal/Business information)                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BOTTOM NAVIGATION                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│  │   HOME   │ │REQUIREMENTS│ │ASSIGNMENTS│ │ MESSAGES │        │
│  └────┬─────┘ └─────┬──────┘ └─────┬─────┘ └─────┬─────┘        │
│       │            │               │             │              │
│       ▼            ▼               ▼             ▼              │
│  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │ Dashboard│ │  List All │ │ │ │ │ │ │         │
│  │  Stats   │ │Requirements│ │Assigned  │ │Conversations│        │
│  │  Recent  │ │  Filter   │ │Providers │ │  New Msg   │        │
│  │  Post    │ │  Search   │ │  Details │ │  Details   │        │
│  └────┬─────┘ └─────┬──────┘ └─────┬─────┘ └─────┬─────┘        │
└───────┼──────────────┼──────────────┼─────────────┼─────────────┘
        │              │              │             │
        │              │              │             │
        ▼              ▼              ▼             ▼
```

### **Home Screen Flow**
```
HOME SCREEN
    │
    ├─► Post New Requirement ──► POST REQUIREMENT SCREEN
    │                                    │
    │                                    ├─► Fill Form (Title, Category, Description, Budget, Deadline, Location)
    │                                    │
    │                                    └─► Submit ──► Requirement Posted
    │
    ├─► View Recent Requirements ──► REQUIREMENT DETAILS SCREEN
    │                                        │
    │                                        ├─► View Proposals ──► PROPOSALS LIST SCREEN
    │                                        │                          │
    │                                        │                          ├─► View Proposal ──► PROPOSAL DETAILS SCREEN
    │                                        │                          │                          │
    │                                        │                          │                          ├─► Accept ──► CREATE ASSIGNMENT
    │                                        │                          │                          │
    │                                        │                          │                          └─► Reject ──► Proposal Rejected
    │                                        │                          │
    │                                        │                          └─► Shortlist ──► SHORTLISTED PROVIDERS
    │                                        │
    │                                        └─► Edit/Delete Requirement
    │
    └─► View Stats (Active Projects, Completed, In Review)
```

### **Requirements List Flow**
```
REQUIREMENTS LIST SCREEN
    │
    ├─► Filter/Search Requirements
    │
    ├─► View Requirement ──► REQUIREMENT DETAILS SCREEN
    │
    └─► Post New Requirement ──► POST REQUIREMENT SCREEN
```

### **Assignments Flow**
```
ASSIGNMENTS SCREEN
    │
    ├─► View Assignment ──► ASSIGNMENT DETAILS SCREEN
    │                            │
    │                            ├─► View Milestones ──► MILESTONE MANAGEMENT
    │                            │
    │                            ├─► View Documents ──► DOCUMENT VIEWER
    │                            │
    │                            ├─► Make Payment ──► PAYMENT SCREEN
    │                            │                        │
    │                            │                        ├─► Payment History ──► PAYMENT HISTORY SCREEN
    │                            │                        │
    │                            │                        └─► Payment Methods ──► PAYMENT METHODS SCREEN
    │                            │
    │                            ├─► Update Status
    │                            │
    │                            └─► Review Provider ──► REVIEW SCREEN
    │
    └─► Create New Assignment (from accepted proposal)
```

### **Messages Flow**
```
MESSAGES SCREEN
    │
    ├─► View Conversation ──► MESSAGE DETAILS SCREEN
    │                            │
    │                            ├─► Send Message
    │                            │
    │                            └─► Share Documents
    │
    └─► New Message ──► NEW MESSAGE SCREEN
                            │
                            └─► Select Recipient ──► Start Conversation
```

### **Profile Flow**
```
PROFILE SCREEN
    │
    ├─► Edit Profile ──► EDIT PROFILE SCREEN
    │
    ├─► Settings ──► SETTINGS SCREEN
    │                    │
    │                    ├─► Notification Settings
    │                    ├─► Privacy Settings
    │                    └─► Change Password
    │
    ├─► Payment Methods ──► PAYMENT METHODS SCREEN
    │
    ├─► Support ──► SUPPORT SCREEN
    │
    └─► Logout
```

---

## 🏢 SERVICE PROVIDER MODULE FLOW

```
┌─────────────────────────────────────────────────────────────────┐
│              SERVICE PROVIDER LOGIN/SIGNUP                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              BUSINESS PROFILE SETUP                              │
│  (Business Name, Services, Portfolio, Certifications)            │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BOTTOM NAVIGATION                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│  │   HOME   │ │OPPORTUNITIES│ │PROPOSALS│ │ASSIGNMENTS│        │
│  └────┬─────┘ └─────┬──────┘ └─────┬─────┘ └─────┬─────┘        │
│       │            │               │             │              │
│       ▼            ▼               ▼             ▼              │
│  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │ Dashboard│ │  Browse   │ │  My      │ │  My      │         │
│  │  Stats   │ │Requirements│ │Proposals │ │Assignments│        │
│  │ Earnings │ │  Filter   │ │  Status  │ │  Active  │        │
│  │  Active  │ │  Search   │ │  Edit    │ │  Details │        │
│  └────┬─────┘ └─────┬──────┘ └─────┬─────┘ └─────┬─────┘        │
└───────┼──────────────┼──────────────┼─────────────┼─────────────┘
        │              │              │             │
        │              │              │             │
        ▼              ▼              ▼             ▼
```

### **Provider Home Screen Flow**
```
PROVIDER HOME SCREEN
    │
    ├─► View Stats (Active Proposals, Assignments, Earnings)
    │
    ├─► Browse Opportunities ──► OPPORTUNITIES SCREEN
    │
    ├─► My Proposals ──► MY PROPOSALS SCREEN
    │
    └─► My Assignments ──► MY ASSIGNMENTS SCREEN
```

### **Opportunities Flow**
```
OPPORTUNITIES SCREEN
    │
    ├─► Filter/Search Requirements
    │
    ├─► View Requirement ──► REQUIREMENT DETAILS SCREEN (Provider View)
    │                            │
    │                            ├─► View Details
    │                            │
    │                            └─► Submit Proposal ──► SUBMIT PROPOSAL SCREEN
    │                                                       │
    │                                                       ├─► Fill Proposal Form
    │                                                       │   (Price, Timeline, Description, Portfolio)
    │                                                       │
    │                                                       └─► Submit ──► Proposal Submitted
    │
    └─► Save Requirement (Bookmark)
```

### **My Proposals Flow**
```
MY PROPOSALS SCREEN
    │
    ├─► View Proposal ──► PROPOSAL DETAILS SCREEN
    │                          │
    │                          ├─► View Status (Pending/Shortlisted/Accepted/Rejected)
    │                          │
    │                          ├─► Edit Proposal (if pending)
    │                          │
    │                          └─► Withdraw Proposal
    │
    └─► Filter by Status
```

### **My Assignments Flow**
```
MY ASSIGNMENTS SCREEN
    │
    ├─► View Assignment ──► ASSIGNMENT DETAILS SCREEN (Provider View)
    │                            │
    │                            ├─► View Milestones ──► UPDATE MILESTONE SCREEN
    │                            │                          │
    │                            │                          └─► Mark Complete ──► Upload Deliverables
    │                            │
    │                            ├─► Upload Deliverables ──► UPLOAD SCREEN
    │                            │
    │                            ├─► Update Progress ──► PROGRESS UPDATE SCREEN
    │                            │
    │                            ├─► Request Payment ──► PAYMENT REQUEST SCREEN
    │                            │
    │                            └─► Message Stakeholder ──► MESSAGE SCREEN
    │
    └─► Filter by Status
```

### **Provider Profile Flow**
```
PROVIDER PROFILE SCREEN
    │
    ├─► Edit Business Profile ──► EDIT PROFILE SCREEN
    │
    ├─► My Services ──► SERVICES MANAGEMENT SCREEN
    │
    ├─► Portfolio ──► PORTFOLIO SCREEN
    │                    │
    │                    └─► Add Portfolio Item ──► ADD PORTFOLIO SCREEN
    │
    ├─► Certifications ──► CERTIFICATIONS SCREEN
    │
    ├─► Earnings ──► EARNINGS DASHBOARD
    │                    │
    │                    ├─► Payment History
    │                    │
    │                    └─► Payment Methods ──► PAYMENT METHODS SCREEN
    │
    ├─► My Reviews ──► REVIEWS SCREEN
    │
    ├─► Settings ──► SETTINGS SCREEN
    │
    └─► Logout
```

---

## 🔗 Interaction Flow Between Modules

```
┌─────────────────────────────────────────────────────────────────┐
│                    SAMADHANTRA PLATFORM                          │
│                    (Admin/Mediator)                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ Monitors & Mediates
                         │
        ┌────────────────┴────────────────┐
        │                                  │
        ▼                                  ▼
┌───────────────┐                  ┌───────────────┐
│  STAKEHOLDER  │                  │SERVICE PROVIDER│
│  (Demand)     │                  │   (Supply)     │
└───────┬───────┘                  └───────┬───────┘
        │                                  │
        │ Posts Requirement                 │
        │                                  │
        ▼                                  │
┌──────────────────┐                      │
│  REQUIREMENT     │                      │
│  (Active)        │                      │
└───────┬──────────┘                      │
        │                                  │
        │                                  │ Views & Submits Proposal
        │                                  │
        ▼                                  ▼
┌──────────────────┐              ┌──────────────────┐
│  PROPOSALS      │              │  PROPOSAL         │
│  (Received)     │◄─────────────│  (Submitted)      │
└───────┬──────────┘              └──────────────────┘
        │
        │ Reviews & Accepts
        │
        ▼
┌──────────────────┐
│  ASSIGNMENT      │
│  (Created)        │
└───────┬──────────┘
        │
        │ Both parties collaborate
        │
        ├──────────────────┐
        │                  │
        ▼                  ▼
┌──────────────┐    ┌──────────────┐
│  MILESTONES  │    │  DELIVERABLES│
│  (Tracked)   │    │  (Uploaded)  │
└───────┬──────┘    └───────┬──────┘
        │                  │
        │                  │
        ▼                  ▼
┌──────────────────┐
│  PAYMENT         │
│  (Processed)     │
└───────┬──────────┘
        │
        │
        ▼
┌──────────────────┐
│  REVIEW          │
│  (Completed)     │
└──────────────────┘
```

---

## 📊 Status Flow Diagram

### **Requirement Status Flow**
```
DRAFT → ACTIVE → IN_REVIEW → COMPLETED
         │
         └─► CANCELLED
```

### **Proposal Status Flow**
```
PENDING → SHORTLISTED → ACCEPTED → ASSIGNMENT CREATED
   │           │
   │           └─► REJECTED
   │
   └─► WITHDRAWN
```

### **Assignment Status Flow**
```
ASSIGNED → IN_PROGRESS → MILESTONE_COMPLETE → COMPLETED
    │            │
    │            └─► ON_HOLD
    │
    └─► CANCELLED
```

### **Payment Status Flow**
```
PENDING → PROCESSING → COMPLETED
   │
   └─► FAILED → RETRY
```

---

## 🎯 Key User Actions

### **Stakeholder Actions**
1. ✅ Post Requirement
2. ❌ View Proposals
3. ❌ Accept/Reject Proposal
4. ✅ Create Assignment
5. ✅ Track Assignment
6. ❌ Make Payment
7. ❌ Review Provider

### **Service Provider Actions**
1. ❌ Browse Requirements
2. ❌ Submit Proposal
3. ❌ Track Proposal Status
4. ❌ Accept Assignment
5. ❌ Update Milestone
6. ❌ Upload Deliverables
7. ❌ Request Payment
8. ❌ View Earnings

---

*This flow diagram represents the complete user journey for both Stakeholder and Service Provider modules.*

