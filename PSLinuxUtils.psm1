<#
.SYNOPSIS

Function to convert text output from a shell command to objects 
.DESCRIPTION

Converts text output from a shell command to objects. Useful for taking output from native commands for
even Python scripts and converting them to deserialized objects for use in PowerShell 
.PARAMETER InputObject

The line of text that needs to be converted to an object 
.EXAMPLE
ps

.EXAMPLE

ps | Convertto-Object | sort-object CPU 

#>
function Convertto-Object
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [object]
        $InputObject
    )

    Begin{
        $script:Objects = @()
        $script:Titles = @()
    }

    Process {
        $script:Objects += $InputObject
    }

    End {
    
        # first line should be property names
        $TitleString = $script:Objects[0]
        $script:Titles = Get-Title -TitleString $TitleString
        
        $startindex = 1

        # if titles are underscored, skip the underscore line 
        if ($script:Objects[1] -match '---') {
            $startindex = 2
        }

        # parse each line to get the values and create objects 
        $startindex .. ($script:Objects.Count - 1) | ForEach-Object {
                    
            $values = Get-Value -ValueString $script:Objects[$_]

            $map = @{}
            for($i=0; $i -lt $Titles.Count; $i++) {
                $map += @{$Titles[$i]=$values[$i]}                
            }

            New-Object -TypeName psobject -Property $map 
        }
    }
}

function Get-Title
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        $TitleString,

        [Parameter(Position=1)]
        $Separator = ' '
    )

    Get-Value -ValueString $TitleString -Separator $Separator  
}

function Get-Value
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        $ValueString,

        [Parameter(Position=1)]
        $Separator = ' '
    )

    $Options = [System.StringSplitOptions]::RemoveEmptyEntries
    $ValueString.Split($Separator, $Options)
}