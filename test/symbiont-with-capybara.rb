#!/usr/bin/env ruby
$: << './lib'

require 'symbiont'
include Symbiont::Factory

Capybara.configure do |config|
  config.default_driver = :selenium
  config.app_host = 'http://localhost:9292'
end

class Navigation < Symbiont::Region
  element :open, "#navlist"
end

class Symbiote < Symbiont::Page
  url_is '/'
  url_matches /:\d{4}/

  element :open_form, :xpath, ".//*[@id='open']" # "p[id='open']"
  element :username, "input[id='username']"
  element :password, "input[id='password']"
  element :login,    "input[id='login-button']"
end

class Home < Symbiont::Page
  region :navigation, Navigation, "#areas"
end

class Stardate < Symbiont::Page
  url_is '/stardate'

  elements :facts, 'ul#fact-list li a'
end

puts Symbiont.version

on_view(Symbiote)
#@page = Symbiote.new
#@page.view
# -- or --
#@page.perform.open_form.click

puts "Page displayed? #{@page.displayed?}"

puts "Page title: #{@page.title}"
puts "Page URL: #{@page.current_url}"
puts "Page secure? #{@page.secure?}"

puts "Open Form Element: #{@page.open_form}"
puts "Open Form Exists? #{@page.has_open_form?}"
puts "Username not present? #{@page.has_no_username?}"
puts "Username exists in DOM? #{@page.has_username?(visible: false)}"
puts "Username Element (in DOM): #{@page.username(visible: false)}"

on(Symbiote) do
  @page.open_form.click
  @page.username.set 'admin'
  @page.password.set 'admin'
  @page.login.click
end

puts "Does page have region of navigation?: #{on(Home).has_navigation?}"
on(Home).navigation.open.click

puts "Region parent for navigation: #{on(Home).navigation.region_parent}"

on_view(Stardate).facts.each { |fact| puts fact.text }
puts "Facts count: #{@page.facts.size}"

=begin
Symbiote.new do
  view
  open_form.click
  username.set 'admin'
  password.set 'admin'
  login.click
end
=end