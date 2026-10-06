---
title: Warranty Shield — Epics and Stories
project_name: warranty-tracker
status: final
created: 2026-10-05T16:00
updated: 2026-10-05T16:00
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
inputDocuments:
  - ../specs/spec-warranty-shield-mvp/SPEC.md
  - ../planning-artifacts/briefs/brief-warranty-tracker-2026-10-05/brief.md
  - ../specs/spec-warranty-shield-mvp/stories.yaml
---

# Warranty Shield — Epics and Stories

## Functional Requirements (from SPEC.md Capabilities)

- **FR-1:** Users can create a warranty entry with product name, purchase date, warranty duration, retailer, and price.
- **FR-2:** The system calculates the warranty expiration date automatically from purchase date + warranty duration.
- **FR-3:** Users can view all their warranties on a single dashboard screen.
- **FR-4:** The dashboard displays warranties color-coded by status: green (safe, >60 days remaining), yellow (expiring, 30–60 days), red (critical, <30 days or expired).
- **FR-5:** The dashboard sorts warranties by urgency (most urgent first).
- **FR-6:** Users receive push notifications when a warranty reaches a configurable threshold (90, 60, 30, 7 days).
- **FR-7:** Users receive email notifications when a warranty reaches a configurable threshold (90, 60, 30, 7 days).
- **FR-8:** Users can configure notification thresholds per warranty (toggle 90/60/30/7 days on or off).
- **FR-9:** Users can grant the app permission to scan their email inbox for purchase confirmation messages.
- **FR-10:** The system parses purchase confirmation emails and extracts product name, purchase date, warranty duration, and retailer.
- **FR-11:** Parsed warranty information is presented as a draft for user review, editing, and confirmation.
- **FR-12:** Users can attach PDF files (up to 10MB) and images (up to 5MB each) to any warranty entry.
- **FR-13:** Attached documents are searchable and accessible from the warranty detail view.
- **FR-14:** Users can create an account with email/password or OAuth (Google/Apple).
- **FR-15:** Users can log in from multiple devices and see all their warranties, settings, and attachments.
- **FR-16:** The system synchronizes warranty data, settings, and attachments across devices in near real-time.
- **FR-17:** Users can edit an existing warranty entry.
- **FR-18:** Users can view a warranty detail screen showing all fields, attached documents, expiration countdown, and retailer claim link.
- **FR-19:** The system displays a summary bar on the dashboard: "X active, Y expiring, Z expired."
- **FR-20:** Users can skip false-positive parsed emails during the email import flow.

## Non-Functional Requirements (from SPEC.md Constraints)

- **NFR-1:** The application is a native mobile application for iOS and Android only (no web dashboard in MVP).
- **NFR-2:** The warranty entry form must allow users to complete data entry in under 30 seconds on a mobile device.
- **NFR-3:** Push notifications must be delivered to iOS (via APNs) and Android (via FCM) within 1 minute of trigger.
- **NFR-4:** Email notifications must be delivered within 5 minutes of trigger.
- **NFR-5:** The dashboard must allow users to identify all expiring warranties in under 5 seconds.
- **NFR-6:** Cloud-synced data must be available on a different device within 60 seconds of being added or modified.
- **NFR-7:** The email parser must achieve at least 80% extraction accuracy on purchase confirmation emails from major retailers (Amazon, Best Buy, Apple, Walmart).
- **NFR-8:** The application must support iOS 15+ and Android 10+.

## Additional Requirements (from brief.md)

- **AR-1:** The application targets homeowners and renters ages 25–55 who regularly purchase electronics, appliances, and home goods with warranties.
- **NFR-9:** The application must support both push and email notification channels simultaneously.
- **NFR-10:** The application must support OAuth sign-in via Google and Apple in addition to email/password.
- **AR-2:** The dashboard must include a visual progress bar showing warranty life remaining.

## Requirements Coverage Map

