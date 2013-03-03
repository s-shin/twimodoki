# encoding: utf-8

前提 /^"(.*?)"ページを表示している$/ do |address|
  visit path_to(address)
end

もし /^"(.*?)"に"(.*?)"と入力する$/ do |label, val|
  fill_in label, with: val
end

もし /^"(.*?)"ボタンをクリックする$/ do |button|
  click_button button
end

ならば /^"(.*?)"と表示されていること$/ do |content|
  page.should have_content content
end




