const db = require('../config/db.config');
const bcrypt = require('bcrypt');

// Thêm người dùng mới
exports.add = async (req, res, next) => {
  const { username, email, password, phone, name, address, gender } = req.body;

  try {
    // Kiểm tra xem username đã tồn tại
    const checkUsernameSql = `SELECT * FROM Users WHERE username = ?`;
    const [usernameResult] = await db.pool.execute(checkUsernameSql, [username]);

    // Kiểm tra xem email đã tồn tại
    const checkEmailSql = `SELECT * FROM Users WHERE email = ?`;
    const [emailResult] = await db.pool.execute(checkEmailSql, [email]);

    if (usernameResult.length > 0) {
      return res.status(400).json({ error: "Tên người dùng đã tồn tại!" });
    }

    if (emailResult.length > 0) {
      return res.status(400).json({ error: "Email đã được đăng ký!" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const sql = `
      INSERT INTO Users (username, email, role, password, phone, name, address, gender, createdAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
    `;
    const userData = [
      username,
      email,
      'khách hàng',
      hashedPassword,
      phone || null, 
      name || null,
      address || null,
      gender || null 
    ];

    const [result] = await db.pool.execute(sql, userData);

    res.status(201).json({ message: "Thêm mới khách hàng thành công!", userId: result.insertId });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Lấy tất cả người dùng
exports.getAllUsers = async (req, res, next) => {
  try {
    const sql = `SELECT * FROM Users`;
    const [users] = await db.pool.execute(sql);
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
// Lấy tất cả người dùng
exports.getAllUsersBasic = async (req, res, next) => {
  try {
    const sql = `SELECT id, username, name, phone FROM Users`;
    const [users] = await db.pool.execute(sql);
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Lấy thông tin người dùng theo ID
exports.getUserById = async (req, res, next) => {
  const { id } = req.params;

  try {
    const sql = `SELECT * FROM Users WHERE id = ?`;
    const [rows] = await db.pool.execute(sql, [id]);  // Thay đổi ở đây
    const user = rows[0];

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Cập nhật thông tin người dùng
exports.updateUser = async (req, res, next) => {
  const { id } = req.params;
  const { name, phone, address, gender, note } = req.body;

  // Kiểm tra nếu id là 1
  if (id === '1') {
    return res.status(403).json({ error: "Thông tin người dùng này là cố định - không thể thay đổi" });
  }

  try {
    const sql = `UPDATE Users SET name = ?, phone = ?, address = ?, gender = ?, note = ? WHERE id = ?`;
    await db.pool.execute(sql, [name, phone, address, gender, note, id]);

    res.json({ message: "User updated successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Xóa người dùng
exports.deleteUser = async (req, res, next) => {
  const { id } = req.params;

  // Kiểm tra nếu id là 1
  if (id === '1') {
    return res.status(403).json({ error: "Không thể xóa người dùng quản trị viên này!" });
  }

  try {
    const sql = `DELETE FROM Users WHERE id = ?`;
    await db.pool.execute(sql, [id]);

    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Tìm kiếm người dùng theo tên, số điện thoại, địa chỉ, ID
exports.search = async (req, res, next) => {
  const { query } = req.body;

  try {
    const sql = `
      SELECT * FROM Users 
      WHERE username LIKE ? OR phone LIKE ? OR address LIKE ? OR id LIKE ?
    `;
    const [users] = await db.pool.execute(sql, [`%${query}%`, `%${query}%`, `%${query}%`, `%${query}%`]);  // Thay đổi ở đây

    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Lọc thông tin theo Role
exports.filter = async (req, res, next) => {
  const { role } = req.body;

  try {
    const sql = `SELECT * FROM Users WHERE role = ?`;
    const [users] = await db.pool.execute(sql, [role]);  // Thay đổi ở đây

    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
