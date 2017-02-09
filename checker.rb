require 'capybara'
require 'capybara/poltergeist'
require 'nokogiri'
require 'nikkou'

class Checker
  def initialize(args)
    @username = args.fetch(:username)
    @pin = args.fetch(:pin)
    @session = Capybara::Session.new(:poltergeist)
  end

  def run
    @session.visit("https://www.puregym.com/login/")
    @session.fill_in 'email', :with => @username
    @session.fill_in 'pin', :with => @pin
    @session.click_button 'Login'

    sleep 3

    body = @session.body
    num = body.match(
    /Number of people in the gym:<!-- \/react-text --><br><strong>(\d+)/
    ).captures.first

    return num.to_i
  end
end

p Checker.new(username: ENV.fetch("PUREGYM_EMAIL"), pin: ENV.fetch("PUREGYM_PIN")).run
