const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');

exports.createCategory = async (req, res, next) => { 
    const { id } = req.params; // id_user
    const { name, type } = req.body;

    try {
        // Kiểm tra xem danh mục đã tồn tại chưa
        const [existingCategory] = await db.pool.execute(
            `SELECT * FROM categorys WHERE name = ? AND id_user = ?`, [name, id]
        );

        if (existingCategory.length > 0) {
            // Nếu đã có danh mục trùng lặp
            return res.status(400).json({
                code: 400,
                message: 'Category with this name already exists for the user.',
            });
        }

        // Nếu chưa tồn tại, thêm danh mục mới
        const [result] = await db.pool.execute(
            `INSERT INTO categorys (name, type, id_user) VALUES (?, ?, ?)`, [name, type, id]
        );

        res.status(200).json({
            code: 200,
            data: {
                id: result.insertId,
                name: name,
                type: type,
                id_user: id,
            },
            message: 'Category created successfully',
        });
    } catch (error) {
        console.error('Error in createCategory function:', error);
        res.status(500).json({
            code: 500,
            message: 'Internal Server Error',
            error: error.message,
        });
    }
};


exports.updateCategory = async (req, res, next) => {
    const { id } = req.params; // id của danh mục cần cập nhật
    const { idUser, name, type } = req.body;

    try {
        // Kiểm tra xem danh mục có tồn tại hay không
        const [existingCategory] = await db.pool.execute(
            `SELECT * FROM categorys WHERE id = ?`, [id]
        );

        if (existingCategory.length === 0) {
            return res.status(404).json({
                code: 404,
                message: 'Category not found',
            });
        }

        // Kiểm tra xem có danh mục trùng tên khác không (trùng name và idUser nhưng khác id)
        const [duplicateCategory] = await db.pool.execute(
            `SELECT * FROM categorys WHERE name = ? AND id_user = ? AND id != ?`, [name, idUser, id]
        );

        if (duplicateCategory.length > 0) {
            return res.status(400).json({
                code: 400,
                message: 'A category with the same name already exists for this user.',
            });
        }

        // Thực hiện cập nhật danh mục
        const [result] = await db.pool.execute(
            `UPDATE categorys SET name = ?, type = ? WHERE id = ?`, [name, type, id]
        );

        if (result.affectedRows === 0) {
            return res.status(400).json({
                code: 400,
                message: 'Update failed. No rows affected.',
            });
        }

        res.status(200).json({
            code: 200,
            message: 'Category updated successfully',
            data: {
                id: id,
                name,
                type,
                id_user: idUser,
            },
        });
    } catch (error) {
        console.error('Error in updateCategory function:', error);
        res.status(500).json({
            code: 500,
            message: 'Internal Server Error',
            error: error.message,
        });
    }
};


exports.deleteCategory = async (req, res, next) => { 
    const { id } = req.params;
    try {
        const [rows] = await db.pool.execute(
            `DELETE FROM categorys WHERE id = ?`, [id]
        );
        res.status(HTTP_STATUS.OK).json({
            code: 200,
            status: 'success',
            message: 'Category deleted successfully'
        });
    } catch (error) {
        console.error('Error in deleteCategory function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}
exports.getCategoryByUserId = async (req, res, next) => {
    const { id } = req.params;

    try {
        // Truy vấn danh sách danh mục và số lượng giao dịch cho mỗi danh mục
        const [rows] = await db.pool.execute(
            `SELECT c.id, c.name, c.type, c.id_user, COUNT(t.id) AS transaction_count
             FROM categorys c
             LEFT JOIN transactions t ON c.id = t.category
             WHERE c.id_user = ?
             GROUP BY c.id`, [id]
        );

        // Đếm tổng số danh mục
        const [countResult] = await db.pool.execute(
            `SELECT COUNT(*) as totalDocs FROM categorys WHERE id_user = ?`, [id]
        );

        const totalDocs = countResult[0]?.totalDocs || 0;

        res.status(200).json({
            code: 200,
            message: 'Categories retrieved successfully with transaction count',
            totalDocs,
            data: rows,
        });
    } catch (error) {
        console.error('Error in getCategoryByUserId function:', error);
        res.status(500).json({
            code: 500,
            message: 'Internal Server Error',
            error: error.message,
        });
    }
};



exports.getCategoryByTypeWithUserId = async (req, res, next) => { 
    const { id } = req.params; // id của user
    const { type } = req.body; // Loại category

    try {
        // Truy vấn danh sách danh mục theo id_user và type
        const [rows] = await db.pool.execute(
            `SELECT * FROM categorys WHERE id_user = ? AND type = ?`, [id, type]
        );

        // Truy vấn tổng số danh mục phù hợp
        const [countResult] = await db.pool.execute(
            `SELECT COUNT(*) as totalDocs FROM categorys WHERE id_user = ? AND type = ?`, [id, type]
        );

        const totalDocs = countResult[0]?.totalDocs || 0;

        // Trả về phản hồi thành công
        res.status(200).json({
            code: 200,
            message: 'Get Category By Type With User Id successfully',
            totalDocs,
            data: rows,
        });
    } catch (error) {
        console.error('Error in getCategoryByTypeWithUserId function:', error);
        res.status(500).json({
            code: 500,
            message: 'Internal Server Error',
            error: error.message,
        });
    }
};

