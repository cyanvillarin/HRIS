require 'watir'
 
newsaf = Watir::Browser.new :safari

newsaf.goto "http://202.92.132.232/users/sign_in"

username = "bernescoto"
password = "password"
 
newsaf.text_field(:name, "user[username]").set username
newsaf.text_field(:name, "user[password]").set password
newsaf.button(:name, "commit").click
newsaf.link(:text =>"Employee List").click

searchname = "Roy Vincent Canseco"
newsaf.text_field(:type, "search").set searchname
newsaf.table.td(:text, "Canseco, Roy Vincent").click

# newsaf.button(:id, "personal_edit_button").click

sleep(5)

# newsaf.close