| Epic | FRs Covered | NFRs Covered |
|------|------------|--------------|
| EP-1: Account & Authentication | FR-14 | NFR-8 |
| EP-2: Warranty Entry | FR-1, FR-2, FR-17 | NFR-2, NFR-8 |
| EP-3: Dashboard & Views | FR-3, FR-4, FR-5, FR-18, FR-19 | NFR-5, NFR-8 |
| EP-4: Notifications | FR-6, FR-7, FR-8 | NFR-3, NFR-4, NFR-9 |
| EP-5: Email Parsing | FR-9, FR-10, FR-11, FR-20 | NFR-7, NFR-8 |
| EP-6: Document Management | FR-12, FR-13 | NFR-8 |
| EP-7: Account & Sync | FR-15, FR-16 | NFR-6, NFR-8, NFR-10 |

## Epics List

| Epic ID | Title | Description | Stories | Sprint 1 Status |
|---------|-------|-------------|---------|----------------|
| EP-1 | Account & Authentication | User registration, login, password recovery, OAuth (Google/Apple), account management | ST-010 | Included in Sprint 1 (via EP-7) |
| EP-2 | Warranty Entry | Fast manual warranty entry form, data model, expiration calculation, edit capability | ST-001, ST-002 | ✅ ST-001, ST-002 COMPLETED |
| EP-3 | Dashboard & Views | Color-coded dashboard, warranty detail view, summary bar, progress bar | ST-005, ST-006 | Pending (Sprint 2) |
| EP-4 | Notifications | Smart expiration notification engine (push + email), notification preferences UI | ST-003, ST-004 | Pending (Sprint 2) |
| EP-5 | Email Parsing | Email permission flow, purchase confirmation parser, draft review & confirmation | ST-007, ST-008 | Pending (Sprint 3) |
| EP-6 | Document Management | File attachment (PDF/images), cloud storage, searchable access, thumbnails | ST-009 | Pending (Sprint 3) |
| EP-7 | Account & Sync | Multi-device login, real-time cloud sync, offline queue | ST-010, ST-011 | ✅ ST-011 COMPLETED |

## Stories

(See `stories.yaml` in the same spec folder — 11 stories mapped to 7 epics above.)

## Epic 1: Account & Authentication
Users can register, log in, and manage their account from any device with secure authentication.

### Story 1.1: User Registration
As a new user, I want to create an account with my email and password (or via Google/Apple sign-in), so that I can start using Warranty Shield to track my warranties.

**Acceptance Criteria:**

**Given** I am on the registration screen, **When** I enter a valid email address and password (minimum 8 characters, at least one number and one letter), **Then** my account is created and I am taken to the dashboard.

**Given** I am on the registration screen, **When** I tap "Sign in with Google" and complete Google's OAuth flow, **Then** my account is created (or linked if one already exists) and I am taken to the dashboard.

**Given** I am on the registration screen, **When** I tap "Sign in with Apple" and complete Apple's Sign-In flow, **Then** my account is created (or linked if one already exists) and I am taken to the dashboard.

**Given** I entered an email that is already registered, **When** I attempt to register, **Then** I see an error message: "An account with this email already exists. Please log in."

**Given** I entered a weak password (fewer than 8 characters, or missing number/letter), **When** I attempt to register, **Then** I see inline validation errors next to each field.

**FRs:** FR-14 | **NFRs:** NFR-8, NFR-10

### Story 1.2: User Login
As a returning user, I want to log in securely with my email and password (or OAuth), so that I can access my warranty data.

**Acceptance Criteria:**

**Given** I am on the login screen, **When** I enter my registered email and correct password, **Then** I am authenticated and taken to the dashboard.

**Given** I am on the login screen, **When** I enter an incorrect password, **Then** I see the message: "Invalid email or password" (no distinction between email/password errors for security).

**Given** I am on the login screen, **When** I enter 5 consecutive incorrect password attempts, **Then** my account is temporarily locked for 15 minutes with a countdown timer displayed.

**Given** I am a registered user, **When** I tap "Sign in with Google" or "Sign in with Apple," **Then** I am authenticated via OAuth and taken to the dashboard.

