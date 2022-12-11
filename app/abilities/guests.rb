Canard::Abilities.for(:guest) do
  cannot [:create, :update, :destroy], Guide
  can [:read], Guide
  can [:create], User
  can [:read],  Review
end

