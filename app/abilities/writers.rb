Canard::Abilities.for(:writer) do
  can [:create], Guide
  can [:update, :destroy], Guide, user_id: user.id
  can [:update], User
end