**Given** I am logged in, **When** I close the app and reopen it, **Then** I am automatically logged in (session persists) unless I explicitly log out.

**FRs:** FR-14 | **NFRs:** NFR-8, NFR-10

### Story 1.3: Password Recovery
As a user who forgot my password, I want to reset it via a magic link sent to my email, so that I can regain access to my account without support.

**Acceptance Criteria:**

**Given** I am on the login screen and tap "Forgot Password," **When** I enter my registered email address, **Then** a password reset email is sent within 30 seconds with a time-limited (24-hour) magic link.

**Given** I clicked the password reset magic link, **When** I am taken to a reset screen, **Then** I can enter a new password (same validation rules as registration).

**Given** I entered a valid new password, **When** I tap "Reset Password," **Then** my password is updated, I am logged in, and I am taken to the dashboard.

**Given** the magic link has expired (24+ hours), **When** I tap the link, **Then** I see: "This link has expired. Please request a new one."

**Given** I entered an email that is not registered, **When** I request password recovery, **Then** I see: "If an account exists with that email, a reset link has been sent." (No enumeration of registered emails.)

**FRs:** FR-14 | **NFRs:** N/A (covered under NFR-8)

---

## Epic 2: Warranty Entry
Users can quickly add, edit, and manage warranty entries with automatic expiration calculation.

### Story 2.1: Manual Warranty Entry Form ✅ (COMPLETED - Sprint 1)
As a user, I want to create a warranty entry through a fast, mobile-optimized form, so that I can capture warranty information in under 30 seconds.

**Acceptance Criteria:**

**Given** I am on the dashboard and tap "Add Warranty," **When** the entry form appears, **Then** I see 5 fields: Product Name (text), Purchase Date (date picker), Warranty Duration (dropdown: 6 months, 1 year, 2 years, 3 years, 5 years, custom), Retailer (text with autocomplete from past entries), and Price (currency input).

**Given** I am on the entry form, **When** I fill in all 5 fields and tap "Save," **Then** the warranty is created, I see a success confirmation, and I am returned to the dashboard where the new warranty appears.

**Given** I am on the entry form, **When** I leave the Product Name field empty, **Then** I see: "Product name is required."

**Given** I am on the entry form, **When** I select a custom warranty duration, **Then** a text field appears allowing me to enter a custom number of months.

**Given** I am on a mobile device, **When** I complete a warranty entry, **Then** the entire flow (from form open to save confirmation) takes under 30 seconds on a real device.

**FRs:** FR-1, FR-2 | **NFRs:** NFR-2, NFR-8
**Status:** ✅ COMPLETED (2026-10-05)
**Sprint:** Sprint 1
**Implementation Notes:** Flutter form with Riverpod state, Hive local persistence, Dio API client, validation with error messages, keyboard-optimized for mobile.

### Story 2.2: Warranty Data Model & Expiration Calculation ✅ (COMPLETED - Sprint 1)
As a user, I want the system to automatically calculate my warranty expiration date, so that I always know when coverage ends without manual math.

**Acceptance Criteria:**

**Given** I created a warranty with purchase date 2026-01-15 and 24-month duration, **When** the system saves the entry, **Then** the expiration date is automatically calculated and stored as 2028-01-15.

**Given** I created a warranty with a custom 18-month duration, **When** the system saves the entry, **Then** the expiration date is correctly calculated (purchase date + 18 months).

**Given** I created a warranty with a leap-year purchase date (2024-02-29) and 12-month duration, **When** the system calculates the expiration, **Then** it is 2025-02-28 (correct handling of leap years).

**Given** a warranty exists in the database, **When** I query by retailer, expiration date range, or product name, **Then** the correct warranties are returned.

**Given** I edited a warranty's purchase date, **When** I save the change, **Then** the expiration date is recalculated automatically.

