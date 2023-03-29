require 'rails_helper'
require 'cancan/matchers'

describe Canard::Abilities, '#users' do
  let(:acting_user) { User.create(roles: %w(user)) }
  subject(:user_ability) { Ability.new(acting_user) }

  describe 'on Guide' do
    let(:guide) { Guide.create }

    it { is_expected.to be_able_to( :read, guide ) }
  end
  
end
