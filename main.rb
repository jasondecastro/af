require 'octokit'
require_relative 'students'
require 'pry'

students = []

Octokit.configure do |c|
  c.login = 'flatnog'
  c.password = 'flatnog123'
end

Students.students.each do |n|
	students << Octokit.user("#{n}")
end

binding.pry