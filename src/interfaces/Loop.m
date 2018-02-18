classdef Loop < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        loop
    end
    methods(Static)
        function addPaths()
            if(isempty(getenv('CNBITKMAT_ROOT')))
                disp('[ndf_include] $CNBITKMAT_ROOT not found, using default');
                setenv('CNBITKMAT_ROOT', '/usr/share/cnbiloop/cnbitkmat/');
            end
            if(isempty(getenv('EEGC3_ROOT')))
                disp('[ndf_include] $EEGC3_ROOT not found, using default');
                setenv('EEGC3_ROOT', '/opt/eegc3');
            end
            mtpath_root = [getenv('CNBITKMAT_ROOT') '/mtpath'];
            if(exist(mtpath_root, 'dir'))
                addpath(mtpath_root);
            end
            mtpath_include('$CNBITKMAT_ROOT/');
            mtpath_include('$EEGC3_ROOT/');
            mtpath_include('$EEGC3_ROOT/modules/smr');
        end      
    end
    
    methods
        function obj = Loop()
            %SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
            addpath('/usr/share/cnbiloop/cnbitkmat/mexcnbiloop/');
            mex_id_ = 'o ClLoop* = clnew()';
            [obj.loop] = cnbiloop(mex_id_);
        end
        function [status] = connect(obj, nameserver)
            if(nargin < 2)
                nameserver = '';
            end
            mex_id_ = 'o std::string* = new(i cstring)';
            [tnameserver] = cnbiloop(mex_id_, nameserver);
            mex_id_ = 'o bool = clconnect(i ClLoop*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tnameserver);
            if status == false
                warning('Cannot connect to CNBI Loop');
            end
        end
        function disconnect(obj)
            mex_id_ = 'cldisconnect(i ClLoop*)';
            cnbiloop(mex_id_, obj.loop);
        end
        function [status] = erase(obj, name)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o bool = clerase(i ClLoop*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname);
        end
        function [status] = eraseConfig(obj, component, name)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tcomponent] = cnbiloop(mex_id_, component);
            mex_id_ = 'o bool = clerasecfg(i ClLoop*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tcomponent, tname);
        end
        function [status] = isConnected(obj)
            mex_id_ = 'o bool = clisconnected(i ClLoop*)';
            [status] = cnbiloop(mex_id_, obj.loop);
        end
        function [status] = openXdf(obj, filexdf, filelog, linelog)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tfilexdf] = cnbiloop(mex_id_, filexdf);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tfilelog] = cnbiloop(mex_id_, filelog);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tlinelog] = cnbiloop(mex_id_, linelog);
            mex_id_ = 'o bool = clopenxdf(i ClLoop*, i std::string*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tfilexdf, tfilelog, tlinelog);
        end
        function [status] = closeXdf(obj)
            mex_id_ = 'o bool = clclosexdf(i ClLoop*)';
            [status] = cnbiloop(mex_id_, obj.loop);
        end
        function [address] = query(obj, name)
            address = '';
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'clquery(i ClLoop*, i std::string*, io cstring[x])';
            [address] = cnbiloop(mex_id_, obj.loop, tname, address, 1024);
        end
        function [content] = retrieve(obj, name)
            content = '';
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'clretrieve(i ClLoop*, i std::string*, io cstring[x])';
            [content] = cnbiloop(mex_id_, obj.loop, tname, content, 1024);
        end
        function [content] = retrieveConfig(obj, component, name)
            content = '';
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tcomponent] = cnbiloop(mex_id_, component);
            mex_id_ = 'clretrievecfg(i ClLoop*, i std::string*, i std::string*, io cstring[x])';
            [content] = cnbiloop(mex_id_, obj.loop, tcomponent, tname, content, 1024);
        end
        function [status] = retrieveFile(obj, name, filename)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tfilename] = cnbiloop(mex_id_, filename);
            mex_id_ = 'o bool = clretrievefile(i ClLoop*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname, tfilename);
        end
        function [status] = set(obj, name, address)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [taddress] = cnbiloop(mex_id_, address);
            mex_id_ = 'o bool = clset(i ClLoop*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname, taddress);
        end
        function [status] = store(obj, name, content)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tcontent] = cnbiloop(mex_id_, content);
            mex_id_ = 'o bool = clstore(i ClLoop*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname, tcontent);
        end
        function [status] = storeConfig(obj, component, name, content)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tcomponent] = cnbiloop(mex_id_, component);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tcontent] = cnbiloop(mex_id_, content);
            mex_id_ = 'o bool = clstorecfg(i ClLoop*, i std::string*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tcomponent, tname, tcontent);
        end
        function [status] = storeFile(obj, name, filename)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o std::string* = new(i cstring)';
            [tfilename] = cnbiloop(mex_id_, filename);
            mex_id_ = 'o bool = clstorefile(i ClLoop*, i std::string*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname, tfilename);
        end
        function [status] = unset(obj, name)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tname] = cnbiloop(mex_id_, name);
            mex_id_ = 'o bool = clunset(i ClLoop*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tname);
        end
        function [status] = updateLog(obj, linelog)
            mex_id_ = 'o std::string* = new(i cstring)';
            [tlinelog] = cnbiloop(mex_id_, linelog);
            mex_id_ = 'o bool = clupdatelog(i ClLoop*, i std::string*)';
            [status] = cnbiloop(mex_id_, obj.loop, tlinelog);
        end
        function [isvalid] = checkName(name)
            mex_id_ = 'o bool = clcheckname(i cstring[x])';
            [isvalid] = cnbiloop(mex_id_, name, 1024);
        end      

            
    end
end

