class WhenToMine::CalculatorsController < ApplicationController

  # NOTE
  #
  # It would be good to capture all the calculators that get created, and who
  # creates them.
  #
  # We also don't want to make it easy for people to return to a calculator
  # without having first given us a way to contact them (i.e. registred an
  # account). This is important because our primary goal is to generate a
  # list of leads for the Afterburner Mine.
  #
  # And we should give visitors some value without them having to register
  # first. If we ask for contact info before we've provided any value I'm
  # afraid people will be scared off.
  #
  # So, my proposal is to find calculators by a hash of all the inputs. Then
  # we can store that hash in the session cookie for users that aren't logged
  # in, or in the profile of users that are logged in.
  #
  # We can also keep track of the sequence of calculators that a given person
  # makes (registerd user or un-registerd client)
  
  def show
  end

  def create
    redirect_to action: :show
  end
end
