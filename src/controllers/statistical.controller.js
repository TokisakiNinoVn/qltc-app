const { HTTP_STATUS } = require('../constants/status-code.js');
const AppError = require('../utils/app-error.js');
const db = require('../config/db.config');

// Statistical functions
exports.getStatisticalOfMonth = async (req, res, next) => {
    const { id, month } = req.body; // id is the user ID provided
    try {
       // Get total money, total income, and total money out from transactions
        const [totalMoneyRows] = await db.pool.execute(
            `
            SELECT 
                SUM(amount) AS totalMoney,
                SUM(CASE WHEN c.type = 'Thu' AND amount > 0 THEN amount ELSE 0 END) AS totalIncome,
                SUM(CASE WHEN c.type = 'Chi' THEN amount ELSE 0 END) AS totalMoneyOut
            FROM transactions t
            JOIN categorys c ON t.category = c.id
            WHERE t.id_user = ? AND MONTH(t.createAt) = ?
            `,
            [id, month]
        );




        // Get the total number of transactions, total "Thu" and total "Chi" based on category type
        const [categoryCountRows] = await db.pool.execute(
            `
            SELECT 
                COUNT(CASE WHEN c.type = 'Thu' THEN 1 END) AS totalThu,
                COUNT(CASE WHEN c.type = 'Chi' THEN 1 END) AS totalChi,
                COUNT(*) AS totalTransaction
            FROM transactions t
            JOIN categorys c ON t.category = c.id
            WHERE t.id_user = ? AND MONTH(t.createAt) = ?
            `,
            [id, month]
        );

        // Get category-wise statistics (total money and total transaction count for each category)
        const [categoryRows] = await db.pool.execute(
            `
            SELECT 
                c.type AS typeCategory,
                c.name AS categoryName,
                SUM(t.amount) AS totalCategoryMoney,
                COUNT(t.id) AS totalCategoryType
            FROM transactions t
            JOIN categorys c ON t.category = c.id
            WHERE t.id_user = ? AND MONTH(t.createAt) = ?
            GROUP BY c.id, c.type, c.name
            `,
            [id, month]
        );

        // Prepare the response data
        const totalMoney = totalMoneyRows[0].totalMoney || 0;
        const totalIncome = totalMoneyRows[0].totalIncome || 0;
        const totalMoneyOut = totalMoneyRows[0].totalMoneyOut || 0;
        const totalChi = categoryCountRows[0].totalChi || 0;  // Total number of "Chi" transactions
        const totalThu = categoryCountRows[0].totalThu || 0;  // Total number of "Thu" transactions
        const totalTransaction = categoryCountRows[0].totalTransaction || 0;

        // Separate category types and aggregate data
        const typeCategory = [...new Set(categoryRows.map(row => row.typeCategory))];
        const totalCategory = categoryRows.map(row => ({
            name: row.categoryName,
            type: row.typeCategory,
            totalMoney: row.totalCategoryMoney,
            totalType: row.totalCategoryType
        }));

        res.status(HTTP_STATUS.OK).json({
            code: 200,
            message: 'Success',
            totalMoney, // Total transaction amount
            totalIncome, // Total income amount
            totalMoneyOut, // Total expense amount
            totalChi, // Total number of "Chi" transactions
            totalThu, // Total number of "Thu" transactions
            totalTransaction, // Total number of transactions
            typeCategory, // Types of categories
            totalCategoryMoney: totalCategory.map(cat => ({
                name: cat.name,
                totalMoney: cat.totalMoney
            })), // Total amount per category
            totalCategoryMoneyType: totalCategory.map(cat => ({
                name: cat.name,
                totalType: cat.totalType
            })) // Total transaction count per category
        });
    } catch (error) {
        console.error('Error in getStatisticalOfMonth function:', error);
        res.status(HTTP_STATUS.INTERNAL_SERVER_ERROR).json({ error: error.message });
    }
};
