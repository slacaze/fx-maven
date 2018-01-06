classdef tPomFile < fx.maven.test.WithCleanWorkingDirectory
    
    properties
        FilePath = 'pom.xml'
    end
    
    properties( TestParameter )
        PropertyName = {...
            'ArtifactId',...
            }
        PropertyValue = {...
            'maven',...
            }
    end
    
    methods( TestMethodSetup )
        
        function addPrjFile( this )
            copyfile( ...
                fullfile( maventestroot, 'Sample', 'pom.xml' ), ...
                fullfile( this.Root, this.FilePath ) );
        end
        
    end
    
    methods( Test, ParameterCombination = 'sequential' )
        
        function testCheckTokenUpdate( this, PropertyName, PropertyValue )
            pomFile = fx.maven.PomFile( this.FilePath );
            this.verifyEqual( pomFile.(PropertyName), PropertyValue );
        end
        
    end
    
    methods( Access = private )
        
        function setProp( ~, pomFile, propName, propValue )
            pomFile.(propName) = propValue;
        end
        
    end
    
end