**FRs:** FR-2 | **NFRs:** N/A (covered under NFR-8)
**Status:** ✅ COMPLETED (2026-10-05)
**Sprint:** Sprint 1
**Implementation Notes:** Spring Boot REST API with PostgreSQL, JPA entities, automatic expiration calculation on persist, CRUD endpoints, query methods for retailer/expiration/product.

### Story 2.3: Edit Existing Warranty
As a user, I want to edit an existing warranty entry, so that I can correct information or update details (e.g., if I forgot to add a receipt attachment).

**Acceptance Criteria:**

**Given** I am viewing a warranty on the dashboard, **When** I tap the warranty to open its detail view, **Then** I see an "Edit" button.

**Given** I am on the edit screen, **When** I modify any field (product name, purchase date, duration, retailer, price), **Then** the expiration date is recalculated and all changes are saved when I tap "Save."

**Given** I am on the edit screen, **When** I tap "Cancel," **Then** my changes are discarded and I am returned to the detail view without modifications.

**Given** I edited a warranty, **When** I return to the dashboard, **Then** the warranty reflects the updated information and the expiration date is correct.

**FRs:** FR-17 | **NFRs:** N/A (covered under NFR-8)

---

## Epic 3: Dashboard & Views
Users can see all warranties at a glance, color-coded by urgency, with detailed views.

### Story 3.1: Color-Coded Warranty Dashboard
As a user, I want to see all my warranties on a single screen, organized by urgency with color coding, so that I can immediately identify which warranties need attention.

**Acceptance Criteria:**

**Given** I am logged in and viewing the dashboard, **When** my warranties load, **Then** each warranty card displays: product name, retailer, expiration date, and a colored status indicator.

