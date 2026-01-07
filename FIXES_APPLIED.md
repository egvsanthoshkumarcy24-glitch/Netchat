# NetChat - Quick Fixes Applied

## 🔧 Issues Fixed:

### 1. ✅ Timestamp Format Fixed
- Changed from `[HH:MM]` to `[HH:MM:SS]` for more precision
- Now shows: `[19:45:30]` instead of `[19:45]`

### 2. ✅ Chat Room Management
- **Default room:** Everyone joins `#general` automatically
- **New command:** `/room` - Check which room you're currently in
- **Create room:** Just use `/join newroomname` - it creates if doesn't exist
- **Example:**
  ```
  /room           → [Server]: You are in #general
  /join oslab     → Creates and joins #oslab
  /join cnlab     → Creates and joins #cnlab
  ```

### 3. ✅ users.txt Corruption FIXED
**Problem:** Messages were being saved to users.txt in wrong format

**Root cause:** Username/password containing colons or newlines

**Fix:** Input sanitization added:
- Removes colons `:` from username/password
- Removes newlines `\n` 
- Removes carriage returns `\r`
- Removes spaces (for password)
- Validates cleaned inputs before saving

**Clean format now:**
```
santhosh:pass123
avi:mypass
kaizen:secret
```

### 4. ✅ Private Message Display Fixed
**Problem:** `/pm` commands showing in room chat

**Fixes:**
- Added newline removal from PM messages
- Added explicit newlines to confirmations
- Added usage help if wrong format: `/pm <username> <message>`
- PM messages no longer leak to room chat

---

## 🚀 How to Reset and Start Fresh:

### Option 1: Manual Cleanup (Windows/WSL)
```bash
# Delete corrupted files
rm users.txt chat.log

# Recompile
gcc -o server/server server/server.c -lpthread -Wall -Wextra
gcc -o client/client client/client.c -lpthread -Wall -Wextra

# Start fresh
./server/server
```

### Option 2: Use Reset Script (Linux/WSL)
```bash
chmod +x reset.sh
./reset.sh
```

---

## 📖 Room System Explained:

### Default Behavior:
1. When you login, you're automatically in `#general`
2. All users start in `#general`
3. Messages only go to users in the same room

### Commands:
```bash
/room               # Check current room
/join oslab         # Create and join #oslab room
/join cnlab         # Switch to #cnlab room
/rooms              # List all active rooms
/users              # List users in YOUR current room
```

### Example Session:
```
[You login] → Automatically in #general
/room       → [Server]: You are in #general
/join oslab → [Server]: You joined #oslab
              [To others in #general]: Alice left #general
              [To others in #oslab]: Alice joined #oslab
/room       → [Server]: You are in #oslab
```

---

## 🔐 Authentication Now Works Correctly:

### First Time User:
```
Username: santhosh
Password: mypass123
```
**Server:** Creates account in users.txt as `santhosh:mypass123`

### Returning User:
```
Username: santhosh
Password: mypass123    ← Must match exactly
```
**Server:** Verifies and logs you in

### Wrong Password:
```
Username: santhosh
Password: wrongpass
```
**Server:** `Authentication failed. Disconnecting...`

---

## ✅ Checklist After Reset:

- [ ] Delete old `users.txt` (if corrupted)
- [ ] Recompile both server and client
- [ ] Start server
- [ ] Login with new credentials
- [ ] Check room with `/room` command
- [ ] Test `/join` to create new rooms
- [ ] Verify `users.txt` has clean format (username:password)
- [ ] Test PM with `/pm username message`

---

## 📝 Correct File Formats:

### users.txt (after fixes):
```
santhosh:pass123
avi:mypassword
kaizen:secret
bob:bobpass
```

### chat.log (sample):
```
[19:45:30] [Server]: Server started
[19:45:35] [Server]: santhosh has joined #general
[19:45:40] [19:45:40] [#general] santhosh: Hello everyone!
[19:46:10] [PM] santhosh -> avi: This is private
[19:47:00] [Server]: santhosh has left #general
[19:47:00] [Server]: santhosh has joined #oslab
```

---

**Everything is fixed! Recompile and start fresh.** 🎯
