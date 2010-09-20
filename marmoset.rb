#!/usr/bin/env ruby
require 'logger'
require 'rubygems'
require 'mechanize'
require 'highline/import'
require 'choice'

HighLine.track_eof = false

class MarmosetClient
  class InvalidLogin < StandardError; end
  class CourseNotFound < StandardError; end
  class ProblemNotFound < StandardError; end

  def initialize(opts)
    @agent = Mechanize.new
    @course_index_page  = nil
    @course_page        = nil
    @submit_page        = nil

    @filename = opts[:filename]
    @username = opts[:username]
    @password = opts[:password]
    @course   = opts[:course]
    @problem  = opts[:problem]
  end

  def login
    @username ||= ask("Username: ")
    @password ||= ask("Password: ") {|q| q.echo = '*'}

    say "Logging in ..."

    login_page = @agent.get 'https://marmoset.student.cs.uwaterloo.ca/'
    form = login_page.forms.first
    
    form.username = @username
    form.password = @password

    login_submit_page = @agent.submit form
    
    if login_submit_page.uri.to_s.include? 'cas.uwaterloo.ca'
      raise InvalidLogin
    end

    @course_index_page = @agent.submit login_submit_page.forms.first
  rescue InvalidLogin
    say 'Invalid Username/Password'
    exit
  end

  def select_course
    say "Select course ..."
    login if @course_index_page.nil?

    course_links = @course_index_page.links.find_all do |l|
      l.href.include? 'course.jsp'
    end  

    if @course.nil?
      choose do |menu|
        course_links.each do |course_link|
          menu.choice(course_link.text.strip) do
            @course = course_link.text.strip
            @course_page = course_link.click 
          end
        end
      end
    else
      course_link = course_links.find do |l| 
        l.text.downcase.include? @course.downcase
      end
      raise CourseNotFound if course_link.nil?

      @course_page = course_link.click
    end
  rescue CourseNotFound
    say "Course #{@course} could not be found."
    options = course_links.collect{|x| x.text.gsub(/\([^\)]+\):/,'').strip}
    say "Options are: #{options.sort.join(', ')}"
    exit
  end

  def select_problem
    say "Selecting problem ..."
    select_course if @course_page.nil?

    problem_links = {}

    @course_page.links.find_all{|l| l.href.include? 'submitProject.jsp'}.each do |view_link|
      index = @course_page.links.find_index{|l| l.href == view_link.href}
      named_link = @course_page.links[index-2]
      problem_links[named_link.text] = view_link
    end

    if @problem.nil?
      choose do |menu|
        problem_links.each do |(name,problem_link)|
          menu.choice(name.strip) do
            @problem = name
            @submit_page = problem_page.click
          end
        end
      end
    else
      problem_link = problem_links.find{|(prob_name,link)| 
        prob_name.downcase.include? @problem.downcase
      }
      raise ProblemNotFound if problem_link.nil?

      problem_link = problem_link[1]
      @submit_page = problem_link.click
    end
  rescue ProblemNotFound
    say "Problem #{@problem} could not be found in #{@course}"
    say "Options are: #{problem_links.collect{|x| x[0].strip}.sort.join(', ')}"
    exit
  end

  def submit_problem
    say "Submitting ..."
    select_problem if @submit_page.nil?

    form = @submit_page.forms.first
    @submit_page.forms.first.file_uploads.first.file_name = @filename
    @submit_response_page = @agent.submit(form)
    say "Assignment submitted succesfully"
  rescue Mechanize::ResponseCodeError => e
    say "There was a problem submitting your assignment. Submit manually"
  end
end

PROGRAM_VERSION = 1.0

Choice.options do
  option :username do
    short   '-u'
    long    '--username=USERNAME'
    desc    'Your Quest userid, e.g. jlfwong'
    default nil
  end

  option :password do
    short   '-p'
    long    '--password=PASSWORD'
    desc    'Your Quest password. Will be prompted if not specified'
    default nil
  end

  option :course do
    short   '-c'
    long    '--course-code=COURSECODE'
    desc    'Course ID, e.g. CS241'
    default nil
  end

  option :problem do
    short   '-a'
    long    '--assignment-problem=PROB'
    desc    'Assignment problem name, e.g. A1P4'
  end

  option :filename, :required => true do
    short   '-f'
    long    '--infile=FILENAME'
    desc    'The file to submit to marmoset'
  end
  
  option :help do
    long '--help'
    desc 'Show this message'
  end
  
  option :version do
    short '-v'
    long  '--version'
    desc  'Show Version'
    action do
      puts "#{File.basename(__FILE__)} Marmoset CLI v#{PROGRAM_VERSION}"
      exit
    end
  end
end

client = MarmosetClient.new(Choice.choices)
client.login
client.select_course
client.select_problem
client.submit_problem
