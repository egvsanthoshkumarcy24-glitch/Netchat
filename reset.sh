#!/bin/bash

# Clean up corrupted users.txt and reset
echo "Cleaning up Netchat files..."

# Remove corrupted users file
if [ -f "users.txt" ]; then
    echo "Removing corrupted users.txt..."
    rm users.txt
fi

# Remove old log
if [ -f "chat.log" ]; then
    echo "Removing old chat.log..."
    rm chat.log
fi

# Recompile
echo "Recompiling server and client..."
gcc -o server/server server/server.c -lpthread -Wall -Wextra
gcc -o client/client client/client.c -lpthread -Wall -Wextra

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo ""
    echo "Fresh start ready!"
    echo "- users.txt will be created on first login"
    echo "- Default room is 'general'"
    echo "- Use /room to check current room"
    echo "- Use /join <roomname> to create/join a room"
else
    echo "❌ Compilation failed!"
fi
