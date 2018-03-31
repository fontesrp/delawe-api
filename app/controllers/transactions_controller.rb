class TransactionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_target_user

  def index

    transactions = [];

    @target_user.payments.each do |trx|
      props = trx.attributes.extract! 'created_at', 'order_id', 'amount'
      props['amount'] *= -1
      transactions << props
    end

    @target_user.earnings.each do |trx|
      transactions << trx.attributes.extract!('created_at', 'order_id', 'amount')
    end

    render json: transactions
  end

  def create

    trx = Transaction.new transaction_params

    case transaction_type
    when 'add_credit'
      trx.creditor = User.first
      trx.debtor = @target_user
    when 'withdraw'
      trx.creditor = @target_user
      trx.debtor = User.first
    else
      return render json: { errors: ["invalid operation"] }
    end

    if trx.save
      render json: trx
    else
      render json: { errors: trx.errors.full_messages }
    end
  end

  private

  def set_target_user
    if current_user.user_type == 'admin' && params[:user_id].present?
      @target_user = User.find params[:user_id]
    else
      @target_user = current_user
    end
  end

  def transaction_params
    params.require(:transaction).permit :amount
  end

  def transaction_type
    params[:trx_type]
  end
end
