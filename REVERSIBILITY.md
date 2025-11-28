# Reversibility

<!--
SPDX-License-Identifier: GPL-3.0-or-later
-->

## Overview

Candy Crash is designed with **reversibility** as a core principle. Every operation can be undone, every decision can be changed, and no action is permanently destructive. This document outlines how to reverse common operations.

## Why Reversibility Matters

- **Safety**: Mistakes don't cause permanent damage
- **Experimentation**: Try new approaches without fear
- **Learning**: Students can reset progress and retry
- **Trust**: Users maintain control over their data

## Git-Level Reversibility

### Undo Last Commit (Not Pushed)

```bash
git reset --soft HEAD~1  # Keep changes staged
git reset HEAD~1         # Keep changes unstaged
git reset --hard HEAD~1  # Discard changes (use with caution)
```

### Undo Pushed Commit

```bash
git revert <commit-hash>
git push
```

### Restore Deleted File

```bash
git checkout HEAD -- <filename>
# Or from specific commit:
git checkout <commit-hash> -- <filename>
```

## Database-Level Reversibility

### Rails Migrations

All migrations can be rolled back:

```bash
# Rollback last migration
rails db:rollback

# Rollback specific number of migrations
rails db:rollback STEP=3

# Rollback to specific version
rails db:migrate VERSION=20251122011736
```

### Data Recovery

Deleted records are **soft-deleted** where possible:

- Users: Devise provides recoverable functionality
- Course enrollments: Can be re-enrolled
- Quiz attempts: History preserved (cannot delete attempts)

## Application-Level Reversibility

### User Actions

| Action | Reversal Method | Limitations |
|--------|----------------|-------------|
| Enroll in course | Admin can unenroll | Progress lost |
| Complete lesson | Admin can mark incomplete | Achievement may remain |
| Submit quiz | Retake quiz (new attempt) | Previous attempt preserved |
| Earn achievement | Cannot revoke (by design) | Achievements are permanent rewards |
| Update profile | Edit profile again | Previous values not tracked |

### Admin Actions

| Action | Reversal Method | Limitations |
|--------|----------------|-------------|
| Create course | Delete or unpublish | Student enrollments affected |
| Publish course | Set `published: false` | Immediate effect |
| Delete question | Restore from Git history | Manual process |
| Ban user | Update `user.active` flag | Uses Devise lockable |

### Instructor Actions

| Action | Reversal Method | Limitations |
|--------|----------------|-------------|
| Create lesson | Delete or unpublish | Student progress affected |
| Create quiz | Delete or unpublish | Active attempts may fail |
| Edit content | Restore from Git (if tracked) | No built-in versioning |

## Code-Level Reversibility

### Feature Flags

Critical features can be toggled without deployment:

```ruby
# config/initializers/feature_flags.rb
FEATURES = {
  achievements: ENV.fetch('ENABLE_ACHIEVEMENTS', 'true') == 'true',
  gamification: ENV.fetch('ENABLE_GAMIFICATION', 'true') == 'true',
  social_features: ENV.fetch('ENABLE_SOCIAL', 'false') == 'true'
}
```

Disable a feature:

```bash
ENABLE_ACHIEVEMENTS=false rails server
```

### Database Seeds

Reset database to fresh state:

```bash
# WARNING: Destructive in production
rails db:reset  # Drops DB, recreates, runs migrations, seeds
```

## Configuration Reversibility

### Environment Variables

All configuration via ENV vars can be changed without code changes:

```bash
# .env file (gitignored)
DATABASE_URL=postgresql://...
SMTP_HOST=smtp.example.com
```

Change settings by editing `.env` and restarting.

### Rails Credentials

Encrypted credentials can be rotated:

```bash
# Edit credentials
EDITOR=nano rails credentials:edit

# Rotate master key (requires re-encryption)
rm config/master.key
rails credentials:edit  # Generates new key
```

## Data Export (Ultimate Reversibility)

Users can export their data at any time:

### Student Data Export (Planned)

```ruby
# Future feature:
# GET /profile/export
# Returns JSON with:
# - Profile information
# - Course enrollments
# - Lesson progress
# - Quiz attempts and scores
# - Achievements earned
```

### Full Database Backup

```bash
# PostgreSQL
pg_dump candy_crash_production > backup.sql

# SQLite (development)
sqlite3 db/development.sqlite3 .dump > backup.sql
```

### Restore from Backup

```bash
# PostgreSQL
psql candy_crash_production < backup.sql

# SQLite
sqlite3 db/development.sqlite3 < backup.sql
```

## Irreversible Operations (By Design)

Some operations are **intentionally irreversible** for data integrity:

### Cannot Reverse

1. **Achievement Unlocks**: Once earned, always earned (motivation psychology)
2. **Quiz Attempt History**: Preserved for academic integrity
3. **Audit Logs**: Security requirement (tamper-evidence)
4. **Password Resets**: Previous password hashes discarded

### Why These Are Irreversible

- **Achievements**: Reversing would undermine gamification
- **Quiz History**: Academic honesty requires immutable records
- **Audit Logs**: Security best practice
- **Passwords**: Security requirement (one-way hashing)

## Emergency Recovery

### Lost Admin Access

```bash
# Rails console
rails console
User.find_by(email: 'admin@example.com').update(role: :admin)
```

### Corrupted Database

1. Stop application
2. Restore from last backup
3. Replay WAL logs (PostgreSQL) or re-run migrations
4. Verify data integrity
5. Restart application

### Accidental Deletion

1. Check Git history: `git log -- <deleted_file>`
2. Restore file: `git checkout <commit> -- <deleted_file>`
3. If database: Restore from backup or use `rails db:rollback`

## Testing Reversibility

### Development

```bash
# Make changes
rails db:migrate

# Test reversal
rails db:rollback
rails db:migrate  # Should work identically
```

### CI/CD

Automated tests verify migrations are reversible:

```bash
# In .github/workflows/ci.yml
rails db:migrate
rails db:rollback
rails db:migrate  # Must succeed
```

## Best Practices

1. **Always write reversible migrations** with proper `up` and `down` methods
2. **Test rollback** before deploying migrations
3. **Backup before major changes** (database, configuration)
4. **Use Git tags** for release points
5. **Document irreversible operations** clearly
6. **Prefer soft deletes** over hard deletes for user data
7. **Version APIs** to allow backward compatibility

## Future Enhancements

- [ ] Automated daily backups
- [ ] Point-in-time recovery (PostgreSQL)
- [ ] User data export API
- [ ] Content versioning for lessons/courses
- [ ] Audit log UI for administrators
- [ ] Undo queue for recent admin actions

## References

- **Rails Migrations**: https://guides.rubyonrails.org/active_record_migrations.html
- **Devise Recoverable**: https://github.com/heartcombo/devise#recoverable
- **Git Revert**: https://git-scm.com/docs/git-revert
- **PostgreSQL PITR**: https://www.postgresql.org/docs/current/continuous-archiving.html

## Questions?

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to ask questions or propose improvements to reversibility features.
