# About
rsmp-validator is a tool written in Ruby for testing RSMP equipment or software with RSpec.
It uses the rsmp gem to handle RSMP communication.

# Testing an RSPM site
A local RSMP supervisor will be started on 127.0.0.1:12111. The site is expected to connect to it. You might have to adjust network settings to enable the site to reach the supervisor.

Once the site has connected, tests will be run to validate aspects like connection sequence, commmands, alarms, etc.

Some tests specify that the connection is reestablished before the test is run. This is useful when testing connection sequence, etc. Otherwise the connection will be kept open between tests, which will speed up execution.

To run test, cd to the root of this project, then:
	
~~~~
> rspec test/site
............

Finished in 1.28 seconds (files took 0.20949 seconds to load)
12 examples, 0 failures
	
~~~~

See https://rspec.info/ for more info about how to run specific test, hot to format output, etc.

# Testing an RSMP supervisor
To be implemented.