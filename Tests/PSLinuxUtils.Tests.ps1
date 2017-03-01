$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here${directorySeparatorChar}$sut"

Describe "PSLinuxUtils" {
    $Commands = Get-Command -Module PSLinuxUtils

    It "Test required number of commands are exposed" {
        $Commands.Count | Should be 1 
    }

    It "Test Convertto-Object is exposed" {
        $Commands[0].Name | Should be "Convertto-Object"
    }

    It "Test Convertto-Object has help" {
        Get-Help $Commands[0] | Should not be $null 
    }

    It "Test text without ---" {
        $text = @("FirstName  LastName")
        $text += @("Nana Lakshmanan")

        $results = $text | Convertto-Object 
        $results[0].FirstName | Should be 'Nana'
        $results[0].LastName | Should be 'Lakshmanan'
    }

    It "Test text with ---" {
        $text = @("FirstName  LastName")
        $text += @("--------  --------")
        $text += @("Nana Lakshmanan")

        $results = $text | Convertto-Object 
        $results[0].FirstName | Should be 'Nana'
        $results[0].LastName | Should be 'Lakshmanan'
    }

    It "Test text with spaces" {
        $text = @("   FirstName      LastName")
        $text += @("--------   --------")
        $text += @("Nana       Lakshmanan    ")

        $results = $text | Convertto-Object 
        $results[0].FirstName | Should be 'Nana'
        $results[0].LastName | Should be 'Lakshmanan'
    }
}
