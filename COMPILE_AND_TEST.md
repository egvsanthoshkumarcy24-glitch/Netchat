# 🛠️ NetChat - Compilation & Testing Guide

## 📋 Prerequisites

### Linux/Unix Systems
```bash
# Check if you have GCC
gcc --version

# Check if pthread library is available
ldconfig -p | grep pthread

# Should show: libpthread.so.0
```

### Windows (WSL/Cygwin)
```bash
# Install WSL (Windows Subsystem for Linux)
wsl --install

# Inside WSL:
sudo apt update
sudo apt install build-essential
```

---

## 🔨 Compilation

### Method 1: Manual Compilation

```bash
# Navigate to project
cd Netchat

# Compile server
gcc -o server/server server/server.c -lpthread -Wall -Wextra

# Compile client
gcc -o client/client client/client.c -lpthread -Wall -Wextra
```

**Flags explained:**
- `-o` : Output file name
- `-lpthread` : Link pthread library
- `-Wall` : Enable all warnings
- `-Wextra` : Extra warnings

### Method 2: Using Makefile (Create this)

Create `Makefile` in project root:

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -pthread
TARGET_SERVER = server/server
TARGET_CLIENT = client/client
SRC_SERVER = server/server.c
SRC_CLIENT = client/client.c

all: server client

server:
	$(CC) $(CFLAGS) -o $(TARGET_SERVER) $(SRC_SERVER)

client:
	$(CC) $(CFLAGS) -o $(TARGET_CLIENT) $(SRC_CLIENT)

clean:
	rm -f $(TARGET_SERVER) $(TARGET_CLIENT) chat.log

.PHONY: all server client clean
```

Then run:
```bash
make all      # Compile both
make clean    # Remove binaries and logs
```

---

## 🧪 Testing Scenarios

### Test 1: Basic Connection ✅

**Terminal 1 (Server):**
```bash
cd server
./server
```

**Expected output:**
```
Server running on port 8080...
Maximum clients: 10
Press Ctrl+C for graceful shutdown
```

**Terminal 2 (Client):**
```bash
cd client
./client
```

**Input:**
```
Username: Alice
Password: chat123
```

**Expected output:**
```
Connected to server...
Authentication successful! Welcome to NetChat!

Commands:
  /pm <user> <message> - Send private message
  /join <room> - Join a chat room
  /rooms - List available rooms
  /users - List users in current room

