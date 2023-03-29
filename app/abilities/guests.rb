Canard::Abilities.for(:guest) do
  cannot [:create, :update, :destroy], Guide
  cannot [:create, :destroy], Review
  can [:read], Guide
  can [:create], User
  can [:read],  Review
end

