const bcrypt = require('bcrypt');
// const User = require('../models/user.model');
const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');

exports.login = async (req, res, next) => {
  const { username, email, password } = req.body;

  try {
    const [rows] = await db.pool.execute(
      'SELECT * FROM users WHERE username = ? AND email = ? LIMIT 1',
      [username, email]
    );

    if (rows.length === 0) {
      return next(new AppError(HTTP_STATUS.NOT_FOUND, 'failed', 'Không tìm thấy người dùng', []), req, res, next);
    }

    const user = rows[0];

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: 'Mật khẩu không chính xác' });
    }

    // Cập nhật trạng thái
    await db.pool.execute(
      'UPDATE users SET status = ? WHERE id = ?',
      ['online', user.id]
    );

    req.session.user = { id: user.id, name: user.name, role: user.role };

    res.status(200).json({
      status: 'success',
      data: {
        id: user.id,
        username: user.username,
        name: user.name,
        email: user.email,
        status: user.status,
        // role: user.role,
        phone: user.phone,
        gender: user.gender,
        bio: user.bio,
        address: user.address,
        updatedAt: user.updated_at,
      },
      message: 'Đăng nhập thành công',
    });
  } catch (error) {
    console.error('Error in login function:', error);
    res.status(500).json({ error: error.message });
  }
};