**Given** a warranty has more than 60 days remaining, **When** I view the dashboard, **Then** the warranty card shows a green status indicator (color #4CAF50).

**Given** a warranty has 30–60 days remaining, **When** I view the dashboard, **Then** the warranty card shows a yellow status indicator (color #FFC107).

**Given** a warranty has fewer than 30 days remaining or is expired, **When** I view the dashboard, **Then** the warranty card shows a red status indicator (color #F44336).

**Given** I have 3 green, 2 yellow, and 1 red warranty, **When** the dashboard displays, **Then** warranties are sorted by urgency (red first, then yellow, then green) and a summary bar at the top reads: "3 Active, 2 Expiring, 1 Critical."

**Given** I have no warranties, **When** I view the dashboard, **Then** I see an empty state: "No warranties yet. Tap + to add your first warranty."

**FRs:** FR-3, FR-4, FR-5, FR-19 | **NFRs:** NFR-5, NFR-8

### Story 3.2: Warranty Detail View
As a user, I want to view detailed information about a single warranty, so that I can see all its fields, attached documents, and expiration countdown.

**Acceptance Criteria:**

**Given** I am on the dashboard and tap a warranty card, **When** the detail view opens, **Then** I see: product name, retailer, purchase date, warranty duration, expiration date, price, and a visual progress bar showing warranty life remaining.

**Given** I am on the detail view, **When** I scroll down, **Then** I see: an "Attachments" section (if any exist), an "Expiration Countdown" (e.g., "14 days remaining"), and a "Retailer Claim Info" button that opens the retailer's warranty claim page in an external browser.

**Given** I am on the detail view, **When** I tap "Edit," **Then** I am taken to the edit screen (Story 2.3).

**Given** I am on the detail view, **When** I tap "Delete," **Then** I see a confirmation dialog: "Delete this warranty? This action cannot be undone."

**Given** a warranty is expired, **When** I view the detail, **Then** the expiration countdown shows: "EXPIRED — [X] days ago" in red text.

**FRs:** FR-18 | **NFRs:** N/A (covered under NFR-8)

---

## Epic 4: Notifications
Users receive proactive push and email alerts when warranties are about to expire, with configurable thresholds.

### Story 4.1: Smart Expiration Notification Engine
As a user, I want the system to send push and email notifications when my warranties approach expiration, so that I can take action before coverage ends.

**Acceptance Criteria:**

**Given** a warranty has 30 days remaining, **When** the daily notification scheduler runs, **Then** a push notification is sent to the user's device within 60 seconds, and an email notification is sent within 5 minutes.

**Given** the push notification is delivered, **When** I view it, **Then** it contains: product name, expiration date, and a deep link that opens the warranty's detail view in the app.

**Given** the email notification is delivered, **When** I open it, **Then** it contains: product name, expiration date, a summary of coverage remaining, and a button: "View Warranty" that deep-links to the app.

**Given** a warranty reaches 90, 60, 30, and 7-day thresholds, **When** the scheduler runs, **Then** notifications are sent at each threshold (unless the user has disabled that threshold — see Story 4.2).

**Given** push notification service (APNs for iOS, FCM for Android) is unavailable, **When** the scheduler attempts to send, **Then** the notification is queued and retried for up to 1 hour, with a fallback to email.

**FRs:** FR-6, FR-7 | **NFRs:** NFR-3, NFR-4

### Story 4.2: Notification Preferences UI
As a user, I want to choose which notification thresholds I receive for each warranty, so that I am not overwhelmed by alerts for long-duration warranties.

**Acceptance Criteria:**

**Given** I am on a warranty's detail view, **When** I tap "Notification Settings," **Then** I see 4 toggle switches: 90 Days, 60 Days, 30 Days, 7 Days — all enabled by default.

**Given** I toggle off the 90-day and 60-day thresholds, **When** I save, **Then** no notifications are sent at those thresholds for this warranty.

**Given** I have toggled off all thresholds, **When** I view the settings, **Then** a message reads: "Notifications are disabled for this warranty. Enable at least one threshold to receive alerts."

**Given** I change notification preferences, **When** I return to the dashboard, **Then** the change is saved immediately and reflected in the next scheduler run.

**Given** I am viewing the global notification settings (app settings), **When** I toggle a threshold off globally, **Then** it applies to all warranties that do not have per-warranty overrides.

**FRs:** FR-8 | **NFRs:** N/A (covered under NFR-9)

---

## Epic 5: Email Parsing
Users can grant email access and auto-import warranty information from purchase confirmations.

### Story 5.1: Email Permission & Access Grant
As a user, I want to grant the app permission to scan my inbox for purchase confirmation emails, so that I can auto-capture warranty information without manual entry.

**Acceptance Criteria:**

**Given** I am on the dashboard and tap "Import from Email," **When** a permission dialog appears, **Then** I see: "Warranty Shield would like to scan your inbox for purchase confirmations. We only read emails containing keywords like 'order confirmation,' 'receipt,' or 'warranty.' Your email content is never stored."

**Given** I tap "Allow," **When** the app scans my inbox, **Then** it searches for emails from the configured retailers (Amazon, Best Buy, Apple, Walmart) containing purchase confirmation patterns.

**Given** I tap "Deny," **When** the app returns to the dashboard, **Then** I see a message: "You can grant email access anytime in Settings > Email Import."

**Given** I previously granted access, **When** I revoke permission in my device's email settings, **Then** the app shows: "Email access was revoked. Grant access in Settings to re-enable."

**FRs:** FR-9 | **NFRs:** N/A (covered under NFR-8)

### Story 5.2: Purchase Confirmation Email Parser
As a user, I want the app to automatically extract warranty-relevant information from my purchase confirmation emails, so that I can import warranties without typing.

**Acceptance Criteria:**

**Given** I granted email access, **When** the parser scans my inbox, **Then** it identifies purchase confirmation emails from Amazon, Best Buy, Apple, and Walmart using regex-based pattern matching.

**Given** the parser finds a purchase confirmation email, **When** it processes the email, **Then** it extracts: product name, purchase date, warranty duration (if stated), and retailer name.

**Given** the parser processes 20 sample purchase confirmation emails (5 per retailer), **When** it extracts information, **Then** it achieves at least 80% accuracy (correctly extracts product name, purchase date, and warranty duration in at least 16 of 20 cases).

**Given** the parser encounters an email it cannot parse, **When** it processes the email, **Then** it shows the raw email content in a "Manual Review" section, allowing me to extract the information manually.

**Given** the parser finds duplicate purchase confirmation emails (same order number), **When** it processes them, **Then** it shows only the first (or most complete) version and skips the duplicates.

**FRs:** FR-10 | **NFRs:** NFR-7, NFR-8

### Story 5.3: Draft Review & Confirmation Flow
As a user, I want to review parsed warranty drafts before they are saved, so that I can correct any extraction errors or skip false positives.

**Acceptance Criteria:**

**Given** the parser has scanned my inbox, **When** I view the results, **Then** I see a list of parsed warranty drafts, each showing: product name, purchase date, warranty duration (if found), and the source email subject line.

**Given** I am viewing parsed drafts, **When** I tap a draft, **Then** I see all extracted fields with the ability to edit any field (product name, purchase date, duration, retailer, price).

**Given** I am reviewing drafts, **When** I tap "Import All," **Then** all drafts are saved to my warranty list and I am returned to the dashboard.

**Given** I am reviewing drafts, **When** I tap "Import Selected," **Then** only the checked drafts are saved; unchecked drafts are discarded.

**Given** I am reviewing drafts, **When** I tap "Skip" on a specific draft, **Then** that draft is removed from the import list (and the source email is marked as "not a warranty" so it is not re-parsed).

**Given** I am reviewing drafts, **When** I find no valid warranties, **Then** I see: "No warranties found in your inbox. You can still add warranties manually."

**FRs:** FR-11, FR-20 | **NFRs:** N/A (covered under NFR-8)

---

## Epic 6: Document Management
Users can attach and retrieve receipts, warranty cards, and manuals with their warranties.

### Story 6.1: Document Attachment System
As a user, I want to attach files to my warranty entries, so that I have all my warranty documentation in one place.

**Acceptance Criteria:**

**Given** I am on a warranty's detail view, **When** I tap "Attach Document," **Then** I see options to: "Upload PDF" or "Take Photo."

**Given** I select "Upload PDF," **When** I choose a file, **Then** if the file is under 10MB, it is uploaded and appears in the attachments list.

**Given** I select "Take Photo," **When** I capture or select an image, **Then** if the file is under 5MB, it is uploaded and appears in the attachments list with a thumbnail.

**Given** I attempt to upload a PDF over 10MB, **When** I tap "Upload," **Then** I see: "File too large. Maximum size is 10MB."

**Given** I attempt to upload a non-PDF or non-image file (e.g., .doc, .exe), **When** I tap "Upload," **Then** I see: "Unsupported file type. Please upload a PDF or image."

**Given** I attached 3 documents to a warranty, **When** I view the detail view, **Then** I see all 3 listed with thumbnails (images) or file icons (PDFs), and each is tappable to view/download.

**Given** I tap a PDF attachment, **When** it opens, **Then** a PDF viewer renders the document within the app.

**Given** I tap an image attachment, **When** it opens, **Then** a full-screen image viewer renders the image with pinch-to-zoom.

**FRs:** FR-12, FR-13 | **NFRs:** N/A (covered under NFR-8)

---

## Epic 7: Account & Cloud Sync
Users have seamless access to all their data across devices with real-time synchronization.

### Story 7.1: Multi-Device Access ✅ (COMPLETED - Sprint 1)
As a user, I want to log in from any device and see all my warranties, settings, and attachments, so that I can switch devices without losing data.

**Acceptance Criteria:**

**Given** I created an account on Device A and added 5 warranties with attachments, **When** I log out on Device A and log in on Device B, **Then** all 5 warranties, all attachments, and all notification preferences are available within 60 seconds of login.

**Given** I am logged in on Device A, **When** I log in on Device B, **Then** both sessions remain active (no forced logout on the original device).

**Given** I am logged in, **When** I tap "Log Out," **Then** my session is terminated on this device, but my data remains in the cloud for future logins.

**FRs:** FR-7 | **NFRs:** NFR-1, NFR-4, NFR-5
**Status:** ✅ COMPLETED (2026-10-05)
**Sprint:** Sprint 1
**Implementation Notes:** Spring Boot REST API with JWT authentication, Firebase Auth (email/password + Google OAuth), session management with token refresh, multi-device support with concurrent sessions.

**Given** I am on a device with no internet connection, **When** I open the app, **Then** I see: "No internet connection. Your last synced data is available offline." (If offline access is implemented in Phase 2, this message changes.)

**FRs:** FR-15 | **NFRs:** NFR-6, NFR-8, NFR-10

### Story 7.2: Real-Time Cloud Synchronization
As a user, I want my warranty data, settings, and attachments to sync across devices in near real-time, so that changes I make on one device are immediately available on others.

**Acceptance Criteria:**

**Given** I added a warranty on Device A, **When** I open Device B, **Then** the new warranty appears in the dashboard within 60 seconds without manual refresh.

**Given** I edited a warranty on Device A, **When** I view Device B, **Then** the updated information appears within 60 seconds.

**Given** I attached a document to a warranty on Device A, **When** I view Device B, **Then** the attachment appears within 60 seconds and is downloadable.

**Given** I edited the same warranty simultaneously on Device A and Device B, **When** both changes are saved, **Then** the last-write-wins conflict resolution applies: the most recent edit is preserved, and the other device is notified of the conflict with a banner: "Your changes were overwritten by a recent edit on another device. View updated version."

**Given** my device loses internet connectivity, **When** I make changes, **Then** the changes are queued locally and synced automatically when connectivity is restored.

**Given** my device is offline for more than 24 hours, **When** connectivity is restored, **Then** all queued changes are synced, and any conflicts are resolved using last-write-wins with a conflict notification.

**FRs:** FR-16 | **NFRs:** NFR-6


## Architecture Mapping

Each epic maps to the Architecture Decisions (ADs) from `../../architecture/ARCHITECTURE-SPINE.md` that govern its implementation:

| Epic | Maps To ADs | Rationale |
|------|-------------|-----------|
| Epic 1: Account & Authentication | AD-5 (Hybrid Auth), AD-6 (Firebase override) | User registration, login, OAuth via Firebase, session management via Java backend |
| Epic 2: Warranty Entry | AD-1 (Riverpod state), AD-2 (Hive persistence), AD-4 (Spring Boot REST) | Fast data entry form, validation, save to backend |
| Epic 3: Dashboard & Views | AD-1 (Riverpod state), AD-4 (Spring Boot REST) | Color-coded dashboard, urgency sorting, summary bar |
| Epic 4: Notifications | AD-8 (Push infra), AD-4 (Spring Boot REST) | Java backend manages device tokens, sends pushes, email service |
| Epic 5: Email Import | AD-9 (Client-side parsing) | Flutter parses emails locally, sends structured data to backend |
| Epic 6: Document Management | AD-7 (Firebase Storage), AD-4 (Spring Boot REST) | Direct Flutter-to-Firebase uploads, backend stores metadata only |
| Epic 7: Account & Cloud Sync | AD-10 (Push-triggered sync), AD-11 (LWW conflict), AD-12 (Offline queue) | Java backend push → Flutter fetch, last-write-wins, Hive offline queue |

## Cross-Cutting Concerns

| Concern | Maps To ADs | Notes |
|---------|-------------|-------|
| Offline-first design | AD-2, AD-12 | Hive local persistence + offline queue strategy |
| Multi-device consistency | AD-10, AD-11 | Push-triggered sync + last-write-wins |
| Privacy (email parsing) | AD-9 | Raw emails never leave the device |
| Security (auth) | AD-5, AD-6 | Hybrid auth with JWT session tokens |
| Performance (30s entry, 1min push) | AD-4, AD-8 | Spring Boot REST + Java backend push service |





