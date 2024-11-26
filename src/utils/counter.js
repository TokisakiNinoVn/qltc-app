const {Counter} = require('@app/models');


async function getInvoiceCode(){
    let counter = await Counter.findOne({}).lean();
    if(!counter){
        return "";
    }
    counter.invoice += 1;
    await Counter.findByIdAndUpdate(counter._id, counter, {new: true, runValidators: true});
    return process.env.PREFIX_INVOICE + String(counter.invoice).padStart(6, '0');
}

async function getCustomerCode(){
    let counter = await Counter.findOne({}).lean();
    if(!counter){
        return "";
    }
    counter.customer += 1;
    await Counter.findByIdAndUpdate(counter._id, counter, {new: true, runValidators: true});
    return process.env.PREFIX_CUSTOMER + String(counter.customer).padStart(6, '0');
}

async function getEnterWarehouseCode() {
    let counter = await Counter.findOne({}).lean();
    if (!counter) {
        return "";
    }

    counter.paymentSlip += 1;
    await Counter.findByIdAndUpdate(counter._id, counter, { new: true, runValidators: true });
    return process.env.PREFIX_ENTER_WAREHOUSE + String(counter.paymentSlip).padStart(6, '0');
}
async function getCostproposalCode() {
    let counter = await Counter.findOne({}).lean();
    if (!counter) {
        return "";
    }

    counter.paymentslip += 1;
    await Counter.findByIdAndUpdate(counter._id, counter, { new: true, runValidators: true });
    return process.env.PREFIX_ENTER_WAREHOUSE + String(counter.paymentslip).padStart(6, '0');
}

module.exports = {
    getInvoiceCode,
    getCustomerCode,
    getEnterWarehouseCode,
    getCostproposalCode
  }