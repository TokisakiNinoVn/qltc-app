const db = require('../config/db.config');
const bcrypt = require('bcrypt');

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

    res.status(200).json({
      status: 'success',
      data: {
        id: user.id,
        username: user.username,
        name: user.name,
        email: user.email,
        verify: user.verify,
        phone: user.phone,
        gender: user.gender,
        updatedAt: user.updated_at,
      },
      message: 'Đăng nhập thành công',
    });

    // res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Cập nhật thông tin người dùng
exports.update = async (req, res, next) => {
  const { id } = req.params;
  const { name, username, email, gender } = req.body;

  // Kiểm tra nếu id là 1
  // if (id === '1') {
  //   return res.status(403).json({
  //     error: "Thông tin người dùng này là cố định - không thể thay đổi",
  //   });
  // }

  try {
    // Kiểm tra xem có người dùng với id được cung cấp hay không
    const [user] = await db.pool.execute(`SELECT * FROM Users WHERE id = ?`, [id]);
    if (user.length === 0) {
      return res.status(404).json({ error: "Người dùng không tồn tại" });
    }

    // Cập nhật thông tin người dùng
    const sql = `
      UPDATE Users 
      SET name = ?, username = ?, email = ?, gender = ?, updatedAt = NOW()
      WHERE id = ?`;
    await db.pool.execute(sql, [name, username, email, gender, id]);

    res.json({ message: "Cập nhật thông tin người dùng thành công" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


// Xóa người dùng
exports.delete = async (req, res, next) => {
  const { id } = req.params;

  // Kiểm tra nếu id là 1
  if (id === '1') {
    return res.status(403).json({ error: "Không thể xóa người dùng quản trị viên này!" });
  }

  let connection;

  try {
    // Lấy một kết nối cụ thể từ pool
    connection = await db.pool.getConnection();

    // Bắt đầu transaction
    await connection.beginTransaction();

    // Xóa các bản ghi liên quan trong bảng transactions
    const deleteTransactionsSql = `DELETE FROM transactions WHERE id_user = ?`;
    await connection.execute(deleteTransactionsSql, [id]);

    // Xóa người dùng trong bảng users
    const deleteUserSql = `DELETE FROM users WHERE id = ?`;
    await connection.execute(deleteUserSql, [id]);

    // Commit transaction
    await connection.commit();

    res.json({
      status: "success",
      message: "User and related transactions deleted successfully"
    });
  } catch (error) {
    if (connection) {
      // Rollback transaction nếu xảy ra lỗi
      await connection.rollback();
    }
    res.status(500).json({ error: error.message });
  } finally {
    if (connection) {
      // Giải phóng kết nối trở lại pool
      connection.release();
    }
  }
};
