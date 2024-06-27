# Data store design

* LT: Life Time

## User session

### Login

| Description      | Type   | Key                   | Value                       | Note    |
|------------------|--------|-----------------------|-----------------------------|---------|
| **access token** | String | token:(token)         | user_id                     | LT: 60m |
| **user by id**   | String | user_id:(user_id)     | {user_id, user_name, token} | LT: 60m |
| **user name**    | String | user_name:(user_name) | {user_id}                   | LT: 60m |

- Lifetime はユーザーがRPCをコールするたびにリセットする. (60m 無操作でセッション削除)
- user id by name はユーザ名の重複チェック用

### CreateRoom

| Description        | Type   | Key                      | Value               | Note   |
|--------------------|--------|--------------------------|---------------------|--------|
| **room condition** | Stream | room_condition:(room_id) | room_condition{...} | LT:60m |

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

| Description        | Type   | Key                      | Stream message key     | Value               | Note            |
|--------------------|--------|--------------------------|------------------------|---------------------|-----------------|
| **room condition** | Stream | room_condition:(room_id) | room_condition_message | room_condition{...} | LT:60m (re-set) |

- RoomのLifetime は退室以外の操作がRoomに行われるたびにリセットする. (60m 無操作でRoom削除)

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
- admin_user_id: 管理者ID(最初に入室したユーザのID)
- point: 0 (not voted), 1, 2, 3 ...

#### Join 2nd user

- (user_infoは記載省略するがuser_id_1の入室時と同様に処理)

| Description        | Type   | Key                      | Stream message key     | Value               | Note            |
|--------------------|--------|--------------------------|------------------------|---------------------|-----------------|
| **room condition** | Stream | room_condition:(room_id) | room_condition_message | room_condition{...} | LT:60m (re-set) |

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

同タイミングで複数のユーザが投票する場合、競合が発生する可能性があるため、Lock用のキーを用意する。
SETXでLockし、Streamの読み込み&Publish後にLockを解除する。

| Description        | Type   | Key                      | Stream message key     | Value               | Note                     |
|--------------------|--------|--------------------------|------------------------|---------------------|--------------------------|
| **room condition** | Stream | room_condition:(room_id) | room_condition_message | room_condition{...} | LT:60m (re-set)          |
| **room lock**      | String | room_lock:(room_id)      | -                      | (Empty)             | LT:5s Streamにpublish後に削除 |

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

| Description        | Type   | Key                      | Stream message key     | Value               | Note            |
|--------------------|--------|--------------------------|------------------------|---------------------|-----------------|
| **room condition** | Stream | room_condition:(room_id) | room_condition_message | room_condition{...} | LT:60m (re-set) |

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

| Description        | Type   | Key                      | Stream message key     | Value               | Note            |
|--------------------|--------|--------------------------|------------------------|---------------------|-----------------|
| **room condition** | Stream | room_condition:(room_id) | room_condition_message | room_condition{...} | LT: (no update) |

- room conditionからも自分の情報を削除する.

```json
// room condition
{
  "room_id": "12345",
  "admin_user_id": "",
  "vote_state": 1,
  "ballots": []
}
```
