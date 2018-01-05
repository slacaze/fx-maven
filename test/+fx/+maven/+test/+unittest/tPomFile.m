classdef tPomFile < fx.maven.test.WithCleanWorkingDirectory
    
    properties
        FilePath = 'pom.xml'
    end
    
    properties( TestParameter )
        PropertyName = {...
            'ArtifactId',...
            }
        Token = {...
            'artifactId',...
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
        
        function testCheckTokenUpdate( this, PropertyName, Token )
            pomFile = fx.maven.PomFile( this.FilePath );
            this.verifyEqual( pomFile.(PropertyName), '' );
            pomFile.(PropertyName) = 'SomeValue';
            this.verifyEqual( pomFile.(PropertyName), 'SomeValue' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'SomeValue', Token ) ), 1 );
            pomFile.(PropertyName) = 'Some Other Value';
            this.verifyEqual( pomFile.(PropertyName), 'Some Other Value' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 0 );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'Some Other Value', Token ) ), 1 );
        end
        
    end
    
    methods( Access = private )
        
        function setProp( ~, pomFile, propName, propValue )
            pomFile.(propName) = propValue;
        end
        
    end
    
end