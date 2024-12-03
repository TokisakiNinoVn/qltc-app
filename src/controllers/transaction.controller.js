const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');

exports.getByUserId = async (req, res, next) => { 
    const { id } = req.params;
    try {
        // Query to get transactions and category names
        const [rows] = await db.pool.execute(
            `SELECT t.*, c.name AS category_name 
            FROM transactions t
            JOIN categorys c ON t.category = c.id
            WHERE t.id_user = ?`, [id]
        );

        // Query to count total transactions for the user
        const [[{ total }]] = await db.pool.execute(
            `SELECT COUNT(*) AS total 
            FROM transactions 
            WHERE id_user = ?`, [id]
        );

        // Respond with both transactions and total count
        res.status(HTTP_STATUS.OK).json({ data: rows, total });
    } catch (error) {
        console.error('Error in getByUserId function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}

exports.getTransactionById = async (req, res, next) => { 
    const { id } = req.params;
    try {
        const [rows] = await db.pool.execute(
            `SELECT t.*, c.name AS category_name 
            FROM transactions t
            JOIN categorys c ON t.category = c.id
            WHERE t.id = ?`, [id]
        );
        if (rows.length === 0) {
            return res.status(HTTP_STATUS.NOT_FOUND).json({ message: 'Transaction not found' });
        }
        res.status(HTTP_STATUS.OK).json({ data: rows[0] });
    } catch (error) {
        console.error('Error in getTransactionById function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}

exports.createTransaction = async (req, res, next) => {
    let { amount, title, category, userId } = req.body;

    // Replace undefined values with null
    amount = amount === undefined ? null : amount;
    title = title === undefined ? null : title;
    category = category === undefined ? null : category;
    userId = userId === undefined ? null : userId;

    const createAt = new Date();
    const transaction = [amount, title, category, userId, createAt];

    try {
        const [result] = await db.pool.execute(
            'INSERT INTO transactions (amount, title, category, id_user, createAt) VALUES (?, ?, ?, ?, ?)', 
            transaction
        );
        
        const statusCode = HTTP_STATUS.CREATED || 200; // Ensure status code is defined
        res.status(statusCode).json({ data: { id: result.insertId, amount, title, category, user_id: userId, createAt } });
    } catch (error) {
        console.error('Error in createTransaction function:', error);
        const statusCode = HTTP_STATUS.INTERNAL_SERVER_ERROR || 500; // Ensure status code is defined
        res.status(statusCode).json({ error: error.message });
    }
};

exports.updateTransaction = async (req, res, next) => { 
    const { id } = req.params;
    const { amount, title, category } = req.body;

    // Prepare the transaction object
    const transaction = {};
    if (amount !== undefined) transaction.amount = amount;
    if (title !== undefined) transaction.title = title;
    if (category !== undefined) transaction.category = category;

    // Check if there's anything to update
    if (Object.keys(transaction).length === 0) {
        return res.status(HTTP_STATUS.BAD_REQUEST).json({ message: 'No fields to update' });
    }

    try {
        // Construct the SQL query
        const updates = Object.keys(transaction).map(key => `${key} = ?`).join(', ');
        const values = Object.values(transaction);
        
        const [result] = await db.pool.execute(`UPDATE transactions SET ${updates} WHERE id = ?`, [...values, id]);

        if (result.affectedRows === 0) {
            return res.status(HTTP_STATUS.NOT_FOUND).json({ message: 'Transaction not found' });
        }

        res.status(HTTP_STATUS.OK).json({
            status: 'success',
            data: { id, ...transaction }
        });
    } catch (error) {
        console.error('Error in updateTransaction function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}


exports.deleteTransaction = async (req, res, next) => { 
    const { id } = req.params;
    try {
        const [result] = await db.pool.execute('DELETE FROM transactions WHERE id = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(HTTP_STATUS.NOT_FOUND).json({ message: 'Transaction not found' });
        }
        res.status(HTTP_STATUS.OK).json({
            status: 'success',
            message: `Transaction with id ${id} has been deleted`
        });
    } catch (error) {
        console.error('Error in deleteTransaction function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}

exports.getTransactionsByCategory = async (req, res, next) => { 
    // const {  } = req.params; // id của category
    const { id, idUser } = req.body; // id của user
    
    try {
        const [rows] = await db.pool.execute(
            `SELECT * FROM transactions WHERE category = ? AND id_user = ?`, [id, idUser]
        );

        const [[total]] = await db.pool.execute(
            `SELECT COUNT(*) AS total FROM transactions WHERE category = ? AND id_user = ?`, [id, idUser]
        );
        res.status(HTTP_STATUS.OK).json({
            code: 200,
            status: 'success',
            total: total.total,
            data: rows,
        });
    } catch (error) {
        console.error('Error in getTransactionsByCategory function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
}

exports.getTransactionByMonthOfUser = async (req, res, next) => { 
    const { id, month } = req.body;

    try {
       // Lấy danh sách giao dịch và thông tin danh mục
        const [transactions] = await db.pool.execute(
            `SELECT t.*, c.name AS categoryName, c.type AS categoryType 
            FROM transactions t
            LEFT JOIN categorys c ON t.category = c.id AND (c.id_user IS NULL OR c.id_user = t.id_user)
            WHERE t.id_user = ? AND MONTH(t.createAt) = ?`, 
            [id, month]
        );
        // console.log('transactions:', typeof transactions);

        // Lấy tổng số giao dịch
        const [countResult] = await db.pool.execute(
            `SELECT COUNT(*) AS totalDocs 
            FROM transactions 
            WHERE id_user = ? AND MONTH(createAt) = ?`, 
            [id, month]
        );

        const totalDocs = countResult[0]?.totalDocs || 0;

        // Trả về kết quả
        res.status(HTTP_STATUS.OK).json({
            code: 200,
            status: 'success',
            totalDocs,
            data: transactions,
        });
    } catch (error) {
        console.error('Error in getTransactionByMonthOfUser function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
};



// exports.getByMonthWithUserId = async (req, res, next) => { 
//     const { userId, month } = req.params;
//     try {
//         const [rows] = await db.pool.execute(
//             `SELECT t.*, c.name AS category_name 
//             FROM transactions t
//             JOIN categorys c ON t.category = c.id
//             WHERE t.id_user = ? AND MONTH(t.createAt) = ?`, [userId, month]
//         );
//         res.status(HTTP_STATUS.OK).json({ data: rows });
//     } catch (error) {
//         console.error('Error in getByMonthWithUserId function:', error);
//         res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
//     }
// }

// exports.getByTypeWithUserId = async (req, res, next) => { 
//     const { userId } = req.params;
//     const { type } = req.body;
//     try {
//         const [rows] = await db.pool.execute(
//             `SELECT t.*, c.name AS category_name 
//             FROM transactions t
//             JOIN categorys c ON t.category = c.id
//             WHERE t.id_user = ? AND c.type = ?`, [userId, type]
//         );
//         res.status(HTTP_STATUS.OK).json({ data: rows });
//     } catch (error) {
//         console.error('Error in getByTypeWithUserId function:', error);
//         res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
//     }
// }

// exports.getByCategoryWithUserId = async (req, res, next) => { 
//     const { userId, category } = req.body;
//     try {
//         const [rows] = await db.pool.execute(
//             `SELECT t.*, c.name AS category_name 
//             FROM transactions t
//             JOIN categorys c ON t.category = c.id
//             WHERE t.id_user = ? AND c.name = ?`, [userId, category]
//         );
//         res.status(HTTP_STATUS.OK).json({ data: rows });
//     } catch (error) {
//         console.error('Error in getByCategoryWithUserId function:', error);
//         res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
//     }
// }


