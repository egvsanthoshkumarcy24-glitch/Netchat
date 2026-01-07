CC = gcc
CFLAGS = -Wall -Wextra -pthread
TARGET_SERVER = server/server
TARGET_CLIENT = client/client
SRC_SERVER = server/server.c
SRC_CLIENT = client/client.c

.PHONY: all server client clean run-server run-client help

all: server client
	@echo "✅ Build complete!"
	@echo "Run 'make run-server' in one terminal"
	@echo "Run 'make run-client' in other terminals"

server:
	@echo "🔨 Compiling server..."
	$(CC) $(CFLAGS) -o $(TARGET_SERVER) $(SRC_SERVER)
	@echo "✅ Server compiled successfully!"

client:
	@echo "🔨 Compiling client..."
	$(CC) $(CFLAGS) -o $(TARGET_CLIENT) $(SRC_CLIENT)
	@echo "✅ Client compiled successfully!"

run-server: server
	@echo "🚀 Starting server..."
	@cd server && ./server

run-client: client
	@echo "🚀 Starting client..."
	@cd client && ./client

clean:
	@echo "🧹 Cleaning up..."
	rm -f $(TARGET_SERVER) $(TARGET_CLIENT) chat.log
	@echo "✅ Cleanup complete!"

help:
	@echo "NetChat - Makefile Commands"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "make all         - Compile both server and client"
	@echo "make server      - Compile only server"
	@echo "make client      - Compile only client"
	@echo "make run-server  - Compile and run server"
	@echo "make run-client  - Compile and run client"
	@echo "make clean       - Remove binaries and logs"
	@echo "make help        - Show this help message"
