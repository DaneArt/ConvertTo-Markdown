Function ConvertTo-Markdown {
    <#

    .Synopsis
    Converts a PowerShell object to a Markdown table.
    
    .Description
    Converts a PowerShell object to a Markdown table.

    .Parameter InputObject 
    PowerShell object to be converted
   
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
                # List the properties of the object, doing so in this manner maintains the order
                $Properties = $Object.PSObject.Properties | Select-Object -ExpandProperty "Name"
                # Table headers
                [string]$Properties
                # Lines under table headers
                [string]($Properties | ForEach-Object {"-" * $_.Length})
            }
            ForEach ($item in $Object){
                [string](
                    $Properties | ForEach-Object {
                        if ($item.($_)){
                            $item.($_).ToString().Replace("`n","").Replace("`r","")
                        } else {
                            " "
                        }
                    }
                )
            }
        }
    }
    End {

    }
}