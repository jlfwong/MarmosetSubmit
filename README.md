# MarmosetSubmit

This is a command-line tool for submitting assignments to the [Marmoset submission server][0] at [Waterloo][1]. It's similar to `marmoset_submit` on the `student.cs` servers, but you can run it anywhere.

## Installation
Installation is done through [RubyGems][2]: `gem install marmoset`. Depending on how you have things setup, you may need to run that with `sudo`.

## Usage
MarmosetSubmit installs a `marmoset` executable on your system. The typical usage of it is best illustrated with an example.

### Submit to a single problem
Let's say you want to submit a file in the current directory named `wlppgen.ss` as your submission to part 4 of assignment 11 in CS 241 (which has the 'project name' of "A11P4" on Marmoset). You'd run:

``marmoset -u YourQuestUsername -c cs241 -a a11p4 -f wlppgen.ss``

You will be prompted for your Quest password every time you run a `marmoset` command like this. If you'd like to skip the password prompt, you can include your password in the command like so:

``marmoset -u YourQuestUsername ``**-p YourQuestPassword**`` -c cs241 -a a11p4 -f wlppgen.ss``

### Submit to multiple problems
You can also submit many problems at once. For example say on assignment A1 there is a question with 10 parts, each with its own .txt file. Instead of manually submitting 10 times, simply run:

``marmoset -u YourQuestUsername -c cs246``

This will go through all problem titles listed on marmoset and submit the matching file, with a .txt, .c, or .zip extension.


Here are all of the options, in more detail:

* `-u` or `--username`: your Quest username (e.g. jlfwong).
* `-p` or `--password`: your Quest password. If not specified, you'll be prompted for it.
* `-c` or `--course-code`: the course ID. Typically, this is something like CS241.
* `-a` or `--assignment-problem`: the assignment problem name, or 'project' as Marmoset describes it (e.g. A11P4).
* `-f` or `--infile`: the file you want to submit (e.g. wlppgen.ss).
* `-h` or `--help`: display this usage information.
* `-v` or `--version`: display the version of MarmosetSubmit you're using.

For additional usage information, you can run ``marmoset -h``.

[0]: http://marmoset.student.cs.uwaterloo.ca/
[1]: http://uwaterloo.ca/
[2]: http://rubygems.org/
