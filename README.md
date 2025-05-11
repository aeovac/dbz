# dbz
Simple database

Run it in memory or localy !

```zig
const connection = dbz.Client{
  .allocator = gpa.allocator()
  .preset = "model.dbz"
};

defer connection.save("model.dbz"):
defer connection.close();
defer connection.deinit();

const User = struct {
  userID: []const u8
}

const users = try connection.createTable("users");

users.get("userID"); // -> "msgpack"
users.put("userID", ...);

connection.get(users, "userID");
```
