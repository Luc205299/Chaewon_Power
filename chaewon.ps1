$folderPath = "..../Chae" #Insert your path to the folder

function Get-Chaewon {
    param (
        [string]$folderPath
    )
    $images = Get-ChildItem -Path $folderPath -File
    Write-Host "Looking for nice pictures in '$folderPath'..."
    Write-Host "'$($images.Count)' images found."

    # Load the image
    if ($images) {
        $randomImage = $images | Get-Random
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        # Close the previous window if one exists
        if ($global:form) {
            $global:form.Close()
            $global:form.Dispose()
        }
        
        # Create a new window
        $global:form = New-Object Windows.Forms.Form
        $global:form.Text = "Chaewon <3"
        $global:form.StartPosition = "CenterScreen"
        
        # Load the image
        $image = [System.Drawing.Image]::FromFile($randomImage.FullName)
        
        # Resize the image
        $newWidth = $image.Width / 4
        $newHeight = $image.Height / 4
        $image = [System.Drawing.Image]::FromFile($randomImage.FullName).GetThumbnailImage($newWidth, $newHeight, $null, [intptr]::Zero)
        
        # Adjust image size if it's larger than the screen
        $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
        $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

        if ($newWidth -gt $screenWidth -or $newHeight -gt $screenHeight) {
            if ($newWidth -gt $screenWidth) {
                $newWidth = $screenWidth
                $newHeight = [math]::Round($image.Height * ($screenWidth / $image.Width))
            }
            if ($newHeight -gt $screenHeight) {
                $newHeight = $screenHeight
                $newWidth = [math]::Round($image.Width * ($screenHeight / $image.Height))
            }
            $image = [System.Drawing.Image]::FromFile($randomImage.FullName).GetThumbnailImage($newWidth, $newHeight, $null, [intptr]::Zero)
        }

        $pictureBox = New-Object Windows.Forms.PictureBox
        $pictureBox.Image = $image
        $pictureBox.SizeMode = "AutoSize"
        $pictureBox.Dock = "Fill"
        $global:form.Controls.Add($pictureBox)
        $global:form.ClientSize = $image.Size
        
        # Use Show() instead of ShowDialog() to allow the script to continue
        $global:form.Show()
    } else {
        Write-Host "No images found in '$folderPath'."
    }
}

function Close-Chaewon {
    if ($global:form) {
        $global:form.Close()
        $global:form.Dispose()
        $global:form = $null
    }
}

# Start by displaying the first image
Get-Chaewon -folderPath $folderPath

# Loop to display a new image every second and close the previous one
while ($true) {
    Start-Sleep -Seconds 3
    Close-Chaewon
    Get-Chaewon -folderPath $folderPath

    # If a key is pressed, exit the loop
    if ([System.Console]::KeyAvailable) {
        Write-Host "Bye Bye Chaewon! Exiting..."
        Close-Chaewon
        break
        
    }
}
