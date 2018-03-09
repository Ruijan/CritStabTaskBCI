function runCodeCoverage()
	import matlab.unittest.TestRunner
	import matlab.unittest.TestSuite
	import matlab.unittest.plugins.CodeCoveragePlugin

% 	suite = TestSuite.fromPackage('src');
    suite = TestSuite.fromFolder('src');

	% Create silent test runner.
    runner = TestRunner.withTextOutput;

	% Add plugin to display test progress.
	runner.addPlugin(CodeCoveragePlugin.forFolder('/home/cnbi/dev/CritStabTaskBCI/src/'))
	% Run tests using customized runner.
    tests = runner.run(suite);
	disp(table(tests))
end
