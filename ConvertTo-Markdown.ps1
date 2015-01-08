Function ConvertTo-Markdown {
    <#

    .Synopsis
    Converts a PowerShell object to a Markdown table.
    
    .Description
    Converts a PowerShell object to a Markdown table.

    .Parameter InputObject 
    The PowerShell object to be converted
   
    .Example 
    ConvertTo-Markdown -InputObject (Get-Service)

    Converts a list of running services on the local machine to a Markdown table

    .Example
    ConvertTo-Markdown -InputObject (Import-CSV "C:\Scratch\lwsmachines.csv") | Out-File "C:\Scratch\file.markdown" -Encoding "ASCII"

    Converts a CSV file to a Markdown table

    .Example
    Import-CSV "C:\Scratch\lwsmachines.csv" | ConvertTo-Markdown | Out-File "C:\Scratch\file2.markdown" -Encoding "ASCII"

    Converts a CSV file to a markdown table via the pipeline.

    .Notes
    Ben Neise 10/09/14

    #>
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [PSObject[]]$InputObject
    )
    Begin {
        $OFS = " | "
        $i = 0
    }
    Process {
        ForEach ($Object in $InputObject){
            $i ++
            if ($i -eq 1){
                $Properties = $Object | Get-Member | Where-Object {$_.MemberType -eq "Property" -or $_.MemberType -eq "NoteProperty"}
                [string]$Properties.Name
                [string]($Properties | ForEach-Object {"-" * $_.Name.Length})
            }
            ForEach ($item in $Object){
                [string](
                    $Properties | ForEach-Object {
                        if ($item.($_.Name)){
                            $item.($_.Name).ToString().Replace("`n","").Replace("`r","")
                        }
                    }
                )
            }
        }
    }
    End {

    }
}