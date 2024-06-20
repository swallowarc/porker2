# Data store design

* LT: Life Time

## User session

### Login

| Description      | Type   | Key               | Value     | Note    |
|------------------|--------|-------------------|-----------|---------|
| **access token** | String | token:(token)     | user_id   | LT: 60m |
| **user name**    | String | user_id:(user_id) | user_name | LT: 60m |

- Lifetime is re-set each time a user requests an RPC.

### CreateRoom

| Description        | Type   | Key                   | Value               | Note   |
|--------------------|--------|-----------------------|---------------------|--------|
| **room members**   | String | room_id:(room_id)     | (Empty)             | LT:60m |
| **room condition** | String | room_stream:(room_id) | room_condition{...} | LT:60m |

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "",
  "vote_state": 1,
  "ballots": []
}
```

- vote_state: 1 (hide), 2 (open)

## Poker room

### JoinRoom

#### Join 1st user

| Description        | Type   | Key                   | Value               | Note            |
|--------------------|--------|-----------------------|---------------------|-----------------|
| **room members**   | Set    | room_id:(room_id)     | {user_id_1}         | LT:60m (re-set) |
| **room condition** | Stream | room_stream:(room_id) | room_condition{...} | LT:60m (re-set) |

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",  // changed
  "vote_state": 1,
  "ballots": [
    // join
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 0
    }
  ]
}
```
- admin_user_id: first joined user
- point: 0 (not voted), 1, 2, 3 ...

#### Join 2nd user

| Description        | Type   | Key                   | Value                  | Note            |
|--------------------|--------|-----------------------|------------------------|-----------------|
| **room members**   | Set    | room_id:(room_id)     | {user_id_1, user_id_2} | LT:60m (re-set) |
| **room condition** | Stream | room_stream:(room_id) | room_condition{...}    | LT:60m (re-set) |

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",
  "vote_state": 1,
  "ballots": [
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 0
    },
    // join
    {
        "user_id": "user_id_2",
        "user_name": "user_name_2",
        "point": 0
    }
  ]
}
```

### CastVote

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",
  "vote_state": 1,
  "ballots": [
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 2  // changed
    },
    {
        "user_id": "user_id_2",
        "user_name": "user_name_2",
        "point": 3  // changed
    }
  ]
}
```

### ShowVotes

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",
  "vote_state": 2,  // changed
  "ballots": [
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 2
    },
    {
        "user_id": "user_id_2",
        "user_name": "user_name_2",
        "point": 3
    }
  ]
}
```

### ResetVotes

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",
  "vote_state": 1,  // changed
  "ballots": [
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 0  // changed
    },
    {
        "user_id": "user_id_2",
        "user_name": "user_name_2",
        "point": 0  // changed
    }
  ]
}
```

### KickUser

| Description        | Type   | Key                   | Value               | Note            |
|--------------------|--------|-----------------------|---------------------|-----------------|
| **room members**   | Set    | room_id:(room_id)     | {user_id_1}         | LT:60m (re-set) |
| **room condition** | Stream | room_stream:(room_id) | room_condition{...} | LT:60m (re-set) |

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "user_id_1",
  "vote_state": 1,
  "ballots": [
    {
        "user_id": "user_id_1",
        "user_name": "user_name_1",
        "point": 0
    },
    // kicked
  ]
}
```

### LeaveRoom

| Description        | Type   | Key                   | Value               | Note            |
|--------------------|--------|-----------------------|---------------------|-----------------|
| **room members**   | Set    | room_id:(room_id)     | {}                  | LT: (no update) |
| **room condition** | Stream | room_stream:(room_id) | room_condition{...} | LT: (no update) |

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "",
  "vote_state": 1,
  "ballots": []
}
```

- Automatic deletion after 60 minutes of no access.
