class TransactionsController < ApplicationController
  load_and_authorize_resource

  def index
    @per_page = 7
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    offset = (@page - 1) * @per_page

    if current_user.admin?
      @total_transactions = Transaction.count
      @users_transactions = Transaction.includes(:user).order(created_at: :desc).limit(@per_page).offset(offset)
    else
      @total_transactions = current_user.transactions.count
      @transactions = current_user.transactions.order(created_at: :desc).limit(@per_page).offset(offset)
    end

    @total_pages = (@total_transactions.to_f / @per_page).ceil
  end

  def new
    @transaction = Transaction.new(
      stock_symbol: params[:stock_symbol],
      number_of_shares: params[:number_of_shares],
      price_per_share: params[:price_per_share]
    )
  end

  def create
    action = params[:action_type]  # Assume this is passed as a parameter to distinguish between 'buy' and 'sell'
    if action == 'buy'
      buy
    elsif action == 'sell'
      sell
    else
      redirect_to stocks_path, alert: "Invalid transaction type"
    end
  end

  def buy
    create_transaction('buy', 'Stock purchased successfully and added to your portfolio!')
  end

  def sell
    create_transaction('sell', 'Stock sold successfully!')
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  def create_transaction(action, success_message)
    total_cost = transaction_params[:number_of_shares].to_i * transaction_params[:price_per_share].to_d
    case action
    when 'buy'
      if current_user.balance >= total_cost
        handle_buy_transaction(total_cost, success_message)
      else
        redirect_to stocks_path, alert: 'Not enough balance'
      end
    when 'sell'
      stock_item = stock
      if stock_item.nil?
        redirect_to stocks_path, alert: 'Stock not found'
      elsif stock_item.shares < transaction_params[:number_of_shares].to_i
        redirect_to stocks_path, alert: 'Not enough shares'
      else
        handle_sell_transaction(success_message)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new, alert: e.message
  end

  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :number_of_shares, :price_per_share)
  end

  def stock
    current_user.stocks.find_by(symbol: transaction_params[:stock_symbol])
  end

  def handle_buy_transaction(total_cost, success_message)
    ActiveRecord::Base.transaction do
      current_user.update!(balance: current_user.balance - total_cost)
      stock_item = current_user.stocks.find_or_initialize_by(symbol: transaction_params[:stock_symbol])
      stock_item.shares += transaction_params[:number_of_shares].to_i
      stock_item.save!
      @transaction = Transaction.create_buy(current_user, transaction_params, total_cost)
      if @transaction.persisted?
        redirect_to transaction_path(@transaction), notice: success_message
      else
        render :new, alert: "Failed to create transaction."
      end
    end
  end

  def handle_sell_transaction(success_message)
    sold_shares = transaction_params[:number_of_shares].to_i
    sell_price_per_share = transaction_params[:price_per_share].to_d
    total_revenue = sold_shares * sell_price_per_share

    ActiveRecord::Base.transaction do
      stock_item = stock
      raise ActiveRecord::RecordNotFound, 'Stock not found' if stock_item.nil?
      raise StandardError, 'Not enough shares' if stock_item.shares < sold_shares

      new_share_count = stock_item.shares - sold_shares
      stock_item.update!(shares: new_share_count)
      stock_item.destroy if new_share_count <= 0

      current_user.update!(balance: current_user.balance + total_revenue)

      @transaction = Transaction.create_sell(current_user, transaction_params, total_revenue) # Create transaction record
      if @transaction.persisted?
        redirect_to transaction_path(@transaction), notice: success_message
      else
        render :new, alert: "Failed to create transaction."
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render :new, alert: e.message
    rescue StandardError => e
      redirect_to stocks_path, alert: e.message
    end
  end


end
