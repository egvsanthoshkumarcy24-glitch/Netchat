# Netchat - Multi-threaded Chat Application

A feature-rich, multi-threaded chat server and client application in C demonstrating core OS and networking concepts.

## 🎯 All Features Implemented (9 Total)

### ✅ Level 1: Core Features
1. **Join/Leave Notifications** ⭐⭐⭐
2. **Timestamp on Messages** ⭐⭐⭐
3. **Prevent Echo (No message loop)** ⭐⭐⭐
4. **Maximum Client Limit Handling** ⭐⭐⭐⭐
5. **Graceful Server Shutdown** ⭐⭐⭐⭐
6. **Message Logging to File** ⭐⭐⭐⭐

### ✅ Level 2: Advanced Features
7. **Private Messaging (/pm)** ⭐⭐⭐⭐⭐
8. **User Authentication (Password)** ⭐⭐⭐⭐⭐
9. **Chat Rooms/Channels (/join)** ⭐⭐⭐⭐⭐

## 📦 Quick Start

### Compile
```bash
# Server
gcc -o server/server server/server.c -lpthread

# Client
gcc -o client/client client/client.c -lpthread
```

### Run
```bash
# Terminal 1 - Start server
cd server && ./server

# Terminal 2,3,4... - Connect clients
cd client && ./client
```

### Login Credentials
- **Password:** `chat123` (for all users)
- **Username:** Any name you choose

## 💬 Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/pm <user> <msg>` | Send private message | `/pm Alice Hello!` |
| `/join <room>` | Join/switch room | `/join oslab` |
| `/rooms` | List active rooms | `/rooms` |
| `/users` | List users in room | `/users` |

## 📄 Files Generated
- `chat.log` - All chat history with timestamps

## 🎓 Key Features for Viva

1. **Thread-safe file I/O** - Mutex-protected logging
2. **Signal handling** - SIGINT for graceful shutdown
3. **Resource management** - Max 10 clients enforced
4. **Command parsing** - Custom protocol design
5. **Multi-room architecture** - Scalable like Slack/Discord
6. **Authentication** - Username/password validation
7. **Private messaging** - Point-to-point communication

## 📚 Full Documentation

See [README_GITHUB.md](README_GITHUB.md) for comprehensive documentation including:
- Detailed architecture diagrams
- Viva Q&A guide
- Code explanations
- OS/CN concepts mapping

---

**Author:** Santhosh Kumar  
**Purpose:** Educational project for OS and Computer Networks
