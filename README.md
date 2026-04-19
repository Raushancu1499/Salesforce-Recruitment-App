# 🏢 Salesforce Recruitment Management App

> A full-featured **end-to-end Recruitment Management System** built natively on Salesforce, enabling HR teams to manage job positions, candidate applications, interview scheduling, and automated candidate communications — all within the Salesforce Lightning Experience.

---

## 📌 Table of Contents

1. [Project Overview](#-project-overview)
2. [Why We Built This on Salesforce](#-why-we-built-this-on-salesforce)
3. [Tech Stack](#-tech-stack)
4. [Project Architecture](#-project-architecture)
5. [Custom Objects (Data Model)](#-custom-objects-data-model)
6. [Components Built](#-components-built)
   - [Apex Batch Class](#1-apex-batch-class--interviewreminderbatch)
   - [Apex Scheduler](#2-apex-scheduler--interviewreminderscheduler)
   - [LWC Components](#3-lightning-web-components-lwc)
   - [Visualforce Pages](#4-visualforce-vf-pages)
   - [Apex Triggers](#5-apex-triggers)
   - [Salesforce Flows](#6-salesforce-flows-automation)
7. [Deployment](#-deployment)
8. [How to Run / Schedule the Batch](#-how-to-run--schedule-the-batch)
9. [Interview Q&A — How to Explain This Project](#-interview-qa--how-to-explain-this-project)
10. [Key Design Decisions](#-key-design-decisions)

---

## 📖 Project Overview

The **Salesforce Recruitment Management App** is a CRM-based HR automation platform built entirely within the **Salesforce ecosystem**. It allows an organization's HR department to:

- 📋 **Post and manage Job Positions** with details like Functional Area, Salary Range, and Status
- 👤 **Track Candidates** and their associated Contact records (including email)
- 📝 **Manage Job Applications** — linking candidates to positions and tracking status at every stage
- 📊 **View real-time dashboards** of application statistics (Total, Applied, Interview, Rejected)
- 📧 **Auto-send emails** to candidates when their application status changes to "Rejected" or "Interview"
- ⏰ **Schedule daily batch jobs** to send interview reminder emails to candidates with upcoming interviews
- 🔒 **Enforce data integrity** through triggers that prevent duplicate applications, validate review data, and auto-close positions
- 📑 **Generate tabular reports** for Job Applications and Positions via Visualforce pages

---

## 🤔 Why We Built This on Salesforce

| Reason | Explanation |
|--------|-------------|
| **No Infrastructure Overhead** | Salesforce is a PaaS (Platform as a Service). No servers, no databases to manage — everything is hosted, secured, and scaled by Salesforce. |
| **Built-in CRM Data** | Candidates are stored as Contacts — a standard Salesforce object. This means the recruitment data integrates natively with existing sales/contact data. |
| **Declarative + Programmatic** | Salesforce allows both point-and-click automation (Flows) and code-based logic (Apex, LWC) — the best of both worlds. |
| **Email Infrastructure** | Salesforce has a built-in email engine. No need for Nodemailer, SendGrid, or SMTP configuration. |
| **Role-Based Security** | Permission sets, profiles, and sharing rules provide granular access control out of the box. |
| **Rapid Development** | Custom objects, fields, and pages can be set up in hours instead of days. |
| **Enterprise-Grade** | Salesforce is used by Fortune 500 companies. Building on it means the app is production-ready and scalable. |

---

## 🛠️ Tech Stack

| Technology | Category | Purpose in This Project |
|------------|----------|------------------------|
| **Salesforce Platform (Lightning)** | PaaS / Cloud CRM | Hosts all data, logic, UI, and automation |
| **Apex** | Server-side Language (Java-like) | Business logic, batch processing, trigger handlers, email sending |
| **Lightning Web Components (LWC)** | Frontend UI Framework | Modern, reactive UI components for dashboards and lists |
| **Visualforce (VF)** | Legacy UI Framework | Tabular report pages with server-side rendering in Salesforce Classic style |
| **Salesforce Flows** | Declarative Automation | No-code / low-code email automation triggered by record changes |
| **SOQL** | Query Language | Querying Salesforce objects (like SQL for Salesforce) |
| **SFDX / Salesforce CLI** | DevOps Tooling | Source-driven development, version control, and deployment |
| **XML (Metadata API)** | Configuration | Defines all component metadata (API versions, labels, access settings) |
| **JSON** | Configuration | `sfdx-project.json` for project source path and API version settings |

---

## 🏗️ Project Architecture

```
RecruitmentApp/
├── force-app/main/default/
│   ├── classes/              # Apex business logic
│   │   ├── InterviewReminderBatch.cls      (NEW - Batch email reminders)
│   │   ├── InterviewReminderScheduler.cls  (NEW - Daily 8AM scheduler)
│   │   ├── JobApplicationController.cls   (NEW - LWC data provider)
│   │   ├── PositionController.cls         (NEW - LWC data provider)
│   │   ├── DashboardController.cls        (EXISTING - Stats for dashboard)
│   │   ├── AutoRejectBatch.cls            (EXISTING - Auto-reject old apps)
│   │   └── AutoRejectScheduler.cls        (EXISTING)
│   │
│   ├── lwc/                  # Lightning Web Components
│   │   ├── jobApplicationList/   (NEW - Application list with filters)
│   │   ├── positionList/         (NEW - Position cards with status)
│   │   └── jobDashboard/         (EXISTING/FIXED - Stats dashboard)
│   │
│   ├── pages/                # Visualforce Pages (Reports)
│   │   ├── JobApplicationReport.page  (NEW)
│   │   └── PositionReport.page        (NEW)
│   │
│   ├── triggers/             # Apex Triggers (data integrity)
│   │   ├── JobApplicationDuplicateTrigger.trigger  (NEW)
│   │   ├── ReviewTrigger.trigger                   (NEW)
│   │   ├── CompanyTrigger.trigger                  (NEW)
│   │   ├── JobApplicationStatusTrigger.trigger     (EXISTING)
│   │   ├── JobApplicationTrigger.trigger           (EXISTING)
│   │   └── PositionTrigger.trigger                 (EXISTING)
│   │
│   ├── flows/                # Salesforce Automation Flows
│   │   ├── Auto_Rejection_Email.flow-meta.xml         (FIXED)
│   │   ├── Notify_Candidate_On_Interview.flow-meta.xml (FIXED)
│   │   └── Notify_Hiring_Manager_On_Applied.flow-meta.xml (EXISTING)
│   │
│   └── objects/              # Custom Object Definitions
│       ├── Job_Application__c/
│       ├── Position__c/
│       ├── Company__c/
│       ├── Review__c/
│       └── Employment_Website__c/
│
├── sfdx-project.json         # Project configuration
└── README.md                 # This file
```

---

## 📦 Custom Objects (Data Model)

| Object | Purpose | Key Fields |
|--------|---------|------------|
| `Position__c` | A job opening posted by the company | `Position_Status__c`, `Functional_Area__c`, `Min_Pay__c`, `Max_Pay__c` |
| `Job_Application__c` | Links a candidate to a position | `Status__c`, `Candidate__c` (lookup to Contact), `Position__c`, `Application_Date__c` |
| `Company__c` | Hiring company details | `Name` |
| `Review__c` | Interviewer feedback on a candidate | `Rating__c` (1–5), `Feedback__c` |
| `Employment_Website__c` | Job board/portal details | Standard fields |
| `Contact` *(Standard)* | Represents the candidate | `Email`, `Name` — used via `Candidate__c` lookup on Job_Application__c |

**Relationship Diagram:**
```
Contact (Candidate)
    └── Job_Application__c  ──→  Position__c
                └── Review__c
```

---

## 🧩 Components Built

### 1. Apex Batch Class — `InterviewReminderBatch`

**File:** `classes/InterviewReminderBatch.cls`

**What it does:**
Queries all Job Applications with status `"Schedule Interview"` and sends a personalized email reminder to each candidate.

**Why Apex Batch?**
Salesforce has a governor limit of **10,000 rows per transaction**. A Batch class splits large datasets into chunks (default 200 per chunk), processes each chunk independently, and avoids hitting limits. This is the correct pattern whenever you need to process **many records with DML or email operations**.

**How it works:**
```
start()   → SOQL: SELECT all Job Applications WHERE Status = 'Schedule Interview'
execute() → Loop each record → Build SingleEmailMessage → Send via Messaging.sendEmail()
finish()  → Log completion via System.debug()
```

**When to use Batch:**
Use `Database.Batchable` when: (1) processing more than 10,000 records, (2) sending bulk emails, (3) running heavy data transformations overnight.

---

### 2. Apex Scheduler — `InterviewReminderScheduler`

**File:** `classes/InterviewReminderScheduler.cls`

**What it does:**
Implements `Schedulable` interface to automatically run `InterviewReminderBatch` every day at 8:00 AM.

**Why a Scheduler?**
Batch jobs don't run themselves. The Scheduler is the "alarm clock" that triggers the batch at a specified cron time. This enables fully automated, hands-free daily reminder emails.

**How to schedule it:**
```apex
// Run in Developer Console → Execute Anonymous
System.schedule('Daily Interview Reminder', '0 0 8 * * ?', new InterviewReminderScheduler());
```

**Cron Expression:** `0 0 8 * * ?` = second 0, minute 0, hour 8, every day of month, every month, any day of week.

---

### 3. Lightning Web Components (LWC)

#### 3a. `jobApplicationList`
**File:** `lwc/jobApplicationList/`

**What it does:**
- Displays all Job Applications in a sortable table
- Shows color-coded status badges (Applied = Blue, Interview = Orange, Rejected = Red, Offered = Green)
- Summary stat cards at the top: Total, Applied, Interview, Rejected counts
- Filter by status dropdown

**Why LWC?**
Lightning Web Components is Salesforce's **modern, standards-based UI framework** (built on Web Components standard). It is faster than the older Aura framework, uses native JavaScript, and integrates with `@wire` adapters for reactive data from Apex.

**Key technical details:**
- `@wire(getApplications)` — reactively fetches data from `JobApplicationController`
- `@track` properties — reactive state for filter value
- `@AuraEnabled` Apex methods — expose server-side data safely to LWC

#### 3b. `positionList`
**File:** `lwc/positionList/`

**What it does:**
- Displays all Positions as cards with name, status badge, functional area, and salary range
- Allows toggling position status (Open ↔ Closed) directly from the card

**Why LWC for positions?**
Card-based layouts are better than tables for position browsing. LWC makes this interactive without page reloads.

#### 3c. `jobDashboard`
**File:** `lwc/jobDashboard/`

**What it does:**
Displays summary statistics (Total Applications, by Status) using data from `DashboardController.getApplicationStats()`.

**Fix applied:** The component was calling the wrong method name — corrected to match the actual Apex `@AuraEnabled` method.

---

### 4. Visualforce (VF) Pages

#### 4a. `JobApplicationReport`
**File:** `pages/JobApplicationReport.page`

**What it does:**
- Renders a server-side HTML table of all Job Applications
- Summary stat boxes at top (Total, Applied, Interview, Rejected)
- Filter by status (GET parameter based)
- Clickable Application Name links

**Why Visualforce?**
VF pages are ideal for **printable reports**, tabular data views with complex server-side filtering, and generating PDF-exportable content. They use `<apex:page>` tags and standard Salesforce controllers.

**Controller:** `JobApplicationController.cls` — exposes `getApplications()` and `getStatusFilter()` to the page.

#### 4b. `PositionReport`
**File:** `pages/PositionReport.page`

**What it does:**
- Tabular view of all Positions with Functional Area, Status badges, Min/Max Pay
- Filter by status (Open / Closed / On Hold / Filled)
- Summary: Total, Open, Closed counts

**URL to access:**
```
/apex/JobApplicationReport
/apex/PositionReport
```

---

### 5. Apex Triggers

#### 5a. `JobApplicationDuplicateTrigger` *(NEW)*
**Event:** `before insert` on `Job_Application__c`

**What it does:**
Prevents a candidate from applying to the same position twice. Uses a composite key `Position__c + Candidate__c` to check for existing records before saving.

**Why before insert?**
`before insert` fires **before** the record hits the database, allowing `addError()` to block the save entirely — no partial inserts.

#### 5b. `ReviewTrigger` *(NEW)*
**Event:** `before insert, before update` on `Review__c`

**What it does:**
- Validates `Rating__c` is between 1 and 5
- Validates `Feedback__c` is not blank

**Why triggers for validation?**
Validation Rules work for simple checks. Triggers handle **complex multi-field logic** (e.g., validating Rating AND Feedback together).

#### 5c. `CompanyTrigger` *(NEW)*
**Event:** `before insert, before update` on `Company__c`

**What it does:**
Ensures `Name` is not left blank on company records.

#### 5d. `JobApplicationStatusTrigger` *(EXISTING)*
**Event:** `after update` on `Job_Application__c`

**What it does:**
When all applications for a Position are "Rejected", it **automatically closes** the Position (`Position_Status__c = 'Closed'`). This keeps Position data in sync without manual updates.

**Key pattern:** Uses a `Map<Id, Boolean>` to track whether any active (non-rejected) application exists per position — then bulk-updates positions. **Bulkified** (handles 200+ records in one DML call).

#### 5e. Other Existing Triggers
| Trigger | Object | Purpose |
|---------|--------|---------|
| `JobApplicationTrigger` | Job_Application__c | Sets default field values on insert |
| `PositionTrigger` | Position__c | Validation on position records |

---

### 6. Salesforce Flows (Automation)

#### 6a. `Auto_Rejection_Email` *(FIXED)*
**Type:** Record-Triggered Flow (After Update)
**Trigger:** When `Job_Application__c.Status__c` changes to `"Rejected"`

**What it does:**
1. Looks up the related `Contact` (candidate) via `Candidate__c`
2. Checks if Contact has a valid email
3. Sends an automated rejection email to the candidate using `emailSimple` action
4. Sends from verified org-wide address (`raushanbca998@gmail.com` — "Recruitment Team")

**Flow path:**
```
Start (Status = Rejected) → Get Candidate [SOQL] → Has Email? [Decision] → Set Email Variable → Send Email
```

#### 6b. `Notify_Candidate_On_Interview` *(FIXED)*
**Type:** Record-Triggered Flow (After Save — Create & Update)
**Trigger:** When `Job_Application__c.Status__c` = `"Interview"`

**What it does:**
Sends a congratulatory interview notification email including the Position name to the candidate.

**Flow path:**
```
Start (Status = Interview) → Get Position → Get Candidate → Has Email? → Set Email Variable → Send Email
```

#### 6c. `Notify_Hiring_Manager_On_Applied` *(EXISTING)*
Notifies the hiring manager when a new application is submitted.

**Why Flows instead of Apex for email?**
Flows are **declarative** (no code), easier to maintain by admins, and automatically re-deployable. For simple email-on-status-change logic, Flows are preferable over writing Apex email logic.

---

## 🚀 Deployment

This project uses **Salesforce DX (SFDX) source format** and is deployed via the **Salesforce CLI**.

### Prerequisites
- [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli) installed
- Authenticated org: `sf org login web --alias RecruitmentOrg`

### Deploy Full Project
```bash
sf project deploy start --source-dir force-app --target-org RecruitmentOrg --ignore-conflicts
```

### Deploy Only Flows
```bash
sf project deploy start --source-dir force-app/main/default/flows --target-org RecruitmentOrg
```

### Deploy Only Apex Classes
```bash
sf project deploy start --source-dir force-app/main/default/classes --target-org RecruitmentOrg
```

### Check Org Connection
```bash
sf org list
```

> **Note:** Enable *"Allow deployments of Apex classes and triggers even if there are active Apex jobs"* in Setup → Deployment Settings before deploying if you have scheduled jobs running.

---

## ⏰ How to Run / Schedule the Batch

Open **Developer Console** → **Debug** → **Open Execute Anonymous Window** and run:

```apex
// Run batch immediately (one-time)
Database.executeBatch(new InterviewReminderBatch(), 200);

// Schedule batch to run every day at 8:00 AM
System.schedule('Daily Interview Reminder', '0 0 8 * * ?', new InterviewReminderScheduler());
```

---

## 🎤 Interview Q&A — How to Explain This Project

### Q1: "Tell me about this project."

**Answer:**
> "I built a Recruitment Management Application entirely on the Salesforce platform. The app allows HR teams to manage the full recruitment lifecycle — from posting job positions to tracking candidate applications, scheduling interviews, and automatically communicating with candidates via email.
>
> The application has components across multiple Salesforce layers:
> - **Data layer** — Custom objects like `Position__c`, `Job_Application__c`, `Review__c`, and `Company__c`.
> - **Business logic layer** — Apex triggers for data validation and integrity, a batch class for sending bulk interview reminders, and a scheduler to automate it daily.
> - **UI layer** — Three Lightning Web Components for dashboards and lists, and two Visualforce pages for tabular reports.
> - **Automation layer** — Three Salesforce Flows that send automated emails when application status changes."

---

### Q2: "Why did you choose Salesforce instead of building a custom web app?"

**Answer:**
> "Salesforce was the right choice because it provides everything out of the box — database, authentication, email infrastructure, UI framework, and automation tools — with no server management. For an HR use case that's fundamentally about managing contacts and records, using a CRM platform is smarter than reinventing the wheel. It also means non-developers (like HR admins) can safely maintain and extend the system using declarative tools like Flows and Process Builder."

---

### Q3: "What is an Apex Batch class and why did you use it?"

**Answer:**
> "An Apex Batch class is used when you need to process a large number of records that would otherwise exceed Salesforce's governor limits. For example, if you have 50,000 applications with 'Interview' status and you want to send emails to all of them, you can't do that in a single transaction — Salesforce would throw a limit exception.
>
> A Batch class processes records in configurable chunks (e.g., 200 at a time), each in its own transaction. In my project, `InterviewReminderBatch` queries all applications with 'Schedule Interview' status and sends reminder emails to each candidate. The `InterviewReminderScheduler` then triggers this batch every morning at 8 AM automatically."

---

### Q4: "What is the difference between Apex Triggers and Flows?"

**Answer:**
> "Both can respond to record changes, but they differ in approach:
> - **Triggers** are Apex code — they handle complex logic, multi-object queries, bulkification, and scenarios that require programmatic control. For example, my `JobApplicationStatusTrigger` uses a Map to check if all applications for a position are rejected, then bulk-updates the position status.
> - **Flows** are declarative (no-code/low-code) — they're built visually in the Flow Builder and are easier to maintain by admins. My `Auto_Rejection_Email` flow sends rejection emails without a single line of Apex.
>
> Best practice: Use Flows for straightforward automation, Triggers for complex business logic."

---

### Q5: "What is the difference between LWC and Visualforce?"

**Answer:**
> "Lightning Web Components (LWC) is Salesforce's modern, component-based JavaScript framework — similar to React. It's reactive, fast, and uses standard Web APIs. I used LWC for the interactive dashboards like `jobApplicationList` and `positionList` because they need real-time filtering and dynamic UI.
>
> Visualforce is older — it's server-side rendered HTML, similar to JSP or ASP.NET WebForms. I used it for the `JobApplicationReport` and `PositionReport` pages because they are essentially printable tabular reports where server-side rendering is sufficient and the Visualforce format is ideal for PDF generation or simple grid layouts."

---

### Q6: "How did you handle duplicate prevention?"

**Answer:**
> "I created the `JobApplicationDuplicateTrigger` — a `before insert` trigger on `Job_Application__c`. It collects all Position IDs and Candidate IDs from the records being inserted, then runs a SOQL query to find any existing applications with the same combination. I build a composite key (`PositionId + '_' + CandidateId`) for efficient lookup. If a duplicate is found, `addError()` is called on the record, which blocks the insert and shows an error message to the user."

---

### Q7: "What are governor limits and how did you handle them?"

**Answer:**
> "Salesforce enforces strict limits per transaction: 100 SOQL queries, 150 DML statements, 10,000 database rows, 10 MB heap size, etc. These exist because Salesforce is a multi-tenant platform — one customer's code can't monopolize shared resources.
>
> I handled governor limits by:
> 1. **Bulkifying triggers** — using `Trigger.new` (list of records), collecting IDs in Sets, running a single SOQL query outside the loop, and using Maps for lookups.
> 2. **Using Batch Apex** — for sending large volumes of emails, the batch pattern splits work into transactions of 200 records.
> 3. **Never doing SOQL inside for loops** — this is the most common mistake that causes 'Too many SOQL queries' errors."

---

### Q8: "How does the email notification system work?"

**Answer:**
> "There are two mechanisms:
> 1. **Flows** — When a Job Application's status changes to 'Rejected' or 'Interview', a record-triggered Flow fires automatically. It looks up the candidate's Contact record, checks if an email exists, and uses the built-in `emailSimple` Salesforce action to send the notification. The email is sent from a verified org-wide address to ensure deliverability.
> 2. **Batch + Scheduler** — The `InterviewReminderBatch` runs daily at 8 AM via `InterviewReminderScheduler`. It queries all applications with 'Schedule Interview' status and sends personalized reminder emails using `Messaging.SingleEmailMessage` — Salesforce's programmatic email API."

---

## 🎯 Key Design Decisions

| Decision | Why |
|----------|-----|
| Used `Contact` as Candidate (not a custom object) | Standard object — integrates with existing CRM data; the `Candidate__c` lookup on `Job_Application__c` links applications to contacts |
| `Functional_Area__c` instead of `Department__c` | Matched actual org schema; `Department__c` didn't exist on `Position__c` |
| Flows use `emailSimple` with `senderAddress` | Sending from an org-wide verified address (`Recruitment Team`) improves email deliverability vs. Salesforce's default no-reply |
| `before insert` for duplicate check | Prevents the record from being created at all — cleaner than `after insert` + delete |
| LWC for interactive UI, VF for reports | Each tool used where it's most appropriate — LWC for modern reactive UI, VF for printable tabular reports |
| Batch size = 200 | Default Salesforce batch size. Balances throughput vs. memory. Can be tuned per use case. |
| Org-Wide Email Address | Required for sending from a specific "From" address in flows; also prevents Salesforce from filtering emails as spam |

---

## 👨‍💻 Author

**Raushan Kumar**
Salesforce Developer | BCA Student
Built with Salesforce DX + VS Code + Salesforce CLI

---

## 📚 References

- [Salesforce Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Lightning Web Components Dev Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Salesforce Flow Reference](https://help.salesforce.com/s/articleView?id=sf.flow.htm)
- [Visualforce Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/)
- [SFDX CLI Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)
