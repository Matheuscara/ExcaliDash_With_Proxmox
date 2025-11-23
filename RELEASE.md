# ExcaliDash v0.1.3

**Type:** Security Release  
**Date:** 2025-11-23  
**Compatibility:** v0.1.0 (Backward Compatible)

## Security Fixes

**Input Sanitization & XSS Prevention**

- Implemented basic sanitization using `dompurify` and `jsdom`. All drawing data, text inputs, and SVG content are now stripped of non-geometric elements and malicious attributes before persistence. URL validation now explicitly blocks `javascript:`, `data:`, and `vbscript:` schemes.

**Network & Headers**

- Enforced Content Security Policy (CSP) with strict source restrictions. Added standard hardening headers: `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff`, and strict Referrer Policy. Rate limiting added (1,000 req/15min).
  **Validation Logic**

- Adopted `zod` schemas for strict runtime type checking on all API inputs. Requests exceeding length limits or failing schema validation are rejected prior to processing.

## Infra

**Docker Architecture**

- Containers now execute as a non-root user (uid 1001) to minimize privilege escalation risks. Refactored into a multi-stage build to reduce image size and enforce proper file ownership/permissions on startup.

**Async Operations & Database**

- Moved blocking file I/O and SQLite integrity checks to worker threads (`src/workers/db-verify.js`) to prevent event loop stalling. Switched to `better-sqlite3`. Database imports now trigger automatic backups and validate SQLite file headers before execution.

## Developer & Migration Notes

- **New Env Var**: `FRONTEND_URL` must be defined for CORS (e.g., `http://localhost:6767`).
- **Testing**: Added `npm run security-test` suite covering XSS payloads, SVG boundaries, and upload limits.
- **Migration**: No database schema changes. Existing volumes are compatible; the container will automatically fix permissions on startup.
