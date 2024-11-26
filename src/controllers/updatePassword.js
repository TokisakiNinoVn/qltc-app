const bcrypt = require("bcrypt");
const User = require("./user.model"); // Đảm bảo đường dẫn đúng

async function updatePassword(userId) {
  const plainPassword = "admin1234"; // mật khẩu ban đầu
  const saltRounds = 10; // số rounds để tạo muối

  try {
    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(plainPassword, saltRounds);

    // Cập nhật mật khẩu đã mã hóa vào cơ sở dữ liệu
    await User.update({ password: hashedPassword }, { where: { id: userId } });
    console.log("Mật khẩu đã được cập nhật thành công.");
  } catch (error) {
    console.error("Lỗi khi cập nhật mật khẩu:", error);
  }
}

// Gọi hàm với `userId` của người dùng cần cập nhật
updatePassword(14); // ví dụ `userId` là 1
