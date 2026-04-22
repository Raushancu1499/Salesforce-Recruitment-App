# 🏢 Salesforce Recruitment Management App

> A full-featured **end-to-end Recruitment Management System** built natively on Salesforce, enabling HR teams to manage job positions, candidate applications, interview scheduling, and automated candidate communications — all within the Salesforce Lightning Experience.

---

## 📌 Table of Contents

1. [Project Overview](#-project-overview)
2. [Why We Built This on Salesforce](#-why-we-built-this-on-salesforce)
3. [Tech Stack](#-tech-stack)
4. [Custom Objects (Data Model)](#-custom-objects-data-model)
5. [🎓 Admin & Development — Why, How, When (Viva Guide)](#-admin--development--why-how-when-viva-guide)
6. [🎤 Expanded Viva Questions](#-expanded-viva-questions)
7. [🚀 Deployment](#-deployment)
8. [Author](#-author)

---

## 📖 1. Project Overview

The **Salesforce Recruitment Management App** is a CRM-based HR automation platform built entirely within the **Salesforce ecosystem**. It allows an organization's HR department to:

- 📋 **Post and manage Job Positions** with details like Functional Area, Salary Range, and Status
- 🏢 **Manage Hiring Companies** and track external **Employment Websites**
- 👤 **Track Candidates** and their associated Contact records (including email)
- 📝 **Manage Job Applications** — linking candidates to positions and tracking status at every stage
- 📧 **Auto-send emails** to candidates when their application status changes
- ⏰ **Schedule daily batch jobs** to send interview reminder emails
- 🔒 **Enforce data security** through Permission Sets and sharing rules
- 📑 **Generate tabular reports** via Visualforce pages

---

## ☁️ 2. Why We Built This on Salesforce

Salesforce was chosen for this project because it provides a robust, scalable out-of-the-box infrastructure. Instead of building a database, authentication system, and UI from scratch, Salesforce allows us to focus entirely on **business logic**. With its powerful declarative tools (Flows, Validation Rules) and programmatic capabilities (Apex, LWC), we can rapidly develop a highly secure and automated recruitment platform.

---

## 🛠️ 3. Tech Stack

- **Platform:** Salesforce Lightning Experience
- **Declarative Tools:** Object Manager, Screen Flows, Record-Triggered Flows, Page Layouts, Global Actions
- **Backend (Programmatic):** Apex (Triggers, Batchable, Schedulable)
- **Frontend (Programmatic):** Lightning Web Components (LWC), Visualforce
- **Version Control & Deployment:** Git, Salesforce CLI (sfdx)

---

## 🏗️ 4. Custom Objects (Data Model)

Our app is built around six core Custom Objects that form the backbone of the recruitment process:

*   **Positions (`Position__c`)**: Stores job details (Functional Area, Pay Range, Status).
*   **Company (`Company__c`)**: Stores information about the hiring companies or clients.
*   **Employment Website (`Employment_Website__c`)**: Tracks external job boards where positions are posted.
*   **Candidates (Standard `Contact`)**: Captures candidate profiles and contact information.
*   **Job Applications (`Job_Application__c`)**: The junction object linking a Candidate to a specific Position.
*   **Reviews (`Review__c`)**: Used for interview feedback (Master-Detail relationship with Applications).

---

## 🎓 5. Admin & Development — Why, How, When (Viva Guide)

### 🏛️ Admin Topics

| Requirement | Why (Rationale) | How (Implementation) | When (Trigger/Usage) |
|-------------|---------------|-------------------|-------------------|
| **Objects** | To store recruitment-specific data like Positions and Applications. | Created Custom Objects `Position__c`, `Job_Application__c`, etc. | Throughout the app lifecycle. |
| **Fields** | To capture specific details like salary, status, and dates. | Added Picklist, Currency, Date, and Formula fields. | On record creation/viewing. |
| **Relationships** | To link candidates to positions and reviews to applications. | Used **Lookup** (Position -> Company) and **Master-Detail** (Review -> Application). | When linking records together. |
| **Tabs & Apps**| To make objects easily accessible in a unified workspace. | Created Custom Tabs and grouped them into the "Recruitment App". | Daily navigation by users. |
| **Field Dependencies**| To ensure data quality by filtering picklist values. | `Functional_Area__c` (Control) -> `Sub_Area__c` (Dependent). | During record entry/edit. |
| **Validation Rules** | To prevent invalid data (e.g., Min Pay > Max Pay). | Wrote logic: `Min_Pay__c > Max_Pay__c`. | Immediately on record Save. |
| **Page Layouts** | To organize fields and sections for a better user experience. | Designed layouts in Object Manager with grouped sections. | When viewing/editing records. |
| **Record Types** | To handle different processes (e.g., IT vs Non-IT roles). | Created Record Types with distinct layouts and picklist values. | When creating a New Position. |
| **Global Actions** | To provide a quick way to create positions from anywhere. | Created "New Position" Global Action added to Publisher Layout. | Quick data entry from global header. |
| **Data Security** | To control access based on user roles (Recruitment Manager). | Created a **Permission Set** for HR management access. | When users log in to the system. |
| **Flows (Screen)** | To guide users through complex data entry steps. | Built `Job_Inquiry_Screen_Flow` with input screens. | Launched via buttons or pages. |
| **Flows (Record-Trigger)**| To automate backend tasks like sending emails. | `Auto_Rejection_Email` fires on status change. | Automatically on record Save. |
| **Reports & Dashboards**| To visualize recruitment progress and KPIs. | Created Reports grouped by Status; displayed on Dashboard. | Monitored by HR Leadership. |

---

### 💻 Development Topics

| Requirement | Why (Rationale) | How (Implementation) | When (Trigger/Usage) |
|-------------|---------------|-------------------|-------------------|
| **Batch Class** | To process bulk emails without hitting governor limits. | Implemented `Database.Batchable` in `InterviewReminderBatch`. | Large-scale background tasks. |
| **Schedule Class** | To automate the daily execution of batch jobs. | Implemented `Schedulable` to call the batch job. | Every morning at 8:00 AM. |
| **LWC Components** | To provide a modern, fast, and reactive user interface. | Built `jobApplicationList` and `positionList` (card UI) using JS/HTML. | Interactive dashboards/lists. |
| **Visualforce Pages** | Ideal for printable tabular reports and server-side logic. | Created `PositionReport.page` with standard controller. | Printable/Tabular reporting. |
| **Apex Triggers** | For complex logic like duplicate prevention and rollups. | `JobApplicationDuplicateTrigger` checks for existing records. | Fires on every DML operation. |

---

## 🎤 6. Expanded Viva Questions

### 📘 Admin Q&A
1. **Q: What is the difference between a Profile and a Permission Set?**
   - **A:** A Profile is the base level of access assigned to a user. A Permission Set is used to *grant additional* permissions to users without changing their profile.
2. **Q: Why use a Master-Detail relationship for Reviews?**
   - **A:** Because a Review should not exist without a Job Application. M-D ensures that if the Application is deleted, the Reviews are also deleted (Cascade Delete).
3. **Q: How does a Validation Rule work?**
   - **A:** It checks a formula on save. If the formula is **True**, it blocks the save and shows the error message.
4. **Q: Where can you use a Screen Flow in this project?**
   - **A:** You can place the `Job_Inquiry_Screen_Flow` on the **Position Record Page** as a "Quick Apply" button or access it via the dedicated **Job Inquiry Tab**.

### 🚀 Development Q&A
1. **Q: What are Salesforce Governor Limits?**
   - **A:** Strict limits (e.g., 100 SOQL queries per transaction) to ensure shared resources are used fairly in a multi-tenant environment.
2. **Q: Why use Batch Apex for sending reminder emails?**
   - **A:** If we have thousands of applications, a normal transaction would fail. Batch Apex splits the work into chunks of 200, each with its own limits.
3. **Q: What is the purpose of `@wire` in LWC?**
   - **A:** It is a reactive service used to read Salesforce data. When the data changes on the server, the component automatically re-renders.
4. **Q: How do you prevent "SOQL inside a For Loop"?**
   - **A:** By **Bulkifying** code: collect IDs in a Set, perform one SOQL query outside the loop, and use a Map to process the results inside the loop.

---

## 🚀 7. Deployment

```bash
# Deploy Full Project
sf project deploy start --source-dir force-app --target-org RecruitmentOrg
```

## 👨‍💻 8. Author
**Raushan Kumar**
Salesforce Developer | Student
Built with Salesforce DX + VS Code + Salesforce CLI
