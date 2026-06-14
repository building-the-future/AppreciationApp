# Backend Plan — AppreciateApp
**Century Plyboards Kandla Plant | 1-page reference**

---

## Stack Decision: Supabase (free → paid)

| What you get free | Limit |
|---|---|
| PostgreSQL database | 500 MB |
| Auth (JWT sessions) | Unlimited users |
| File Storage | 1 GB |
| REST + Realtime API | Unlimited calls |
| Dashboard (admin panel) | Full access |

No separate server. No hosting cost. Upgrade to Pro ($25/mo) only when you hit storage limits.

---

## 4 Tables to Create

```sql
employees   — employee_code, name, department, hod_name, hod_email
users       — username, password_hash, role, is_first_login, is_active
appreciations — giver, receiver, department, effort, images[], status
approval_log  — appreciation_id, approver, action, comment
```

**Roles stored in `users.role`:** `'user'` | `'hod'` | `'admin'`
Change anyone's role anytime via Supabase Table Editor — zero code change.

---

## Auth Flow (custom, no Supabase Auth needed)

```
Login → query users table → hash compare → return user object → store in SecureStorage
First login → password == username → force ChangePassword → update hash + is_first_login=false
```

Password is SHA-256 hashed on device before sending. No plain text ever leaves the phone.

---

## API Calls to Wire In Flutter (replace mock data)

| Screen | Supabase call |
|---|---|
| Login | `supabase.from('users').select().eq('username', u).single()` |
| Employee search | `supabase.from('employees').select().ilike('name', '%q%')` |
| Submit appreciation | `supabase.from('appreciations').insert({...})` |
| View list | `supabase.from('appreciations').select().eq('giver_username', u)` |
| Pending approval | `supabase.from('appreciations').select().in_('status', ['pending','hod_approved'])` |
| Approve/Reject | `supabase.from('appreciations').update({'status': ...}).eq('id', id)` |
| Summary | `supabase.from('appreciations').select()` + local grouping |

---

## Image Upload

```dart
// Upload to Supabase Storage bucket 'appreciation-images'
final path = '${userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
await supabase.storage.from('appreciation-images').upload(path, file);
final url = supabase.storage.from('appreciation-images').getPublicUrl(path);
// Save `url` into appreciations.image_urls array
```

---

## Seeding Users & Employees

1. Export `Staff_Data_Upload.xlsx` → CSV
2. Supabase Dashboard → Table Editor → `employees` → Import CSV
3. Export `User_Create.xlsx` → CSV  
4. Supabase Dashboard → `users` → Import CSV  
   (default `password_hash` = SHA-256 of username, `is_first_login = true`)

To change a role: Table Editor → `users` → edit `role` field. Done.
To deactivate a user: set `is_active = false`. They can't login.

---

## 3 Steps to Go Live

```
1. supabase.com → New Project → copy URL + anon key → paste in supabase.js
2. Run supabase_setup.sql in SQL Editor
3. Import employee + user CSVs via Table Editor
```

Total setup time: ~45 minutes.

---

## Play Store Deployment

```bash
flutter build apk --release                  # Test APK
flutter build appbundle --release            # Upload to Play Store
```

Signing: Android Studio → Build → Generate Signed Bundle → follow wizard.
Play Console: Create app → Internal testing → upload .aab → promote to production.
