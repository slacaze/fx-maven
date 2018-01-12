classdef PomFile < fx.maven.internal.File
    
    properties( GetAccess = protected, Constant )
        ValidNames = 'pom[.]xml'
        TestSuitesTagName = 'testsuites';
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        ArtifactId(1,:) char
        GroupId(1,:) char
        TestPackages(:,2) cell
    end
    
    properties( GetAccess = private, SetAccess = private, Dependent )
        PomDom fx.maven.internal.Xml
        Project fx.maven.internal.Xml
        Properties fx.maven.internal.Xml
        TestSuites fx.maven.internal.Xml
    end
    
    methods
        
        function value = get.PomDom( this )
            value = fx.maven.internal.Xml( xmlread( this.FilePath ) );
        end
        
        function value = get.Project( this )
            recursive = false;
            value = this.PomDom.getElementsByTagName( 'project', recursive );
            assert( isscalar( value ), ...
                'Maven:InvalidPom', ...
                'The POM must have a single project.' );
        end
        
        function value = get.Properties( this )
            project = this.Project;
            if ~isempty( project )
                recursive = false;
                value = project.getElementsByTagName( 'properties', recursive );
                fx.maven.util.mustBeEmptyOrScalar( value );
            else
                value = fx.maven.internal.Xml.empty;
            end
        end
        
        function value = get.TestSuites( this )
            propertiesNode = this.Properties;
            value = fx.maven.internal.Xml.empty;
            if ~isempty( propertiesNode )
                properties = propertiesNode.children();
                position = 1;
                for propertyIndex = 1:numel( properties )
                    property = properties( propertyIndex );
                    suite = regexpi( property.TagName, '^testsuites[.](.*)$', 'once', 'tokens' );
                    if ~isempty( suite )
                        value(position) = property;
                        position = position + 1;
                    end
                end
            end
        end
        
    end
    
    methods
        
        function value = get.ArtifactId( this )
            recursive = false;
            artifactElement = this.Project.getElementsByTagName( 'artifactId', recursive );
            assert( isscalar( artifactElement ), ...
                'Maven:MissingArtifactId', ...
                'The artifactId is missing from "%s".', ...
                this.FilePath );
            value = artifactElement.Text;
        end
        
        function value = get.GroupId( this )
            recursive = false;
            groupElement = this.Project.getElementsByTagName( 'groupId', recursive );
            assert( isscalar( groupElement ), ...
                'Maven:MissingGroupId', ...
                'The groupId is missing from "%s".', ...
                this.FilePath );
            value = groupElement.Text;
        end
        
        function value = get.TestPackages( this )
            testSuitesElements = this.TestSuites;
            if ~isempty( testSuitesElements )
                suiteNames = regexpi( {testSuitesElements.TagName}, '^testsuites[.](.*)$', 'once', 'tokens' );
                suiteNames = [suiteNames{:}]';
                suitePackages = {testSuitesElements.Text}';
                value = [ ...
                    suiteNames, ...
                    suitePackages, ...
                    ];
            else
                value = cell.empty( 0, 2 );
            end
        end
        
    end
    
    methods( Access = public )
        
        function this = PomFile( path )
            this@fx.maven.internal.File( path );
        end
        
    end
    
end