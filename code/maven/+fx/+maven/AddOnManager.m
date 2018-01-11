classdef( Hidden ) AddOnManager < handle
    
    properties( GetAccess = public, SetAccess = private )
        CreationTime(1,1) datetime
        Dependencies table
    end
    
    properties( GetAccess = private, Constant )
        Instance(1,1) fx.maven.AddOnManager = fx.maven.AddOnManager.getInstance();
    end
    
    methods( Access = private )
        
        function this = AddOnManager()
            this.CreationTime = datetime( 'now' );
            this.Dependencies = table( ...
                cell.empty( 0, 1), ...
                cell.empty( 0, 1), ...
                cell.empty( 0, 1), ...
                'VariableNames', {'Identifier', 'Guid', 'Toolbox'} );
        end
        
        function delete( this )
            % Remove all dependencies
            for dependencyIndex = 1:size( this.Dependencies, 1 )
                try
                    matlab.addons.toolbox.uninstallToolbox( ...
                        this.Dependencies.Toolbox{dependencyIndex} );
                catch matlabException
                    fprintf( 2, '%s', matlabException.message );
                end
            end
        end
        
    end
    
    methods( Static, Access = public )
        
        function value = getCreationTime()
            value = fx.maven.AddOnManager.Instance.CreationTime;
        end
        
        function value = getDependencies()
            value = fx.maven.AddOnManager.Instance.Dependencies;
        end
        
        function addDependency( identifier, filePath )
            validateattributes( identifier, ...
                {'char'}, {'scalartext'} );
            validateattributes( filePath, ...
                {'char'}, {'scalartext'} );
            instance = fx.maven.AddOnManager.Instance;
            installedToolbox = matlab.addons.toolbox.installToolbox( ...
                filePath );
            instance.Dependencies(end+1,:) = { ...
                {identifier}, ...
                {installedToolbox.Guid}, ...
                {installedToolbox},...
                };
        end
        
        function removeDependencies( identifier )
            validateattributes( identifier, ...
                {'char'}, {'scalartext'} );
            % Look for all dependencies
            instance = fx.maven.AddOnManager.Instance;
            dependenciesIndex = strcmp( ...
                identifier, ...
                instance.Dependencies.Identifier );
            if ~any( dependenciesIndex )
                return;
            end
            % Remove them
            dependenciesGuid = instance.Dependencies.Guid(dependenciesIndex);
            dependencies = instance.Dependencies.Toolbox(dependenciesIndex);
            removed = false( 1, numel( dependenciesIndex ) );
            for dependencyIndex = 1:numel( dependenciesIndex )
                thisDependencyGuid = dependenciesGuid{dependencyIndex};
                thisDependency = dependencies{dependencyIndex};
                % Make sure this isn't use by any one else
                alsoUsed = any( strcmp( ...
                    thisDependencyGuid, ...
                    instance.Dependencies.Guid(~dependenciesIndex) ) );
                if ~alsoUsed
                    matlab.addons.toolbox.uninstallToolbox( thisDependency );
                    removed(dependencyIndex) = true;
                end
            end
            % Forget about them
            dependencyPosition = find( dependenciesIndex );
            instance.Dependencies(dependencyPosition(removed),:) = []; 
        end
        
    end
    
    methods( Static, Access = private )
        
        function this = getInstance()
            this = fx.maven.AddOnManager();
        end
        
    end
    
end