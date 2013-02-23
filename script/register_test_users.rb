
["foo", "bar", "hoge", "piyo"].each do |name|
  user = User.new({
    name: name,
    another_name: name,
    email: "#{name}@example.com",
    password: name,
    password_confirmation: name,
    private: false
  })
  unless user.save
    p user.errors
    abort "ERROR: creating user failed"
  end
end



