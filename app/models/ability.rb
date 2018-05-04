class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
      cannot :destroy, Curriculum #curriculum can never be destroyed
      cannot :destroy, Family #family can never be destroyed
      
    elsif user.role? :instructor
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      
      can :show, Instructor, user_id: user.id
      can :edit, Instructor, user_id: user.id
      can :update, Instructor, user_id: user.id
      can :show, User, id: user.id
      can :edit, User, id: user.id
      can :update, User, id: user.id
      
    elsif user.role? :parent
      can :show, Family, user_id: user.id
      can :edit, Family, user_id: user.id
      can :update, Family, user_id: user.id
      can :manage, Student#own students
      can :manage, Registration#own registrations
      can :read, Curriculum
      can :read, Location
      can :read, Camp
      
    else #guest
      can :new, Family
      can :create, Family
      can :read, Curriculum
      can :read, Location
      can :read, Camp
    end
  end
end