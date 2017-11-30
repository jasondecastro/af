require 'octokit'

Octokit.configure do |c|
  c.login = 'flatnog'
  c.password = 'flatnog123'
end

Octokit.user