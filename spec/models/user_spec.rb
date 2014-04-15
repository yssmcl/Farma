require 'spec_helper'

describe User do

  it { should has_many (:reports) }
end