[Server]: Alice has joined #general
```

✅ **Pass if:** Authentication works, join notification appears

---

### Test 2: Timestamps & No Echo ✅

**Terminal 2 (Alice):**
```
Hello everyone!
```

**Expected on Alice's terminal:**
- Should NOT see her own message echoed back

**Expected on server terminal:**
```
[19:45] [#general] Alice: Hello everyone!
```

✅ **Pass if:** Timestamp appears, Alice doesn't see echo

---

### Test 3: Multiple Clients & Broadcasting ✅

**Terminal 3 (Bob):**
```bash
./client
Username: Bob
Password: chat123
```

**Expected on Bob's terminal:**
```
[Server]: Bob has joined #general
```

**Expected on Alice's terminal:**
```
[Server]: Bob has joined #general
```

**Bob types:**
```
Hi Alice!
```

**Expected on Alice's terminal:**
```
[19:46] [#general] Bob: Hi Alice!
```

✅ **Pass if:** Both users see each other's messages with timestamps

---

### Test 4: Chat Rooms ✅

**Terminal 2 (Alice):**
```
/join oslab
```

**Expected on Alice:**
```
[Server]: You joined #oslab
```

**Expected on Bob (still in #general):**
```
[Server]: Alice has left #general
```

**Alice types:**
```
This is the OS lab room
```

**Expected:** Bob does NOT see this message (different room)

**Bob types:**
```
/join oslab
```

**Expected on Alice:**
```
[Server]: Bob has joined #oslab
```

Now both can communicate.

✅ **Pass if:** Messages only reach users in same room

---

### Test 5: Private Messaging ✅

**Terminal 2 (Alice):**
```
/pm Bob This is a secret message
```

**Expected on Alice:**
```
[PM to Bob]: This is a secret message
```

**Expected on Bob:**
```
[PM from Alice]: This is a secret message
```

**Expected on other users:** Nothing (private)

✅ **Pass if:** Only Bob receives the PM, Alice gets confirmation

---

### Test 6: Room Commands ✅

**Terminal 2 (Alice):**
```
/rooms
```

**Expected:**
```
[Server]: Active rooms: #oslab #general
```

**Terminal 2 (Alice):**
```
/users
```

**Expected:**
```
[Server]: Users in this room: Alice Bob
```

✅ **Pass if:** Correct rooms and users listed

---

### Test 7: Maximum Client Limit ✅

**Open 10 client terminals (1-10)**

All should connect successfully.

**Open 11th client terminal:**

**Expected:**
```
Connected to server...
Server full. Try again later.
[Connection closed]
```

**Server output:**
```
[Server]: Rejected client - server full
```

✅ **Pass if:** 11th client is rejected with proper message

---

### Test 8: Authentication Failure ✅

**Terminal (New Client):**
```
Username: Hacker
Password: wrongpass
```

**Expected:**
```
Connected to server...
Authentication failed. Disconnecting...
[Connection closed]
```

✅ **Pass if:** Client disconnected, not allowed to chat

---

### Test 9: Graceful Shutdown ✅

**With 2-3 clients connected, on server terminal:**
```
Press Ctrl+C
```

**Expected on server:**
```
^C
[Server]: Server is shutting down. Goodbye!

Server shutdown complete.
```

**Expected on all client terminals:**
```
[Server]: Server is shutting down. Goodbye!
[Connection closed]
```

✅ **Pass if:** All clients notified before server exits

---

### Test 10: Message Logging ✅

**After running tests 1-9:**

```bash
cat chat.log
```

**Expected:**
```
[19:45] [Server]: Server started
[19:45] [Server]: Alice has joined #general
[19:45] [19:45] [#general] Alice: Hello everyone!
[19:46] [Server]: Bob has joined #general
[19:46] [19:46] [#general] Bob: Hi Alice!
[19:47] [Server]: Alice has left #general
[19:47] [Server]: Alice has joined #oslab
[19:48] [PM] Alice -> Bob: This is a secret message
...
```

✅ **Pass if:** All events logged with timestamps

---

## 🐛 Troubleshooting

### Error: "Address already in use"

**Problem:** Server port 8080 still in use from previous run

**Solution:**
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or wait 60 seconds for TCP timeout

# Or change port in server.c:
#define PORT 8081  // Use different port
```

---

### Error: "Connection refused"

**Problem:** Server not running or wrong IP

**Solution:**
```bash
# Make sure server is running first
cd server && ./server

# Check if server is listening
netstat -tuln | grep 8080

# Should show:
tcp    0    0 0.0.0.0:8080    0.0.0.0:*    LISTEN
```

---

### Error: "undefined reference to pthread_create"

**Problem:** pthread library not linked

**Solution:**
```bash
# Make sure -lpthread is at the END
gcc server.c -o server -lpthread   # ✅ Correct
gcc -lpthread server.c -o server   # ❌ Wrong
```

---

### Warning: "implicit declaration of function"

**Problem:** Missing headers

**Solution:**
Add at top of file:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <time.h>
#include <signal.h>
```

---

### Clients can't see each other's messages

**Problem:** Firewall or wrong room

**Solution:**
```bash
# Check firewall (Linux)
sudo ufw status

# Allow port 8080
sudo ufw allow 8080

# Make sure both clients in same room
/join general
```

---

## 📊 Performance Testing

### Stress Test: Rapid Messages

**Client terminal:**
```bash
for i in {1..100}; do echo "Message $i"; done | ./client
```

**Expected:** All 100 messages logged without corruption

---

### Concurrency Test: 10 Simultaneous Clients

```bash
# Open 10 terminals and run:
for i in {1..10}; do
  gnome-terminal -- bash -c "./client; exec bash"
done
```

**Expected:** All 10 connect, can chat simultaneously

---

## ✅ Complete Test Checklist

Before submitting/presenting, verify:

- [ ] Compiles without errors
- [ ] Compiles without warnings (-Wall -Wextra)
- [ ] Server starts and shows correct messages
- [ ] Client can connect and authenticate
- [ ] Join/leave notifications work
- [ ] Timestamps appear on all messages
- [ ] Sender doesn't see own message (no echo)
- [ ] Room switching works (/join)
- [ ] Private messages work (/pm)
- [ ] Room listing works (/rooms)
- [ ] User listing works (/users)
- [ ] 11th client rejected (max limit)
- [ ] Wrong password rejected
- [ ] Ctrl+C graceful shutdown works
- [ ] chat.log contains all messages
- [ ] No memory leaks (run with valgrind)
- [ ] No crashes with malformed input

---

## 🔍 Valgrind Memory Check (Optional)

```bash
# Install valgrind
sudo apt install valgrind

# Run server with memory checking
valgrind --leak-check=full --show-leak-kinds=all ./server

# Connect client and chat, then Ctrl+C

# Check output:
# "All heap blocks were freed" → ✅ No memory leaks
```

---

## 📈 Performance Metrics

**Typical values on modern hardware:**

- **Connection time:** <10ms
- **Message latency:** <1ms (localhost)
- **Max clients supported:** 10 (configurable)
- **Messages per second:** 1000+ (limited by terminal I/O)
- **Memory per client:** ~4KB (stack + struct)

---

## 🎯 Demo Preparation

### 5-Minute Demo Plan:

1. **[0:00-0:30]** Compile both programs
2. **[0:30-1:00]** Start server
3. **[1:00-2:00]** Connect 2 clients, authenticate
4. **[2:00-3:00]** Show basic chat, timestamps, no echo
5. **[3:00-4:00]** Demonstrate rooms and private messages
6. **[4:00-4:30]** Show graceful shutdown
7. **[4:30-5:00]** Display log file

**Keep terminals organized:**
```
Screen layout:
┌──────────────┬──────────────┐
│   Server     │   Client 1   │
│   Terminal   │   (Alice)    │
├──────────────┼──────────────┤
│  Client 2    │   Log File   │
│   (Bob)      │   (cat)      │
└──────────────┴──────────────┘
```

---

**Good luck with testing!** 🚀
