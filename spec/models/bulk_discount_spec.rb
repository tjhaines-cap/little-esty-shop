require 'rails_helper'

RSpec.describe BulkDiscount do

  it { should belong_to :merchant }

  it { should validate_presence_of :percentage }
  it { should validate_presence_of :quantity }

end