class BankAccountsController < ApplicationController
  def index
    @bank_accounts = BankAccount.all
  end

  def investment
    amount = params[:amount].to_i
    @selected_accounts = BankAccount.select_accounts_for_investment(amount)
    @bank_accounts = BankAccount.all  # ✅ Add this line to prevent nil error

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @selected_accounts }
    end
  end
end


