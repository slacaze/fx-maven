classdef WithCleanWorkingDirectory < matlab.unittest.TestCase
    
    properties( GetAccess = protected, SetAccess = private )
        Root(1,:) char = char.empty
    end
    
    methods( TestMethodSetup )
        
        function getCleanWorkingDirectory( this )
            fixture = matlab.unittest.fixtures.TemporaryFolderFixture();
            this.applyFixture( fixture );
            this.Root = fixture.Folder;
            fixture = matlab.unittest.fixtures.CurrentFolderFixture( this.Root );
            this.applyFixture( fixture );
        end
        
    end
    
end