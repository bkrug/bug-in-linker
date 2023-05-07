# Assemble the files
$files = Get-ChildItem ".\" -Filter *.asm
ForEach($file in $files) {
    write-host 'Assembling' $file.Name
    $objFile = $file.Name.Replace(".asm", "") + ".obj.temp"
    xas99.py -q -S -R $file.Name -o $objFile
}

#Exit if assembly errors found
ForEach($file in $fileList) {
    $objFile = $file + '.obj'
    if (-not(Test-Path $objFile)) {
        $msg = $file + ' did not assemble correctly'
        write-host $msg -ForegroundColor Red
        exit
    }
}

# Link object files
xas99.py -l `
    DISPNUM.obj.temp `
    CONST.obj.temp `
    VAR.obj.temp `
    -o LINKED.obj

#Deleting old work files
write-host 'Deleting old work files'
Remove-Item '*.obj.temp'

# Add TIFILES header to all object files
$objectFiles = Get-ChildItem ".\" -Filter *.obj
ForEach($objectFile in $objectFiles) {
    xdm99.py -T $objectFile.Name -f DIS/FIX80 -o $objectFile.Name
}