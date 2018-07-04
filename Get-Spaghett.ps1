function Get-Spaghett{
<#
.SYNOPSIS
    Quickly Find out much spaghetti can fit into a given object

.DESCRIPTION
    Determines the size and units cubed of the object to be measured against, then uses known sizes of spaghetti noodles to determine how many would be needed to fill the given container

.PARAMETER Container
    The name of the container in question. This is the only parameter required when using the AUTO flag

.PARAMETER Size
    Unit agnostic size of the container. Must be the volume for the math to work out right.

.PARAMETER UnitCubed
    The actual unit of the size of the box. Currently only "Foot" and "Meter" are supported. Can be abbreviated to "ft" and "m", respectively. 

.PARAMETER Auto
    Switch to check CSV for measurements. CSV contains pre-loaded data for quick use. Only requires the CONTAINER parameter for proper lookups

.PARAMTER List
    Lists the Container names for all containers in the CSV.

.EXAMPLE
    PS C:\WINDOWS\system32> Get-Spagett -container "Box" -size 7 -unitCubed "ft"

    SPAGETT REPORT
    ---------------

    Container Chosen: Box

    Interior Space for Spagetti Insertion: 7 

    1 ft^3 = 28316.8 cm^3

    7 ft^3 = 198217.6 cm^3

    Spaghetti Volume: 0.864 cm^3

    Number of noodles in Box : 229418.52


.NOTES
    Author: Wabbadabba

    ChangeLog
    ---------
    4July2018 -- First Iteration. Foot and Meter Supported. CSV Support is working.  

#>

    Param(
        [string] $container,
        [float]  $size,
        [string] $unitCubed,
        [switch] $auto,
        [switch] $list

    )
    $Objects = Import-Csv $PSScriptRoot\Objects.csv

    # Spagetti Dimension Calculations --VERY IMPORTANT-- 
    $spaghettD = 2
    $spaghettR = $spaghettD / 2
    $spaghettHeight = 275
    $spaghettVolume = [math]::Round((3.14 * ($spaghettR * $spaghettR) * $spaghettHeight) / 1000, 3)


    # Lists out all Containers within the CSV File 
    if ($list){
        Write-Host "All Containers in CSV:`n"

        $Objects.Container

        break
    }

    # Checks Entries in the CSV, uses entry values if entry is valid.
    if ($auto){
        $input = $Objects.Where({$PSItem.Container -eq $container})
        if ($input.Container.length -eq 0){
            Write-host "NO VALID ENTRIES"
            break
        }
        else{
        $size = $input.Size 
        $unitCubed = $input.UnitCubed
        }

    }

    # cubic foot to cubic centimeter conversion
    if ($unitCubed -eq "foot" -or $unitCubed -eq "ft"){
        $conversion = 28316.8
        $abbr = "ft"
        $sizeToCM3 = [math]::Round($size * $conversion, 2)
    }
    #cubic meter to cubic centimeter conversion
    elseif($unitCubed -eq "meter" -or $unitCubed -eq "m"){
        $abbr = "m"
        $conversion = 1000000
        $sizeToCM3 = [math]::Round($size * $conversion, 2)
    }
    
    $noodles = [math]::Round($sizeToCM3 / $spaghettVolume, 2)

    # Output
    Write-Host @"

SPAGETT REPORT
---------------

Container Chosen: $container

Interior Space for Spagetti Insertion: $size 

1 $abbr^3 = $conversion cm^3

$size $abbr^3 = $sizeToCM3 cm^3

Number of noodles in $container : $noodles

"@ 

}
