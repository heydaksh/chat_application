# Plimpzik API Documentation

> Documentation for frontend integration. Covers Auth, Friend, and Chat modules.

---

## Table of Contents

- [Base URL & Setup](#base-url--setup)
- [Authentication](#authentication)
- [Response Format](#response-format)
- [Auth Module](#auth-module)
- [Friend Module](#friend-module)
- [Chat Module](#chat-module)
- [Message Module](#message-module)
- [Real-time Events (Socket.IO)](#real-time-events-socketio)
- [Data Models](#data-models)
- [Error Codes](#error-codes)

---

## Base URL & Setup

```
Base URL: /api
```

All requests should include the `Content-Type: application/json` header.

---

## Authentication

Protected routes require a Bearer token in the `Authorization` header.

```
Authorization: Bearer <token>
```

- Token is returned after **login** or **OTP verification**
- Token expires in **90 days**
- Token payload contains the user ID

**Unauthorized Response (401):**
```json
{
  "success": false,
  "message": "Unauthorized"
}
```

---

## Response Format

### Success
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Description of what happened",
  "data": {}
}
```

### Paginated Success
```json
{
  "success": true,
  "statusCode": 200,
  "message": "...",
  "data": {
    "items": [],
    "meta": {
      "total": 100,
      "page": 1,
      "limit": 10,
      "totalPages": 10
    }
  }
}
```

### Error
```json
{
  "success": false,
  "message": "Description of the error"
}
```

---

## Auth Module

**Base path:** `/api/auth`

| Method | Endpoint | Auth Required |
|--------|----------|:---:|
| POST | `/register` | No |
| POST | `/verify-otp` | No |
| POST | `/resend-otp` | No |
| POST | `/login` | No |
| POST | `/forgot-password` | No |
| POST | `/reset-password` | No |
| POST | `/change-password` | Yes |
| GET | `/users` | No |
| DELETE | `/delete/:id` | No |
| POST | `/profile-photo` | Yes |
| PATCH | `/profile-photo` | Yes |
| DELETE | `/profile-photo` | Yes |

---

### POST `/api/auth/register`

Register a new user. An OTP is automatically sent for email verification (valid for 5 minutes).

**Request Body:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "mobile": "9876543210",
  "password": "yourPassword123"
}
```

**Response `201`:**
```json
{
  "success": true,
  "statusCode": 201,
  "message": "User registered successfully",
  "data": {
    "_id": "664f...",
    "username": "john_doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "gender": "",
    "profilePic": {
      "url": "",
      "fileId": "",
      "media_type": "image"
    },
    "bio": "",
    "isVerified": false,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

---

### POST `/api/auth/verify-otp`

Verify email with OTP. Returns a JWT token on success — store this for authenticated requests.

**Request Body:**
```json
{
  "email": "john@example.com",
  "otp": "123456"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "OTP verified successfully",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "_id": "664f...",
      "username": "john_doe",
      "email": "john@example.com",
      "mobile": "9876543210",
      "gender": "",
      "profilePic": {
        "url": "",
        "fileId": "",
        "media_type": "image"
      },
      "bio": "",
      "isVerified": true,
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |
| 400 | User already verified |
| 400 | Invalid OTP |
| 400 | OTP expired |

---

### POST `/api/auth/resend-otp`

Resend OTP to the user's email.

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "OTP resent successfully",
  "data": {
    "otp": "654321"
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |

---

### POST `/api/auth/login`

Login with email and password. Returns a JWT token — store this for authenticated requests.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "yourPassword123"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "_id": "664f...",
      "username": "john_doe",
      "email": "john@example.com",
      "mobile": "9876543210",
      "gender": "",
      "profilePic": {
        "url": "",
        "fileId": "",
        "media_type": "image"
      },
      "bio": "",
      "isVerified": true,
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |
| 400 | Invalid password |

---

### POST `/api/auth/forgot-password`

Triggers an OTP to the user's email for password reset.

**Request Body:**
```json
{
  "email": "john@example.com"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Password reset OTP sent successfully"
}
```

---

### POST `/api/auth/reset-password`

Reset password using the OTP received via email. Call after `forgot-password`.

**Request Body:**
```json
{
  "email": "john@example.com",
  "newPassword": "newPassword123",
  "confirmPassword": "newPassword123"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Password reset successfully"
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |
| 400 | Passwords do not match |

---

### POST `/api/auth/change-password`

Change password while logged in. Requires current password for verification.

**Auth:** Required

**Request Body:**
```json
{
  "oldPassword": "currentPassword123",
  "newPassword": "newPassword456",
  "confirmPassword": "newPassword456"
}
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Password changed successfully"
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |
| 400 | Old password is incorrect |
| 400 | New passwords do not match |

---

### GET `/api/auth/users`

Get paginated list of all users.

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | number | `1` | Page number |
| `limit` | number | `10` | Results per page |

**Example:** `GET /api/auth/users?page=1&limit=20`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Users retrieved successfully",
  "data": {
    "users": [
      {
        "_id": "664f...",
        "username": "john_doe",
        "email": "john@example.com",
        "mobile": "9876543210",
        "gender": "male",
        "profilePic": {
          "url": "",
          "fileId": "",
          "media_type": "image"
        },
        "bio": "",
        "isVerified": true,
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "meta": {
      "total": 50,
      "page": 1,
      "limit": 10,
      "totalPages": 5
    }
  }
}
```

---

### DELETE `/api/auth/delete/:id`

Delete a user by ID.

**Path Params:** `id` — User's `_id`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "User deleted successfully",
  "data": {
    "message": "User deleted successfully"
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | User not found |

---

### POST `/api/auth/profile-photo`

Upload a profile photo for the logged-in user.

**Auth:** Required

**Request Body:** (multipart/form-data)
```
file: [binary image file]
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Profile upload successfully",
  "data": {
    "_id": "664f...",
    "username": "john_doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "gender": "male",
    "profilePic": {
      "url": "https://res.cloudinary.com/...",
      "fileId": "plimpzik/...",
      "media_type": "image"
    },
    "bio": "Full stack developer",
    "isVerified": true,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 400 | No file provided |
| 401 | Unauthorized |

---

### PATCH `/api/auth/profile-photo`

Update the user's profile photo (replaces existing photo).

**Auth:** Required

**Request Body:** (multipart/form-data)
```
file: [binary image file]
```

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Profile upload successfully",
  "data": {
    "_id": "664f...",
    "username": "john_doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "gender": "male",
    "profilePic": {
      "url": "https://res.cloudinary.com/...",
      "fileId": "plimpzik/...",
      "media_type": "image"
    },
    "bio": "Full stack developer",
    "isVerified": true,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 400 | No file provided |
| 401 | Unauthorized |

---

### DELETE `/api/auth/profile-photo`

Delete the user's profile photo.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Profile photo deleted successfully",
  "data": {
    "message": "Profile photo deleted successfully"
  }
}
```

| Status | Reason |
|--------|--------|
| 401 | Unauthorized |
| 404 | Profile photo not found |

---

## Friend Module

**Base path:** `/api/friend`
**All routes require authentication.**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/send-request` | Send a friend request |
| GET | `/requests` | Get incoming friend requests |
| POST | `/request-action/:id` | Accept or reject a request |
| GET | `/` | Get friends list |
| DELETE | `/cancel-request/:id` | Cancel a sent request |
| DELETE | `/unfriend/:id` | Remove a friend |
| GET | `/suggestions` | Get friend suggestions |

---

### POST `/api/friend/send-request`

Send a friend request to another user.

**Auth:** Required

**Request Body:**
```json
{
  "receiverId": "664f..."
}
```

**Response `201`:**
```json
{
  "success": true,
  "statusCode": 201,
  "message": "Friend request sent successfully",
  "data": {
    "_id": "665a...",
    "sender": "664f...",
    "receiver": "664e...",
    "status": "pending",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 400 | Cannot send request to yourself |
| 400 | Already friends |
| 400 | Friend request already pending |

> If a previously rejected request exists, it will automatically be reset to `pending`.

---

### GET `/api/friend/requests`

Get all incoming (pending) friend requests for the logged-in user.

**Auth:** Required

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Friend requests fetched successfully",
  "data": [
    {
      "_id": "665a...",
      "sender": {
        "_id": "664f...",
        "username": "jane_doe",
        "email": "jane@example.com"
      },
      "receiver": "664e...",
      "status": "pending",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  ]
}
```

---

### POST `/api/friend/request-action/:id`

Accept or reject an incoming friend request.

**Auth:** Required

**Path Params:** `id` — Friend request `_id`

**Request Body:**
```json
{
  "action": "accepted"
}
```

> `action` must be either `"accepted"` or `"rejected"`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Friend request accepted successfully",
  "data": {
    "_id": "665a...",
    "sender": "664f...",
    "receiver": "664e...",
    "status": "accepted",
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | Friend request not found |
| 401 | Only the receiver can respond |
| 400 | Already responded to this request |

---

### GET `/api/friend/`

Get the logged-in user's friends list (accepted friendships only).

**Auth:** Required

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | number | `1` | Page number |
| `limit` | number | `10` | Results per page |

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Friends fetched successfully",
  "data": {
    "friends": [
      {
        "_id": "665a...",
        "sender": {
          "_id": "664f...",
          "username": "jane_doe",
          "email": "jane@example.com",
          "mobile": "9876543210",
          "gender": "female",
          "profilePic": {
            "url": "",
            "fileId": "",
            "media_type": "image"
          },
          "bio": ""
        },
        "receiver": "664e...",
        "status": "accepted",
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "meta": {
      "total": 12,
      "page": 1,
      "limit": 10,
      "totalPages": 2
    }
  }
}
```

> The logged-in user may appear as either `sender` or `receiver` in the friendship object.

---

### DELETE `/api/friend/cancel-request/:id`

Cancel a friend request that you sent (only while still pending).

**Auth:** Required

**Path Params:** `id` — Friend request `_id`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Friend request deleted successfully",
  "data": {
    "message": "Friend request deleted successfully"
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | Request not found |
| 401 | Only the sender can cancel |
| 400 | Cannot cancel an already-responded request |

---

### DELETE `/api/friend/unfriend/:id`

Remove an existing friend.

**Auth:** Required

**Path Params:** `id` — The friend's user `_id`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Friend removed successfully",
  "data": {
    "message": "Unfriended successfully"
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | Friendship not found |

---

### GET `/api/friend/suggestions`

Get a list of users the logged-in user might know (excludes current friends and pending requests).

**Auth:** Required

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | number | `1` | Page number |
| `limit` | number | `10` | Results per page |

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Suggestion list fetch successfully",
  "data": {
    "suggetions": [
      {
        "_id": "664c...",
        "username": "alice",
        "gender": "female",
        "profilePic": {
          "url": "",
          "fileId": "",
          "media_type": "image"
        },
        "bio": "Hey there!"
      }
    ],
    "meta": {
      "total": 30,
      "page": 1,
      "limit": 10,
      "totalPages": 3
    }
  }
}
```

> Note: The response key is `suggetions` (typo in API — keep this in your integration).

---

## Chat Module

**Base path:** `/api/chat`
**All routes require authentication.**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/create-room` | Create a chat room with a friend |
| GET | `/rooms` | Get all chat rooms for the logged-in user |

---

## Message Module

**Base path:** `/api/message`
**All routes require authentication.**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/send-message` | Send a message to a chat room |
| GET | `/list/:id` | Get paginated messages from a chat room |
| DELETE | `/:id` | Delete a message (soft delete for user) |

---

### POST `/api/chat/create-room`

Create a 1-on-1 chat room with a friend. If a room already exists between the two users, the existing room is returned.

**Auth:** Required

**Request Body:**
```json
{
  "participantId": "664f..."
}
```

**Response `201`:**
```json
{
  "success": true,
  "statusCode": 201,
  "message": "Chat room created successfully",
  "data": {
    "_id": "666b...",
    "participants": ["664f...", "664e..."],
    "lastMessage": null,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 400 | `participantId` not provided |
| 400 | Cannot create a chat with yourself |
| 403 | You are not friends with this user |

---

### GET `/api/chat/rooms`

Get all chat rooms the logged-in user is part of, sorted with most recent activity first.

**Auth:** Required

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | number | `1` | Page number |
| `limit` | number | `10` | Results per page |

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Chat rooms fetched successfully",
  "data": {
    "chatRooms": [
      {
        "_id": "666b...",
        "participants": [
          {
            "_id": "664f...",
            "username": "john_doe",
            "gender": "male",
            "profilePic": {
              "url": "",
              "fileId": "",
              "media_type": "image"
            }
          },
          {
            "_id": "664e...",
            "username": "jane_doe",
            "gender": "female",
            "profilePic": {
              "url": "",
              "fileId": "",
              "media_type": "image"
            }
          }
        ],
        "lastMessage": {
          "_id": "667c...",
          "sender": {
            "_id": "664f...",
            "username": "john_doe"
          },
          "content": "Hey! What's up?",
          "createdAt": "2024-01-01T12:00:00.000Z"
        },
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T12:00:00.000Z"
      }
    ],
    "meta": {
      "total": 5,
      "page": 1,
      "limit": 10,
      "totalPages": 1
    }
  }
}
```

---

## Message Module

### POST `/api/message/send-message`

Send a message to a chat room. Message is automatically marked as read by the sender.

**Auth:** Required

**Request Body:**
```json
{
  "chatId": "666b...",
  "content": "Hello! How are you?",
  "mediaUrl": "",
  "messageType": "text",
  "replyTo": null
}
```

**Parameters:**
- `chatId` (string, required) — The chat room ID
- `content` (string, optional) — Message text content
- `mediaUrl` (string, optional) — URL to media file (image, video, or file)
- `messageType` (string, required) — Type of message: `"text"` | `"image"` | `"video"` | `"file"`
- `replyTo` (string, optional) — Message ID to reply to (must be in same chat)

> **Validation:** Either `content` or `mediaUrl` must be provided (not both empty)

**Response `201`:**
```json
{
  "success": true,
  "statusCode": 201,
  "message": "Message send successfully",
  "data": {
    "_id": "667d...",
    "chatId": "666b...",
    "sender": "664f...",
    "content": "Hello! How are you?",
    "messageType": "text",
    "mediaUrl": "",
    "replyTo": null,
    "readBy": ["664f..."],
    "isDeleted": false,
    "deletedBy": [],
    "createdAt": "2024-01-01T10:30:00.000Z",
    "updatedAt": "2024-01-01T10:30:00.000Z"
  }
}
```

| Status | Reason |
|--------|--------|
| 400 | Message content or media is required |
| 404 | Chat not found |
| 401 | Unauthorized — user is not a participant |
| 400 | Invalid reply message |

---

### GET `/api/message/list/:id`

Get paginated messages from a specific chat room. Automatically marks messages as read if the recipient is online.

**Auth:** Required

**Path Params:** `id` — Chat room `_id`

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | number | `1` | Page number |
| `limit` | number | `10` | Results per page |

**Example:** `GET /api/message/list/666b...?page=1&limit=20`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Chat retrived successfully",
  "data": {
    "messages": [
      {
        "_id": "667d...",
        "chatId": "666b...",
        "sender": "664f...",
        "content": "Hello! How are you?",
        "messageType": "text",
        "mediaUrl": "",
        "replyTo": {
          "_id": "667c...",
          "sender": "664e...",
          "content": "Hi there!"
        },
        "readBy": ["664f...", "664e..."],
        "isDeleted": false,
        "deletedBy": [],
        "createdAt": "2024-01-01T10:30:00.000Z",
        "updatedAt": "2024-01-01T10:30:00.000Z"
      }
    ],
    "meta": {
      "total": 45,
      "page": 1,
      "limit": 10,
      "totalPages": 5
    }
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | Chat not found |
| 401 | Unauthorized — user is not a participant |

> **Note:** Messages marked as deleted by the current user are excluded from the response.

---

### DELETE `/api/message/:id`

Soft delete a message (marks it as deleted for the current user only).

**Auth:** Required

**Path Params:** `id` — Message `_id`

**Response `200`:**
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Message deleted successfully",
  "data": {
    "message": {
      "_id": "667d...",
      "chatId": "666b...",
      "sender": "664f...",
      "content": "Hello! How are you?",
      "messageType": "text",
      "mediaUrl": "",
      "replyTo": null,
      "readBy": ["664f...", "664e..."],
      "isDeleted": false,
      "deletedBy": ["664f..."],
      "createdAt": "2024-01-01T10:30:00.000Z",
      "updatedAt": "2024-01-01T10:30:00.000Z"
    }
  }
}
```

| Status | Reason |
|--------|--------|
| 404 | Message not found |

> **Note:** This is a soft delete — the message is only hidden for the user who deleted it. Other participants can still see it, and the message remains in the database.

---

## Real-time Events (Socket.IO)

All socket connections require authentication via a JWT token passed in the handshake auth.

**Connection Setup:**
```javascript
const socket = io("http://localhost:5000", {
  auth: {
    token: "your_jwt_token"
  }
});
```

### Client-to-Server Events

#### `join_chat`
Join a specific chat room to receive live messages and updates.

**Emit:**
```javascript
socket.emit("join_chat", "chatId");
```

**Parameters:**
- `chatId` (string) — The room ID to join

---

#### `leave_chat`
Leave a chat room.

**Emit:**
```javascript
socket.emit("leave_chat", "chatId");
```

**Parameters:**
- `chatId` (string) — The room ID to leave

---

#### `mark_read`
Mark all messages in a chat as read.

**Emit:**
```javascript
socket.emit("mark_read", "chatId");
```

**Parameters:**
- `chatId` (string) — The chat room ID

**Server Response:**
All other users in the room will receive:
```json
{
  "chatId": "666b...",
  "userId": "664f..."
}
```

---

#### `typing`
Notify others that you are typing.

**Emit:**
```javascript
socket.emit("typing", "chatId");
```

**Parameters:**
- `chatId` (string) — The chat room ID

---

#### `stop_typing`
Notify others that you stopped typing.

**Emit:**
```javascript
socket.emit("stop_typing", "chatId");
```

**Parameters:**
- `chatId` (string) — The chat room ID

---

### Server-to-Client Events

#### `new_message`
Broadcast when a new message is sent to the chat room.

**Payload:**
```json
{
  "_id": "667c...",
  "chatId": "666b...",
  "sender": "664f...",
  "content": "Hello there!",
  "messageType": "text",
  "mediaUrl": "",
  "replyTo": null,
  "readBy": ["664f...", "664e..."],
  "isDeleted": false,
  "deletedBy": [],
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

---

#### `message_delievered`
Emitted to the sender when their message is successfully delivered and read by the recipient (if recipient is in the chat).

**Payload:**
Same as `new_message`

---

#### `messages_read`
Emitted to all users in the chat when someone marks messages as read.

**Payload:**
```json
{
  "chatId": "666b...",
  "userId": "664f..."
}
```

---

#### `typing`
Emitted to all users in the chat when someone starts typing.

**Payload:**
```json
{
  "userId": "664f..."
}
```

---

#### `stop_typing`
Emitted to all users in the chat when someone stops typing.

**Payload:**
```json
{
  "userId": "664f..."
}
```

---

#### `chat_list_update`
Emitted to both participants when a message is sent (to update chat list with latest message).

**Payload:**
```json
{
  "chatId": "666b...",
  "lastMessage": "Hello there!",
  "unreadCount": 2
}
```

---

## Data Models

### User
| Field | Type | Notes |
|-------|------|-------|
| `_id` | string | MongoDB ObjectId |
| `username` | string | |
| `email` | string | Unique |
| `mobile` | string | |
| `gender` | string | Default `""` |
| `profilePic` | object | Default `{ url: "", fileId: "", media_type: "image" }` |
| `profilePic.url` | string | Cloudinary image URL |
| `profilePic.fileId` | string | Cloudinary file ID |
| `profilePic.media_type` | string | Media type, default `"image"` |
| `bio` | string | Default `""` |
| `isVerified` | boolean | Default `false` |
| `createdAt` | date | |
| `updatedAt` | date | |

> `password`, `otp`, and `otpExpiry` are never included in responses.

### Friend Request
| Field | Type | Notes |
|-------|------|-------|
| `_id` | string | MongoDB ObjectId |
| `sender` | string / object | User ObjectId, populated in some responses |
| `receiver` | string / object | User ObjectId, populated in some responses |
| `status` | string | `"pending"` \| `"accepted"` \| `"rejected"` |
| `createdAt` | date | |
| `updatedAt` | date | |

### Chat Room
| Field | Type | Notes |
|-------|------|-------|
| `_id` | string | MongoDB ObjectId |
| `participants` | string[] / object[] | Array of User ObjectIds, populated in list responses |
| `lastMessage` | string / object | Message ObjectId, populated in list responses |
| `createdAt` | date | |
| `updatedAt` | date | |

### Message (Schema — endpoints coming soon)
| Field | Type | Notes |
|-------|------|-------|
| `_id` | string | MongoDB ObjectId |
| `chatId` | string | Ref: Chat |
| `sender` | string | Ref: User |
| `content` | string | |
| `messageType` | string | `"text"` \| `"image"` \| `"video"` \| `"file"` |
| `mediaUrl` | string | Default `""` |
| `replyTo` | string | Ref: Message, optional |
| `isDeleted` | boolean | Default `false` |
| `seen` | boolean | Default `false` |
| `createdAt` | date | |
| `updatedAt` | date | |

---

## Error Codes

| HTTP Status | Meaning |
|-------------|---------|
| `200` | OK |
| `201` | Created |
| `400` | Bad Request — check your request body/params |
| `401` | Unauthorized — missing or invalid token |
| `403` | Forbidden — you don't have permission |
| `404` | Not Found — resource doesn't exist |
| `500` | Internal Server Error |

---

*Last updated: 10 April 2026*
