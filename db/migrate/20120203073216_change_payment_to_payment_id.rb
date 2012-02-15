class ChangePaymentToPaymentId < ActiveRecord::Migration
  def change
    rename_column :cars, :payment, :payment_id
  end


end
