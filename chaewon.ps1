$folderPath = "..../Chae" #Insert your path to the folder



$images = Get-ChildItem -Path $folderPath -File

Write-Host "Looking for a nice pictures '$folderPath'..."
Write-Host "'$($images.Count)' Images found."

#Load the image
if($images){
    $randomImage = $images | Get-Random
    

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object Windows.Forms.Form
    $form.Text = "Chaewon <3"
    $form.StartPosition = "CenterScreen"

    $image = [System.Drawing.Image]::FromFile($randomImage.FullName)

    $pictureBox = New-Object Windows.Forms.PictureBox
    $pictureBox.Image = $image
    $pictureBox.SizeMode = "AutoSize"
    $pictureBox.Dock = "Fill"

  
    $form.Controls.Add($pictureBox)
    $form.ClientSize = $image.Size
    $form.ShowDialog()
} else {
    Write-Host "Aucune image trouvée dans le dossier '$folderPath'."
}

