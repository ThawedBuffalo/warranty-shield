---
title: Sprint 1 - Foundation Stories
project_name: warranty-tracker
sprint_id: 2
board_id: 1
board_name: SCRUM board
status: final
created: 2026-10-05T18:45
updated: 2026-10-05T18:45
---

# Sprint 1 - Foundation Stories

## Sprint Goal
Implement the core warranty data model, manual entry form, and multi-device account access - the three foundational stories that all other features depend on.

## Scope

### In-Sprint Stories (3 Stories, 15 Sub-Tasks, 18 Story Points)

| Jira Key | Story ID | Title | Epic | Priority | Story Points | Dependencies |
|----------|----------|-------|------|----------|-------------|-------------|
| SCRUM-10011 | ST-001 | Manual Warranty Entry Form | Epic 2: Warranty Entry | P0 (Highest) | 8 | None |
| SCRUM-10012 | ST-002 | Warranty Data Model and Expiration Calculation | Epic 2: Warranty Entry | P0 (Highest) | 5 | None |
| SCRUM-10021 | ST-011 | Multi-Device Access | Epic 7: Cloud Sync | P0 (Highest) | 5 | None |

### Out-of-Scope (Deferred to Later Sprints)

| Jira Key | Story ID | Title | Epic | Target Sprint | Rationale |
|----------|----------|-------|------|--------------|-----------|
| SCRUM-10013 | ST-003 | Edit Existing Warranty | Epic 2 | Sprint 2 | Depends on Story 2.1 + 2.2 |
| SCRUM-10014 | ST-004 | Color-Coded Warranty Dashboard | Epic 3 | Sprint 2 | Depends on data model (2.2) |
| SCRUM-10015 | ST-005 | Warranty Detail View | Epic 3 | Sprint 2 | Depends on data model (2.2) |
| SCRUM-10016 | ST-006 | Smart Expiration Notification Engine | Epic 4 | Sprint 2 | Depends on data model (2.2) |
| SCRUM-10017 | ST-007 | Notification Preferences UI | Epic 4 | Sprint 3 | Depends on notification engine (4.1) |
| SCRUM-10018 | ST-008 | Email Purchase Confirmation Parser | Epic 5 | Sprint 3 | Can be parallelized |
| SCRUM-10019 | ST-009 | Email Grant and Draft Creation Flow | Epic 5 | Sprint 3 | Depends on parser (5.1) |
| SCRUM-10020 | ST-010 | Document Attachment System | Epic 6 | Sprint 3 | Can be parallelized |
| SCRUM-10022 | ST-011b | Real-Time Cloud Synchronization | Epic 7 | Sprint 2 | Depends on data model (2.2) |

## Sprint Capacity

| Metric | Value |
|--------|-------|
| Total Story Points | 18 |
| Total Sub-Tasks | 15 (5 per story) |
| Sprint Duration | 2 weeks (recommended) |
| Sprint Start | 2026-10-06 |
| Sprint End | 2026-10-19 |

## Story Dependencies

SCRUM-10011 (Manual Entry Form) --+
                                   +---> SCRUM-10014 (Dashboard)
                                   |
SCRUM-10012 (Data Model) -----------+---> SCRUM-10015 (Detail View)
                                   +---> SCRUM-10016 (Notifications)
                                   +---> SCRUM-10022 (Cloud Sync)
                                   |
SCRUM-10021 (Multi-Device Access) --+

## Sub-Task Breakdown (Sprint 1)

### SCRUM-10011 - Manual Warranty Entry Form (Sub-tasks: 10100, 10126, 10129, 10132, 10135)
1. **UI Form Layout** - Build Flutter form with 5 fields (product name, purchase date, warranty duration, retailer, price)
2. **Input Validation** - Add real-time field validation with error messages
3. **Keyboard Navigation** - Ensure mobile-optimized keyboard behavior
4. **Save/Submit Handler** - Wire form to data model save endpoint
5. **30-Second Entry Target** - Performance test: complete entry in < 30 seconds

### SCRUM-10012 - Warranty Data Model (Sub-tasks: 10102, 10104, 10106, 10108, 10110)
1. **Database Schema** - Design PostgreSQL schema for warranty entries (all 6 fields)
2. **Expiration Calculation** - Implement automatic expiration date from purchase date + duration
3. **CRUD Endpoints** - Build REST API endpoints (create, read, update, delete)
4. **Query Endpoints** - Support querying by retailer, expiration date, product name
5. **Integration Tests** - Verify expiration calculation correctness

### SCRUM-10021 - Multi-Device Access (Sub-tasks: 10257, 10264, 10270, 10278, 10286)
1. **Firebase Auth Setup** - Configure email/password + Google OAuth + Apple Sign-In
2. **Login/Logout UI** - Build authentication screens
3. **Session Management** - Implement JWT session token handling
4. **Password Recovery** - Email-based password reset flow
5. **Multi-Device Login** - Verify data availability across devices within 60 seconds

## Technical Notes

- **Frontend**: Flutter (Riverpod state management, Hive local persistence)
- **Backend**: Spring Boot REST API
- **Auth**: Firebase Auth (hybrid: email/password + OAuth)
- **Database**: PostgreSQL (relational warranty data)
- **Storage**: Firebase Storage (documents)
- **Sync**: Firebase Realtime Database (real-time sync)
- **Push**: APNs (iOS) + FCM (Android)

## Acceptance Criteria (Per Story)

### SCRUM-10011 - Manual Warranty Entry Form
- [ ] Form renders on a single screen; all 5 fields visible; save button prominent
- [ ] A test user enters a warranty for Samsung Refrigerator purchased 2026-01-15, 2-year warranty, Best Buy, 1200 and saves it in under 30 seconds on both iOS and Android devices

### SCRUM-10012 - Warranty Data Model
- [ ] Database schema supports all 6 fields; expiration date is computed automatically
- [ ] Creating a warranty with purchase date 2026-01-15 and 24-month duration correctly sets expiration date to 2028-01-15
- [ ] Query by retailer, by expiration date, or by product name returns correct results

### SCRUM-10021 - Multi-Device Access
- [ ] Users can register, log in, log out, and recover passwords; OAuth available as alternative
- [ ] User creates account with email and password; logs out; logs in on a different device; all warranties and attachments are available within 60 seconds
- [ ] OAuth sign-in via Google also works

## Cross-Story Integration

The three Sprint 1 stories form the **minimum viable platform**:
1. **SCRUM-10012** (Data Model) provides the backend API and database
2. **SCRUM-10011** (Manual Entry Form) provides the front-end data entry
3. **SCRUM-10021** (Multi-Device Access) provides the authentication layer

All three must be working together before Sprint 2 can begin (Dashboard, Notifications, etc.).

## Notes for Future Sprints

- **Sprint 2** will build on Sprint 1 foundation: Dashboard (SCRUM-10014), Detail View (SCRUM-10015), Edit (SCRUM-10013), Notifications (SCRUM-10016), and Cloud Sync (SCRUM-10022)
- **Sprint 3** will add the email import pipeline (SCRUM-10018, SCRUM-10019) and document management (SCRUM-10020)
- **Sprint 4** (if needed) will cover remaining notification preferences (SCRUM-10017) and polish
