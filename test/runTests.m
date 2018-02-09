import matlab.unittest.TestRunner
import matlab.unittest.TestSuite
import matlab.unittest.plugins.TestRunProgressPlugin
import matlab.unittest.plugins.DiagnosticsRecordingPlugin

addpath('src');
suite1 = TestSuite.fromFolder('src');

% Create silent test runner.
runner = TestRunner.withNoPlugins;

% Add plugin to display test progress.
runner.addPlugin(TestRunProgressPlugin.withVerbosity(4))
% Add plugin to display test progress.
% runner.addPlugin(DiagnosticsRecordingPlugin)

% Run tests using customized runner.
result = run(runner,suite1);
disp(table(result))