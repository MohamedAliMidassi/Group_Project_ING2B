# Group_Project_ING2B
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MuscleUp Wiki</title>
    <style>
        /* Modern, clean reset and base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background: #f7f9fc;
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.5;
            color: #1a202c;
            padding: 2rem 1rem;
        }
        .wiki-container {
            max-width: 1100px;
            margin: 0 auto;
            background: white;
            border-radius: 24px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
            padding: 2rem 2rem 3rem;
            transition: all 0.2s;
        }
        /* Typography */
        h1 {
            font-size: 2.5rem;
            font-weight: 700;
            line-height: 1.2;
            margin: 0 0 0.5rem 0;
            background: linear-gradient(135deg, #1e2a3a, #2c3e50);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            letter-spacing: -0.01em;
        }
        h2 {
            font-size: 1.75rem;
            font-weight: 600;
            margin: 2rem 0 1rem 0;
            padding-bottom: 0.5rem;
            border-bottom: 3px solid #e2e8f0;
            color: #0f172a;
        }
        h3 {
            font-size: 1.3rem;
            font-weight: 600;
            margin: 1.5rem 0 0.75rem;
            color: #1e293b;
        }
        p {
            margin: 1rem 0;
            line-height: 1.6;
            color: #2d3e50;
        }
        .badge-group {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin: 1rem 0 1.5rem;
        }
        .badge {
            background: #f1f5f9;
            padding: 0.3rem 0.9rem;
            border-radius: 40px;
            font-size: 0.85rem;
            font-weight: 500;
            color: #1e293b;
            border: 1px solid #e2e8f0;
        }
        .badge-accent {
            background: #eef2ff;
            color: #1e40af;
            border-color: #cbd5e1;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.25rem 0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 1px 2px rgba(0,0,0,0.03);
        }
        th {
            background: #f8fafc;
            text-align: left;
            padding: 12px 16px;
            font-weight: 600;
            color: #0f172a;
            border-bottom: 1px solid #e2e8f0;
        }
        td {
            padding: 12px 16px;
            border-bottom: 1px solid #edf2f7;
            background-color: #ffffff;
        }
        tr:last-child td {
            border-bottom: none;
        }
        code {
            background: #f1f5f9;
            padding: 0.2rem 0.4rem;
            border-radius: 8px;
            font-family: 'SF Mono', 'Menlo', monospace;
            font-size: 0.85rem;
            color: #0f172a;
        }
        pre {
            background: #0f172a;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 16px;
            overflow-x: auto;
            font-size: 0.85rem;
            font-family: 'SF Mono', monospace;
            margin: 1rem 0;
        }
        .endpoint-list {
            background: #fafcff;
            border-radius: 20px;
            padding: 0.5rem 0;
        }
        .endpoint-item {
            display: flex;
            align-items: baseline;
            padding: 0.7rem 0;
            border-bottom: 1px solid #ecf3fa;
        }
        .method {
            font-weight: 700;
            min-width: 70px;
            font-family: monospace;
            color: #2563eb;
        }
        .path {
            font-family: monospace;
            color: #2c3e50;
            background: #f1f5f9;
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .desc {
            margin-left: 1rem;
            color: #334155;
        }
        hr {
            border: 0;
            height: 1px;
            background: linear-gradient(90deg, #e2e8f0, transparent);
            margin: 2rem 0;
        }
        .footer-note {
            margin-top: 2.5rem;
            padding-top: 1rem;
            font-size: 0.85rem;
            text-align: center;
            color: #5b6e8c;
            border-top: 1px solid #e9edf2;
        }
        @media (max-width: 700px) {
            .wiki-container {
                padding: 1.5rem;
            }
            h1 { font-size: 2rem; }
            h2 { font-size: 1.5rem; }
            .endpoint-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 6px;
            }
            .desc { margin-left: 0; margin-top: 4px; }
        }
    </style>
</head>
<body>
<div class="wiki-container">
    <!-- Header with modern icon -->
    <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap; justify-content: space-between;">
        <h1>💪 MuscleUp Wiki</h1>
        <div class="badge-group">
            <span class="badge badge-accent">v1.0</span>
            <span class="badge">Active Development</span>
        </div>
    </div>
    
    <!-- 1. Project Overview -->
    <h2>📌 1. Project Overview</h2>
    <p><strong>MuscleUp</strong> is a coaching platform that connects clients with professional coaches. 
    Built with <strong>Flutter</strong> (frontend) and <strong>Django + DRF</strong> (backend REST API).</p>
    <p><strong>👥 Team:</strong> Mariem Belhassen, Ahmed Hassin, Mohamed Ali Midassi.<br>
    <strong>📋 Methodology:</strong> Agile with 2-week sprints, tracked on <strong>Trello</strong>.</p>
    
    <!-- quick info cards (modern) -->
    <div style="display: flex; flex-wrap: wrap; gap: 1rem; margin: 1.5rem 0 0.5rem;">
        <div style="background: #f8fafc; border-radius: 20px; padding: 0.8rem 1.2rem; flex:1; min-width: 140px;">
            <div style="font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; color: #4b5563;">Frontend</div>
            <div style="font-weight: 600; font-size: 1.2rem;">Flutter · Dart</div>
        </div>
        <div style="background: #f8fafc; border-radius: 20px; padding: 0.8rem 1.2rem; flex:1; min-width: 140px;">
            <div style="font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; color: #4b5563;">Backend</div>
            <div style="font-weight: 600; font-size: 1.2rem;">Django · DRF</div>
        </div>
        <div style="background: #f8fafc; border-radius: 20px; padding: 0.8rem 1.2rem; flex:1; min-width: 140px;">
            <div style="font-weight: 600; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; color: #4b5563;">Database</div>
            <div style="font-weight: 600; font-size: 1.2rem;">SQLite (built-in)</div>
        </div>
    </div>

    <hr>

    <!-- 2. Tech Stack (clean table) -->
    <h2>⚙️ 2. Tech Stack</h2>
    <table>
        <thead>
            <tr><th>Layer</th><th>Technology</th></tr>
        </thead>
        <tbody>
            <tr><td>Frontend</td><td>Flutter (Dart)</td></tr>
            <tr><td>Backend</td><td>Django + Django REST Framework</td></tr>
            <tr><td>Database</td><td>SQLite (Django built-in)</td></tr>
            <tr><td>Authentication</td><td>Session-based (login / logout)</td></tr>
            <tr><td>Media Storage</td><td>Django <code>ImageField</code> (avatars)</td></tr>
            <tr><td>Validation</td><td>Custom regex (email, phone)</td></tr>
        </tbody>
    </table>

    <hr>

    <!-- 3. Database Models (Core Entities) -->
    <h2>🗃️ 3. Database Models</h2>
    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px,1fr)); gap: 1rem; margin: 1.5rem 0;">
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.02);">
            <div style="font-weight: 700; font-size: 1.2rem;">👤 User</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Custom AbstractUser with <code>client</code> or <code>coach</code> role.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">📇 Profile</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Client info: full_name, avatar, bio, phone, location.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">🏋️ Coach</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Expertise, experience_years, rating, sessions_count.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">💰 Offer</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Package: name, price, duration → linked to Coach.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">📅 Session</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Booking status (pending/confirmed/rejected/completed/cancelled).</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">💬 Message</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Chat between client & coach, read status.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">⭐ Feedback</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Rating (1-5) + comment, linked to Session.</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">📆 Availability</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">Coach working hours (day, start/end, is_available).</div>
        </div>
        <div style="background: #ffffff; border: 1px solid #eef2ff; border-radius: 20px; padding: 1rem;">
            <div style="font-weight: 700; font-size: 1.2rem;">🔔 Notification</div>
            <div style="font-size: 0.9rem; color: #2c3e50;">In-app alerts (session_reminder, message, booking).</div>
        </div>
    </div>

    <hr>

    <!-- 4. API Endpoints (modern list) -->
    <h2>🔌 4. API Endpoints (Implemented)</h2>
    <div class="endpoint-list">
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/register/</span> <span class="desc">User registration</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/login/</span> <span class="desc">User login (session)</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/logout/</span> <span class="desc">User logout</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/client/profile/create/</span> <span class="desc">Create client profile</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/client/profile/</span> <span class="desc">Get client profile</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/coach/profile/create/</span> <span class="desc">Create coach profile</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/coach/profile/</span> <span class="desc">Get coach profile</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/allcoaches/</span> <span class="desc">List all coaches</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/coach/&lt;int:coach_id&gt;/</span> <span class="desc">Get coach by ID</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/coach/create_offer/</span> <span class="desc">Create an offer (coach)</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/coach/offers/&lt;coach_id&gt;/</span> <span class="desc">Get coach's offers</span></div>
        <div class="endpoint-item"><span class="method">POST</span> <span class="path">/api/client/coach/&lt;coach_id&gt;/session/</span> <span class="desc">Book a session</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/coach/sessions/</span> <span class="desc">Get coach sessions</span></div>
        <div class="endpoint-item"><span class="method">GET</span> <span class="path">/api/coach/sessions/&lt;session_id&gt;/</span> <span class="desc">Session detail</span></div>
        <div class="endpoint-item"><span class="method">PUT/PATCH</span> <span class="path">/api/sessions/&lt;session_id&gt;/update/</span> <span class="desc">Update session status</span></div>
    </div>
    <p style="margin-top: 12px; font-size: 0.85rem; background: #fef9e3; padding: 0.5rem 1rem; border-radius: 40px; display: inline-block;">⚠️ Missing endpoints: messages, feedback, availability, notifications (in progress)</p>

    <hr>

    <!-- 5. Frontend Screens (based on wireframes) -->
    <h2>📱 5. Frontend Screens (Flutter)</h2>
    <div style="display: flex; flex-wrap: wrap; gap: 12px; margin: 1rem 0 1.5rem;">
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">🔐 Landing / Login</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">🏠 Client Home (Offers $111/$399/$999)</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">📅 Book Session</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">📊 Coach Dashboard</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">💬 Clients Messages</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">⭐ Feedback & Rating</span>
        <span style="background: #eef2ff; padding: 0.3rem 1rem; border-radius: 40px; font-weight: 500;">🚪 Logout</span>
    </div>

    <!-- Custom validators highlight -->
    <h2>✅ 6. Custom Validators</h2>
    <table style="width: auto; min-width: 300px;">
        <thead><tr><th>Validator</th><th>Regex Rule</th></tr></thead>
        <tbody>
            <tr><td><code>validate_email_regex</code></td><td>Standard email format</td></tr>
            <tr><td><code>validate_phone_regex</code></td><td>10-15 digits, optional leading '+'</td></tr>
        </tbody>
    </table>

    <hr>

    <!-- Sprint Planning / Trello -->
    <h2>📌 7. Sprint Planning (Trello)</h2>
    <div style="display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 1rem;">
        <div style="background: #f1f5f9; border-radius: 20px; padding: 1rem; flex: 1;">
            <div style="font-weight: 700;">Sprint 1</div>
            <div style="font-size: 0.9rem;">User auth + Profile + Coach models</div>
        </div>
        <div style="background: #f1f5f9; border-radius: 20px; padding: 1rem; flex: 1;">
            <div style="font-weight: 700;">Sprint 2</div>
            <div style="font-size: 0.9rem;">Offers + Session booking API</div>
        </div>
        <div style="background: #f1f5f9; border-radius: 20px; padding: 1rem; flex: 1;">
            <div style="font-weight: 700;">Sprint 3</div>
            <div style="font-size: 0.9rem;">Messaging + Feedback + Availability</div>
        </div>
        <div style="background: #f1f5f9; border-radius: 20px; padding: 1rem; flex: 1;">
            <div style="font-weight: 700;">Sprint 4</div>
            <div style="font-size: 0.9rem;">Notifications + Flutter integration</div>
        </div>
        <div style="background: #f1f5f9; border-radius: 20px; padding: 1rem; flex: 1;">
            <div style="font-weight: 700;">Sprint 5</div>
            <div style="font-size: 0.9rem;">Testing + Deployment + Docs</div>
        </div>
    </div>

    <hr>

    <!-- 8. Future Improvements -->
    <h2>🚀 8. Future Roadmap</h2>
    <ul style="margin: 1rem 0 1.5rem 1.8rem; line-height: 1.7;">
        <li>🎥 Video call integration (Zoom / WebRTC)</li>
        <li>💳 Payment gateway (Stripe)</li>
        <li>📲 Push notifications (Firebase Cloud Messaging)</li>
        <li>✉️ Complete missing endpoints: messages, feedback, availability, notifications</li>
        <li>📧 Email/SMS session reminders</li>
        <li>🗓️ Coach calendar sync (Google Calendar)</li>
    </ul>

    <!-- Additional note: Git friendly separation -->
    <div class="footer-note">
        ✨ MuscleUp · Built with Flutter & Django · Agile on Trello
    </div>
</div>
</body>
</html>
