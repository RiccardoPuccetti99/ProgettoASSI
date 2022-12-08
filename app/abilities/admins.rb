Canard::Abilities.for(:admin) do
  #can :manage, Guide
  #can [:update], User
  can :manage, :all
end
