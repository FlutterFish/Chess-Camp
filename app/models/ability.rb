class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
      
    elsif user.role? :instructor
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      
      can :manage, Instructor#bio, picture, email, phone
      can :manage, User#password
      
    elsif user.role? :parent
      can :manage, Family
      can :manage, Student
      can :manage, Registration
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      
      
    else
      can :read, Curriculum
      can :read, Location
      can :read, Camp
    end
  end
end