class BankAccount < ApplicationRecord
  def self.select_accounts_for_investment(amount)
    available_accounts = all.map do |account|
      available_balance = account.enforcing_min_balance ? account.balance - account.min_balance : account.balance
      { account: account, available_balance: available_balance }
    end

    #  If total available balance is less than the investment amount, return "No match"**
    total_available_balance = available_accounts.sum { |a| a[:available_balance] }
    return [{ message: "No match" }] if total_available_balance < amount

    #  Find an exact match
    exact_match = available_accounts.find { |a| a[:available_balance] == amount }
    return [{ account: exact_match[:account].name, withdraw_amount: amount }] if exact_match

    #  Find an account with a balance greater than the investment
    greater_account = available_accounts.find { |a| a[:available_balance] > amount }
    return [{ account: greater_account[:account].name, withdraw_amount: amount }] if greater_account

    #  Deduct from multiple accounts recursively
    selected_accounts = []
    remaining_amount = amount

    available_accounts.sort_by! { |a| -a[:available_balance] } # Sort descending

    available_accounts.each do |entry|
      break if remaining_amount <= 0

      if entry[:available_balance] > 0
        withdraw_amount = [entry[:available_balance], remaining_amount].min
        selected_accounts << { account: entry[:account].name, withdraw_amount: withdraw_amount }
        remaining_amount -= withdraw_amount
      end
    end

    selected_accounts
  end
end
