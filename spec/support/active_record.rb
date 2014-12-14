require 'support/reconnectdb'

reconnectdb

RSpec.configure do |config|
  config.around(:example, {:rollback => true}) do |example|
    ActiveRecord::Base.logger.level = 2 unless ActiveRecord::Base.logger.nil?
    ActiveRecord::Base.transaction do
      example.run
      if ActiveRecord::Base.connection.open_transactions > 0
        raise ActiveRecord::Rollback
      end
    end
  end
end