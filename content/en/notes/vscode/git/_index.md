---
title: "Git"
date: 2021-08-01T14:17:54+08:00
draft: true
---
TODO: draft: true
## How to use git on vscode
see here: https://youtu.be/IdhnP00Y1Ks?t=631


## Color theme in diffEditor
add
```
          "workbench.colorCustomizations": {
          //     "diffEditor.removedTextBackground": "#330011",
          //     "diffEditor.insertedTextBackground": "#000033"
          "diffEditor.insertedTextBorder": "#00b33c",
          "diffEditor.removedTextBorder": "#e60000",
           },
 ```
 to `settings.json` to make the differences a little bit clearer.
 Customize the background color (e.g. `"diffEditor.removedTextBackground": "#330011"`, or `"diffEditor.insertedTextBackground": "#000033"`) is somehow useless since these action remove the highlighted differences in line.
 
 This issue remains unsolved seems some people feel it's better to have theme pick good colors. See
 https://stackoverflow.com/questions/49036101/how-to-change-diff-color-visual-studio-code
 https://github.com/microsoft/vscode/issues/71663