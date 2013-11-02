attributes :id

node(:status) { |r| t("request_status.#{r.status}") }
node(:created_by) { |r| l r.created_at }

child(:user_from) do
  attributes :id, :name, :email
end

child(:lo) do
  attributes :id, :name
end
