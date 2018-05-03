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
      can :manage, Family#own family
      #can :update, Family#own family
      can :manage, Student#own students
      can :manage, Registration#own registrations
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      
    else
      can :new, Family
      can :create, Family
      can :read, Curriculum
      can :read, Location
      can :read, Camp
    end
  end
end