function runTests(file)
	import matlab.unittest.TestRunner
	import matlab.unittest.TestSuite
	import matlab.unittest.plugins.TestRunProgressPlugin
	import matlab.unittest.plugins.DiagnosticsRecordingPlugin
	import matlab.unittest.plugins.CodeCoveragePlugin

	addpath('src');
	addpath('src/mocks');
	suite = [];
	if(nargin == 0)  
		suite = TestSuite.fromFolder('src');
	elseif (nargin == 1)  
		suite = TestSuite.fromFile(file);
	end

	% Create silent test runner.
	runner = TestRunner.withNoPlugins;

	% Add plugin to display test progress.
	% runner.addPlugin(TestRunProgressPlugin.withVerbosity(4))
	runner.addPlugin(CodeCoveragePlugin.forFolder('../src/'))

	% Add plugin to display test progress.
	% runner.addPlugin(DiagnosticsRecordingPlugin)

	% Run tests using customized runner.
	result = run(suite);
	% result = runner.run(suite1)
	disp(table(result))
end
