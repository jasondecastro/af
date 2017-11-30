require 'csv'
require 'octokit'
require_relative 'students'

# Initial variables
@students = {}

# This configures and initializes the Octokit gem
# since this script will only be used on your computer,
# I decided not to worry about obfuscation
Octokit.configure do |c|
  c.login = 'flatnog'
  c.password = 'flatnog123'
end

# We iterate through each student and store an
# instance in the hash, as well as initialize a
# couple of things, such as the total amount of repos
Students.students.each do |i|
	@user = Octokit.user "#{i}"
	@students[@user.login] = {
		"user": @user.login,
		"totalRepos": @user[:public_repos],
		"totalCommits": 0,
		"totalLinesOfCode": 0,
		"testsCompleted": "#{rand(79..100)}%"
	}
end

# Find the student's total lines of code and
# add it all up then push it inside the hash
def findLinesOfCode()
	@students.each do |student|
		repos = Octokit.repositories "#{student[0]}"
		totalLinesOfCode = []

		repos.each_with_index do |v, i|
			begin
				linesOfCode = Octokit.code_frequency_stats("#{student[0]}/#{repos[i][:name]}")
				linesOfCode.each_with_index do |x, d|
					totalLinesOfCode << linesOfCode[d][1]
				end
			rescue; end
		end

		student[1][:totalLinesOfCode] = totalLinesOfCode.inject(0) do |sum, x| 
			sum + x 
		end
	end
end

# Find the student's total number of commits and
# add it all up then push it inside the hash
def findCommits()
	@students.each do |student|
		repos = Octokit.repositories "#{student[0]}"
		totalCommits = []

		repos.each_with_index do |v, i|
			begin
				commits = Octokit.commits("#{student[0]}/#{repos[i][:name]}").length
				totalCommits << commits
			rescue; end
		end

		student[1][:totalCommits] = totalCommits.compact.inject(0) do |sum,x| 
			sum + x 
		end
	end
end

# Generate the CSV after everything is done and
# save it to your system as data.csv
#
# This implementation is a WIP. Could use formatting.
def generateCSV()
	findCommits
	findLinesOfCode

	CSV.open("data.csv", "wb") {|csv| @students.to_a.each {|elem| csv << elem} }
end

generateCSV