Dir["./spec/support/common_actions/*.rb"].each { |f| require f }

module CommonActions
  include Custom
  include Notifications
  include Users
  include Verifications
end
