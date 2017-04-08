json.extract! cms_user, :id, :name, :email, :password, :gender, :phone_number, :address, :role, :position, :created_at, :updated_at
json.url cms_user_url(cms_user, format: :json)
