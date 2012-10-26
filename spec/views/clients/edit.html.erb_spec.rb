require 'spec_helper'

describe "clients/edit" do
  before(:each) do
    @client = assign(:client, stub_model(Client,
      :fio => "MyString",
      :comment => "MyText",
      :phone1 => "MyString",
      :phone2 => "MyString",
      :phone3 => "MyString",
      :phone4 => "MyString",
      :adress => "MyString",
      :brand => "MyString",
      :manager => "MyString",
      :model => "MyString",
      :icon => 1,
      :creditmanager => "MyString",
      :icon2 => 1,
      :vin => "MyString",
      :cost => 1,
      :status => "MyString",
      :commercial => "MyString",
      :tmp => "MyString",
      :files => 1,
      :phone11 => "MyString",
      :phone22 => "MyString",
      :phone33 => "MyString",
      :phone44 => "MyString",
      :email => "MyString",
      :pas1 => "MyString",
      :pas2 => "MyString",
      :pas3 => "MyString",
      :prepay => 1.5,
      :carpets => false,
      :mudguard => false,
      :tech_1 => false,
      :tech_2 => false,
      :tires => false,
      :client_adress => "MyString",
      :cause => 1,
      :trade_in_price => 1,
      :trade_in_desc => "MyText",
      :used_vin => "MyString"
    ))
  end

  it "renders the edit client form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => clients_path(@client), :method => "post" do
      assert_select "input#client_fio", :name => "client[fio]"
      assert_select "textarea#client_comment", :name => "client[comment]"
      assert_select "input#client_phone1", :name => "client[phone1]"
      assert_select "input#client_phone2", :name => "client[phone2]"
      assert_select "input#client_phone3", :name => "client[phone3]"
      assert_select "input#client_phone4", :name => "client[phone4]"
      assert_select "input#client_adress", :name => "client[adress]"
      assert_select "input#client_brand", :name => "client[brand]"
      assert_select "input#client_manager", :name => "client[manager]"
      assert_select "input#client_model", :name => "client[model]"
      assert_select "input#client_icon", :name => "client[icon]"
      assert_select "input#client_creditmanager", :name => "client[creditmanager]"
      assert_select "input#client_icon2", :name => "client[icon2]"
      assert_select "input#client_vin", :name => "client[vin]"
      assert_select "input#client_cost", :name => "client[cost]"
      assert_select "input#client_status", :name => "client[status]"
      assert_select "input#client_commercial", :name => "client[commercial]"
      assert_select "input#client_tmp", :name => "client[tmp]"
      assert_select "input#client_files", :name => "client[files]"
      assert_select "input#client_phone11", :name => "client[phone11]"
      assert_select "input#client_phone22", :name => "client[phone22]"
      assert_select "input#client_phone33", :name => "client[phone33]"
      assert_select "input#client_phone44", :name => "client[phone44]"
      assert_select "input#client_email", :name => "client[email]"
      assert_select "input#client_pas1", :name => "client[pas1]"
      assert_select "input#client_pas2", :name => "client[pas2]"
      assert_select "input#client_pas3", :name => "client[pas3]"
      assert_select "input#client_prepay", :name => "client[prepay]"
      assert_select "input#client_carpets", :name => "client[carpets]"
      assert_select "input#client_mudguard", :name => "client[mudguard]"
      assert_select "input#client_tech_1", :name => "client[tech_1]"
      assert_select "input#client_tech_2", :name => "client[tech_2]"
      assert_select "input#client_tires", :name => "client[tires]"
      assert_select "input#client_client_adress", :name => "client[client_adress]"
      assert_select "input#client_cause", :name => "client[cause]"
      assert_select "input#client_trade_in_price", :name => "client[trade_in_price]"
      assert_select "textarea#client_trade_in_desc", :name => "client[trade_in_desc]"
      assert_select "input#client_used_vin", :name => "client[used_vin]"
    end
  end
end
