function runTests(file)
	import matlab.unittest.TestRunner
	import matlab.unittest.TestSuite
	import matlab.unittest.plugins.TestRunProgressPlugin
	import matlab.unittest.plugins.DiagnosticsRecordingPlugin
	import matlab.unittest.plugins.CodeCoveragePlugin

	addpath('src');
	addpath('src/mocks');
	createMocks('../src/');

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

function createMocks(folder)
	mockCreator = MockCreator;
	listing = dir(folder);
	addpath(folder);
	for i = 3:length(listing)
		if ~listing(i).isdir
			mockCreator.createMockFileFromClassName(listing(i).name(1:end-2), 'src/mocks/');
		else
			createMocks([folder '/' listing(i).name]);
		end

	end
	rmpath(folder);
end
