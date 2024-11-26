// middleware.js

// Middleware xác thực quyền truy cập dựa trên vai trò
exports.authorizeRole = (role) => {
  return (req, res, next) => {
    try {
      if (req.session.user && req.session.user.role === role) {
        next();
      } else {
        res.status(403).json({ message: "Access forbidden: Insufficient rights" });
      }
    } catch (error) {
      console.error("Error in authorizeRole middleware:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  };
};

// Middleware xác thực token
exports.authenticate = (req, res, next) => {
  try {
    const token = req.headers['authorization'];
    if (token === process.env.SECRET_TOKEN) {
      next();
    } else {
      res.status(403).json({ error: 'Unauthorized access' });
    }
  } catch (error) {
    console.error("Error in authenticate middleware:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Middleware kiểm tra đăng nhập
exports.loginRequired = (req, res, next) => {
  if (req.session && req.session.user) {
    return next();
  } else {
    return res.status(401).json({ message: "Login required" });
  }
};
