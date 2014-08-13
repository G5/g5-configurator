module Helpers
  def spec_sign_in
    user = G5Authenticatable::User.create(email:"foo@foo.com", uid:"foO",password:"foo")
    sign_in user
  end
end
