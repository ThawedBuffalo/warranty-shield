---
id: SPEC-warranty-shield-mvp
companions:
  - ../planning-artifacts/briefs/brief-warranty-tracker-2026-10-05/brief.md
  - ../brainstorming/brainstorm-intent.md
sources: []
---

> **Canonical contract.** This SPEC and the files in `companions:` are the complete, preservation-validated contract for what to build, test, and validate. Source documents listed in frontmatter are for traceability — consult them only if you need narrative rationale or prose color this contract intentionally omits.

# SPEC: Warranty Shield MVP

## Why

People lose hundreds to thousands of dollars annually on warranties they forgot they had — refrigerators that break after the window, TVs that stop working with no claim filed, electronics with no documentation. The pain is real, recurring, and entirely preventable. Existing solutions require manual data entry, generic calendar reminders, or complex integrations that make adoption a chore. **Why now:** e-commerce has exploded warranty ownership, the secondhand market now values transferable warranties, and consumers are demanding tools that protect their purchases without the administrative burden. This spec covers the minimum viable product that solves the core problem: **never let a warranty expire without you knowing.**

## Capabilities

- **CAP-1: Add a warranty quickly**
  - **intent:** Users can add a new warranty to their account in under 30 seconds through a fast manual entry form.
  - **success:** A user can enter product name, purchase date, warranty duration, retailer, and price, then save — completing the flow in under 30 seconds on a mobile device.

- **CAP-2: Receive smart expiration notifications**
  - **intent:** Users receive proactive push and email notifications at configurable intervals (90, 60, 30, 7 days) before each warranty expires.
  - **success:** When a warranty reaches a configured threshold (e.g., 30 days before expiration), the user receives both a push notification and an email within 1 minute of the threshold being crossed, containing the product name, expiration date, and a link to view details.

- **CAP-3: View a color-coded warranty dashboard**
  - **intent:** Users see all their warranties at a glance, organized by urgency using a color-coded system (green = safe, yellow = expiring within 60 days, red = expired or critical within 7 days).
  - **success:** A user opens the app and can identify all expiring warranties (yellow/red) and all active warranties (green) in under 5 seconds, sorted by urgency (most urgent first).

- **CAP-4: Capture warranty info from purchase emails**
  - **intent:** Users can grant the app permission to scan their email for purchase confirmation messages and auto-extract warranty-relevant information (product name, purchase date, warranty duration, retailer).
  - **success:** When a user grants email access, the app parses at least 80% of standard purchase confirmation emails (from major retailers: Amazon, Best Buy, Apple, Walmart) and creates a draft warranty entry with product name, purchase date, and warranty duration pre-filled, requiring only manual review and confirmation.

- **CAP-5: Attach and store warranty documents**
  - **intent:** Users can attach receipts, warranty cards, and manuals (as PDFs or photos) to any warranty entry, and retrieve them at any time.
  - **success:** A user can attach one or more files (PDF up to 10MB, images up to 5MB each) to a warranty entry, and all attachments are searchable and accessible from the warranty detail view.

- **CAP-6: Maintain cloud-backed account persistence**
  - **intent:** All warranty data, settings, and documents are stored in the cloud and accessible from any device where the user logs in.
  - **success:** A user can create an account on one device, add warranties, log out, and log in on a different device — all warranties, attachments, and notification preferences are fully available within 60 seconds of login.

## Constraints

- **Mobile-first:** The MVP is a native mobile application (iOS and Android). A web dashboard is explicitly out of scope for this version.
- **No external API partnerships:** The MVP must function without any retailer API integrations. Email parsing is the only data ingestion method beyond manual entry.
- **No OCR or barcode scanning:** Receipt scanning via OCR and product barcode/QR scanning are deferred to Phase 2.
- **Single-user accounts only:** Family/household sharing is explicitly out of scope for the MVP.
- **No AI/ML features:** Predictive analytics, AI claim assistants, and automated claim filing are deferred to Phase 3.
- **Notification delivery:** Push notifications must be deliverable to both iOS (APNs) and Android (FCM) within 1 minute of trigger.

## Non-goals

- **Retailer API integrations** — No direct connections to Amazon, Best Buy, Apple, or any retailer. Email parsing is the sole automated ingestion method.
- **OCR receipt scanning** — Users enter warranty details manually or via email parsing. Receipt image upload is for storage, not parsing.
- **Barcode/QR code product lookup** — Not in scope. Users enter product details manually.
- **Family or household sharing** — Single-user accounts only. Multi-user features are deferred to Phase 2.
- **Automated claim filing** — The app notifies and organizes; it does not file claims on behalf of the user.
- **Warranty marketplace or insurance partnerships** — No buying/selling of warranties or insurance product integration.
- **Desktop/web application** — Mobile only (iOS and Android). A responsive web app is not in scope.
- **Social features** — No sharing warranties publicly, community ratings, or social feeds.

## Success signal

A user who has added 5+ warranties receives at least 3 expiration notifications before any warranty expires, views the dashboard weekly without prompting, and can demonstrate that they saved money by catching a claim before its warranty expired — all without opening a help document or contacting support.

## Assumptions

- Users have a smartphone with push notification capability (iOS 15+ or Android 10+).
- Users have access to email and are willing to grant the app permission to scan their inbox for purchase confirmations.
- Users are comfortable creating an account with an email address and password (or OAuth via Google/Apple).
- Users own or frequently use products that come with warranties (electronics, appliances, clothing, software subscriptions).
- Purchase confirmation emails from major retailers follow a reasonably consistent format that can be parsed with regex/heuristics (no NLP required for MVP).
- Push notification services (APNs for iOS, FCM for Android) are available and free for the expected user volume at launch.

## Open Questions

1. **Email parsing scope:** Which retailers' email formats should be prioritized for MVP? (Amazon, Best Buy, Apple, Walmart are mentioned — are there others critical for the target market?)
2. **Notification preferences:** Should users be able to set "quiet hours" during which notifications are suppressed? (Recommended but not specified in MVP scope.)
3. **Account recovery:** What authentication method is preferred — email/password only, or OAuth (Google/Apple sign-in) as well?
4. **Document storage limits:** Is there a per-user storage limit we should enforce (e.g., 50MB total attachments)?
5. **Offline access:** Should warranties and attachments be accessible offline? (Important for users who travel or have spotty connectivity.)
6. **Multi-currency support:** Is multi-currency needed for MVP, or can we assume a single currency (USD) for launch?
7. **Warranty duration input:** Should users specify duration in months, years, or days? (Affects UX design for CAP-1.)