# Group_Project_ING2B
# MuscleUp Wiki

## 1. Project Overview

**MuscleUp** is a coaching platform that connects clients with coaches.  
Built with **Flutter** (frontend) and **Django** (backend REST API).  
Developed by: Mariem Belhassen, Ahmed Hassin, Mohamed Ali Midassi.  
Methodology: **Agile** with 2-week sprints, tracked on **Trello**.

---

## 2. Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter (Dart) |
| Backend | Django + Django REST Framework |
| Database | SQLite (Django built-in) |
| Auth | Session-based (login/logout) |
| Storage | Django `ImageField` (avatars) |
| Validation | Custom regex (email, phone) |

---

## 3. Database Models

| Model | Description |
|-------|-------------|
| `User` | Custom AbstractUser with `client` or `coach` role |
| `Profile` | Client: full_name, avatar, bio, phone, location |
| `Coach` | Coach: expertise, experience_years, rating, sessions_count |
| `Offer` | Package: name, price, duration, availability → linked to `Coach` |
| `Session` | Booking status (pending/confirmed/rejected/completed/cancelled) |
| `Message` | Chat between client and coach |
| `Feedback` | Rating (1-5) + comment |
| `Availability` | Coach working hours |
| `Notification` | In-app alerts |

---

## 4. API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/register/` | User registration |
| POST | `/api/login/` | User login |
| POST | `/api/logout/` | User logout |
| POST | `/api/client/profile/create/` | Create client profile |
| GET | `/api/client/profile/` | Get client profile |
| POST | `/api/coach/profile/create/` | Create coach profile |
| GET | `/api/coach/profile/` | Get coach profile |
| GET | `/api/allcoaches/` | List all coaches |
| POST | `/api/coach/create_offer/` | Create an offer |
| POST | `/api/client/coach/<int:coach_id>/session/` | Book a session |
| GET | `/api/coach/sessions/` | Get coach's sessions |
| PUT/PATCH | `/api/sessions/<int:session_id>/update/` | Update session status |

---

## 5. Frontend Screens

| Screen | Description |
|--------|-------------|
| Landing Page | Login / Register with error handling |
| Client Home | Browse offers ($111/$399/$999) |
| Book Session | Select coach, date, and time |
| Coach Dashboard | Manage clients and view messages |
| Chat Interface | Real-time messaging with coach/client |
| Feedback Form | Rate coach (1-5 stars) after session |

---

## 6. Custom Validators

| Validator | Rule |
|-----------|------|
| `validate_email_regex` | Standard email format |
| `validate_phone_regex` | 10-15 digits, optional `+` |

---

## 7. Team & Sprint Planning

**Team:** Mariem Belhassen, Ahmed Hassin, Mohamed Ali Midassi

| Sprint | Focus |
|--------|-------|
| 1 | User auth + Profile + Coach models |
| 2 | Offers + Session booking API |
| 3 | Messaging + Feedback + Availability |
| 4 | Notifications + Flutter integration |
| 5 | Testing + Deployment |

**Trello tracks:** Task assignment, Bug reports, Sprint progress

---

## 8. Future Improvements

- Video call integration (Zoom/WebRTC)
- Payment gateway (Stripe)
- Push notifications (Firebase)
- Email/SMS reminders for sessions
- Coach calendar sync (Google Calendar)
- Mobile app deployment (App Store / Play Store)
- Complete missing endpoints (messages, feedback, availability)
