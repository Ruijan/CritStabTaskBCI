classdef MockCreator < handle
    %MOCKCREATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filename = '',
        folder = '',
        recursive = false
        
    end
    
    methods
        function obj = MockCreator()
            %MOCKCREATOR Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function className = extractClassNameFromString(obj, string)
            isClass = contains(string, 'classdef');
            if isClass
                classNameStart = strfind(string, 'classdef') + ...
                    length('classdef') + 1;
                classNameEnd = strfind(string(classNameStart:end),' ')...
                    + classNameStart - 2;
                className = string(classNameStart:classNameEnd(1));
            else
                className = '';
            end
        end
        
        function extractedMethods = extractMethodsFromClassName(obj, className)
            extractedMethods = methods(className);
            superClasses = superclasses(className);
            for classIndex = 1:length(superClasses)
                if ~strcmp(superClasses{classIndex},'handle')
                    extractedMethods = [extractedMethods; ...
                        obj.extractMethodsFromClassName(superClasses(classIndex))];
                end
            end
        end
        function extractedProperties = extractPropertiesFromClassName(obj, className)
            extractedProperties = properties(className);
            superClasses = superclasses(className);
            for classIndex = 1:length(superClasses)
                if ~strcmp(superClasses{classIndex},'handle')
                    extractedProperties = [extractedProperties; ...
                        obj.extractPropertiesFromClassName(superClasses(classIndex))];
                end
            end
        end
        function createMockFileFromClassName(obj, className, folder)
            extractedMethods = obj.extractMethodsFromClassName(className);
            extractedProperties = obj.extractPropertiesFromClassName(className);
            fid = fopen( [folder className 'Mock.m'], 'wt' );
            classHeader = ['classdef ' className 'Mock \n'];
            classProperties = '    properties\n        stub,\n        behavior\n    end\n';
            classMethods = [...
                '    methods\n'...
                '        function obj = ' className 'Mock(testCase)\n'...
                '            [obj.stub, obj.behavior] = createMock(testCase,...\n'];
            classAddedMethods = ...
                '                ''AddedMethods'',{';
             for methodIndex = 1:length(extractedMethods)
                 if methodIndex ~= 1
                     classAddedMethods = [classAddedMethods ',...\n                    ''' ];
                 else
                     classAddedMethods = [classAddedMethods '...\n                    ''' ];
                 end
                 classAddedMethods = [classAddedMethods extractedMethods{methodIndex} ''''];
             end
            classAddedMethods = [classAddedMethods '},...\n'];
            classAddedProperties = ...
                '                ''AddedProperties'',{';
             for propertyIndex = 1:length(extractedProperties)
                 if propertyIndex ~= 1
                     classAddedProperties = [classAddedProperties ',...\n                    ''' ];
                 else
                     classAddedProperties = [classAddedProperties '...\n                    ''' ];
                 end
                 classAddedProperties = [classAddedProperties extractedProperties{propertyIndex} ''''];
             end
            classAddedProperties = [classAddedProperties '}'];
            classMethods = [classMethods classAddedMethods classAddedProperties ');\n'...    
                '        end\n'...
                '    end\n'];
            classFooter = 'end';
            fprintf( fid, [classHeader classProperties classMethods classFooter]);
            fclose(fid);
        end
    end
end

