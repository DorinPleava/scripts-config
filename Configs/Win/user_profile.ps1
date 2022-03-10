# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# conda prompt activate
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
$env:Path += ';C:\Users\S2907AF\AppData\Roaming\npm' 

Import-Module posh-git
Import-Module oh-my-posh
$omp_config = Join-Path $PSScriptRoot ".\dorin.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
# Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
# Set-Alias ls Get-ChildItem | Format-Wide -autosize
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias vim 'C:\Program Files\Vim\vim82\vim.exe'

function lss
{
    Get-ChildItem | Format-Wide -autosize
}
function gitfetchall {
  git fetch --all
}
function gitpristine {
  git reset --hard
  git clean -dffx
}

Set-Alias gpristine gitpristine
Set-Alias ls lss
Set-Alias gfa gitfetchall

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Ctrl+Alt+j then type a key to mark the current directory.
# Alt+J to show the current shortcuts in a popup
# Ctrj+j then the same key will change back to that directory without
# needing to type cd and won't change the command line.
#pre-populate a global variable
$global:PSReadlineMarks = @{
  [char]"w"="D:\Work"
  [char]"e"="D:\Work\pev-simulation-engine"
  [char]"r"="D:\Work\pev-scenario-runner"
  [char]"p"="D:\Work\charging-planner-app"
  }
  Set-PSReadlineKeyHandler -Key Ctrl+Alt+j -BriefDescription MarkDirectory -LongDescription "Mark the current directory. [$($env:username)]" -ScriptBlock {
  #press a single character to mark the current directory
      $key = [Console]::ReadKey($true)
      if ($key.keychar -match "\w") {
          $global:PSReadlineMarks[$key.KeyChar] = $pwd
      }
      else {
          [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
          Write-Warning "You entered an invalid character."
          [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
      }
  }
  Set-PSReadlineKeyHandler -Key Ctrl+j -BriefDescription JumpDirectory -LongDescription "Goto the marked directory.[$($env:username)]" -ScriptBlock {
      $key = [Console]::ReadKey()
      $dir = $global:PSReadlineMarks[$key.KeyChar]
      if ($dir)
      {
          cd $dir
          [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
      }
  }
  Set-PSReadlineKeyHandler -Key Alt+j -BriefDescription ShowDirectoryMarks -LongDescription "Show the currently marked directories in a popup. [$($env:username)]" -ScriptBlock {
      $data = $global:PSReadlineMarks.GetEnumerator() | Where {$_.key} | Sort key 
      $data | foreach -begin {
       $text=@"
Key`tDirectory
---`t---------
"@
       } -process { 
       
       $text+="{0}`t{1}`n" -f $_.key,$_.value
       } 
       $ws = New-Object -ComObject Wscript.Shell
       $ws.popup($text,10,"Use Ctrl+J to jump") | Out-Null
       
       [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
     
  }

  
