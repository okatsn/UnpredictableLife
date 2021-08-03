---
title: "LaTeX with vscode"
linkTitle: "LaTeX"
date: 2021-07-26T14:18:23+08:00
draft: false
---

[TOC]


## download
- download [texlive](http://tug.org/texlive/), run `install-tl-windows.exe` **as administrator**.
  - it takes several hours to install
  - you may alternatively choose `other methods`> `Downloading one huge ISO file`>`texlive.iso` > unzip > execute  `install-tl-windows.bat`
    - **`install-tl-windows.bat` and associated files must be placed at the system disk (e.g. C:\\)**
  - It is unnecessary to install TexWorks.
### check integrity of the file (optional)
- open command window
- go to the directory where there is the texlive2020.iso
  - e.g. `cd D:\Users\HSI\Downloads`
- `CertUtil -hashfile texlive2020.iso SHA512` to get the checksum, and compare the result with that of the owners side. (e.g. `texlive2020.iso.sha512` on the official website). [see this for more information](https://security.stackexchange.com/questions/189000/how-to-verify-the-checksum-of-a-downloaded-file-pgp-sha-etc)

## installation

- add `C:\texlive\2020\bin` to PATH (系統內容>進階>環境變數>PATH反白>編輯>新增>確定) (or add `C:\texlive` to PATH)
- make sure `C:\Users\HSI\AppData\Local\Programs\Microsoft VS Code\bin` is also added to PATH

- install LaTeX Workshop in VS Code
  - `james-yu.latex-workshop`, James Yu

- Configure editor settings in `settings.json`
  - file > Preferences > Settings
  - <img src="png\EditInSettingsJSON.png" />

```
\\添加编译工具。LaTeX Workshop 默认包含了几种编译工具，对中文用户来说一般需要把 XeLaTeX 添加进去。
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "-pdf",
            "%DOC%"
            ]
          },
          {
            "name": "xelatex",
            "command": "xelatex",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "%DOC%"
              ]
          },          
          {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "%DOC%"
            ]
          },
          {
            "name": "bibtex",
            "command": "bibtex",
            "args": [
            "%DOCFILE%"
            ]
          }
        ],
\\添加编译方案(因應xelatex)：相应的，我们还需要添加一些编译方案。
\\latex-workshop.latex.recipes暂时只能使用第一个（这个观点来自于https://www.meiwen.com.cn/subject/cejdrxtx.html）
    "latex-workshop.latex.recipes": [
          {
            "name": "xelatex -> bibtex -> xelatex*2",
            "tools": [
            "xelatex",
            "bibtex",
            "xelatex",
            "xelatex"
                        ]
                  }, \\ for generating bibliography

          {
            "name": "xelatex",
            "tools": [
            "xelatex"
                        ]
                  }, \\ if this is put to the very first, it generates pdf faster than "xelatex -> bibtex -> xelatex*2", but cannot read citations from XXXX.bib
                  

 
          {
            "name": "latexmk",
            "tools": [
            "latexmk"
                        ]
          },
          
          {
            "name": "pdflatex -> bibtex -> pdflatex*2",
            "tools": [
                "pdflatex",
                "bibtex",
                "pdflatex",
                "pdflatex"
            ]
          }, \\ similar to "xelatex -> bibtex -> xelatex*2",
        ],
        
    "latex-workshop.latex.clean.fileTypes": [
            "*.aux",
            "*.bbl",
            "*.blg",
            "*.idx",
            "*.ind",
            "*.lof",
            "*.lot",
            "*.out",
            "*.toc",
            "*.acn",
            "*.acr",
            "*.alg",
            "*.glg",
            "*.glo",
            "*.gls",
            "*.ist",
            "*.fls",
            "*.log",
            "*.fdb_latexmk"
          ],
          
————————————————
版权声明：本文为CSDN博主「liu6tot」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/liu6tot/java/article/details/104243625
```

no use
```
      "latex-workshop.synctex.afterBuild.enabled": true, // 启用反向搜索 （在 PDF 预览器中按下 Ctrl + ←，同时鼠标点击要反向搜索的位置）
```

- for other settings in `settings.json`, see [link](https://blog.ceba.tech/2018/11/Visual-Studio-Code-LaTeX/index.html), [link](https://zhuanlan.zhihu.com/p/38178015), [link](), [link](https://blog.csdn.net/liu6tot/article/details/104243625)
- For setting zotero, see (https://zhuanlan.zhihu.com/p/108095566)


### explanation
[also see this](https://tex.stackexchange.com/questions/354196/bbl-file-not-generated), and [this:"vscode latex 踩坑记 ： 文献索引 bib 文件和setting.json的那点事"](https://blog.csdn.net/lishu14/article/details/102774145)
- the `bibtex` command in `"xelatex -> bibtex -> xelatex*2"` or `"pdflatex -> bibtex -> pdflatex*2"` is for generating the `.bbl` file, which is necessary for bibliography using bibtex.
You should run bibtex or biblatex to generate the bbl file. It is not done automatically.
What I used to do, is first run pdflatex and then bibtex followed by two times pdflatex. Because Bibtex needs the auxiliary file to generate the bbl file.


## instruction to the basics

### Start
- se vscode to open a `xxx.tex` file
- click the TEX button on the left (below the button for packages) to show commands for latex workshop
- View latex PDF file (`Ctrl`+`Alt`+`V`)

### Sync
- `Ctrl`+`Right Click`: Sync backward (Jump to the line according to cursor in PDF)
- `Ctrl` + `Alt` + `j`: Sync forward (Jump to the line according to cursor in tex)

### other settings
- switch word wrap on and off: 
  - add `"editor.wordWrap":"on",` in `settings.json`, or
  - <img src="png\EditorWordWrap.png" />


## Reference
https://blog.ceba.tech/2018/11/Visual-Studio-Code-LaTeX/index.html
https://zhuanlan.zhihu.com/p/108095566
https://blog.csdn.net/zxyhappiness/article/details/98639094

## Others
### other recipes
#### 2020-09-17 work properly except bibtex bibliography
Rendering the bibliography from an outer `.bib` file failed because `.bbl` is not created. To create `.bbl` file, as described before, `bibtex` is required.
```
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "-pdf",
            "%DOC%"
            ]
          },
          {
            "name": "xelatex",
            "command": "xelatex",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "%DOC%"
              ]
          },          
          {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "%DOC%"
            ]
          },
          {
            "name": "bibtex",
            "command": "bibtex",
            "args": [
            "%DOCFILE%"
            ]
          }
        ],
        
    "latex-workshop.latex.recipes": [
      
    
          {
            "name": "xelatex",
            "tools": [
            "xelatex"
                        ]
                  },
                  
          {
            "name": "xelatex -> bibtex -> xelatex*2",
            "tools": [
            "xelatex",
            "bibtex",
            "xelatex",
            "xelatex"
                        ]
                  },
 
          {
            "name": "latexmk",
            "tools": [
            "latexmk"
                        ]
          }
        ],
        
```

#### for vscode latex-workshop for Mac
```
     "latex-workshop.latex.recipes": [
        {
          "name": "xelatex",
          "tools": [
            "xelatex"
          ]
        },
        {
          "name": "xelatex -> bibtex -> xelatex*2",
          "tools": [
            "xelatex",
            "bibtex",
            "xelatex",
            "xelatex"
          ]
        }
      ],
      "latex-workshop.latex.tools": [
        {
          "name": "latexmk",
          "command": "latexmk",
          "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "-pdf",
            "%DOC%"
          ]
        },
        {
          "name": "xelatex",
          "command": "xelatex",
          "args": [
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "%DOC%"
          ]
        },
        {
          "name": "bibtex",
          "command": "bibtex",
          "args": [
            "%DOCFILE%"
          ]
        }
      ],
```

# Latex in general

## resources that might be useful
[Frequently Asked Question List for TeX](http://www.texfaq.org/index#bibliographies)
[latex math](https://en.wikibooks.org/wiki/LaTeX/Mathematics)
[BibTeX, natbib, biblatex](https://guides.library.yale.edu/bibtex/workshop)
## Explanation
### hyperlink examples
- For using `\href` or `\url`, right after `\documentclass` (e.g. `\documentclass{gji}`) we have to add
  - `\usepackage[urlcolor=blue,citecolor=black,linkcolor=black]{hyperref}` 
  - or simply `\usepackage{hyperref}`

- in manuscript, add url using `\href` or `\url`, for example: 
  - `\href{https://academic.oup.com/gji/pages/General_Instructions}{\textcolor{blue}{\underline{journal website}}}`
  - `\url{https://ccjou.wordpress.com/2012/05/25/%E5%BF%AB%E9%80%9F%E5%82%85%E7%AB%8B%E8%91%89%E8%BD%89%E6%8F%9B/}`


## packages
### general
```tex
\usepackage{graphicx} % to enable includegraphics[]{...}
\usepackage{amsmath} % for latex math
\usepackage[hidelinks]{hyperref} % Allows clickable reference lists
\usepackage{hyperref} % Allows clickable reference lists
```


## command
```latex
\documentclass{gji} % refer to gji.cls

\bibliographystyle{plain} % default
% \bibliographystyle{gji} % use gji.bst
% \bibliographystyle{apsrmp4-1} % use apsrmp4-1.bst
% \bibliographystyle{apalike} % use the built-in apa-like bibliography style
\bibliography{main}% Produces the bibliography via BibTeX, on main.bbl
```

- ["the use of \bibliographystyle without using BibTeX is useless; that command is solely for BibTeX's benefit."](https://latex.org/forum/viewtopic.php?t=24571)

## citations and references
### manually enter the entries
#### `\thebibilography`

#### `\begin{references}`
(not figured out yet)
```latex
\begin{references}
\reference
\end{references}
```
[generate references with and without BibTex](https://www.cnblogs.com/yifdu25/p/8330652.html)
### bibtex
- The best practice is to keep tex and bibtex has the same name, e.g., `main.tex` and `main.bib`, since bibtex must be run on the auxiliary file (e.g. `main.aux`), not the bibtex database. For more details, see [this](https://faculty.math.illinois.edu/~hildebr/tex/bibliographies0.html).

- [Simple tutorial for how to use bibtex](https://blog.csdn.net/caiandyong/article/details/70258670)

### biblatex
https://tex.stackexchange.com/questions/12175/biblatex-submitting-to-a-journal/12185#12185

### natlib (that allows `\citet`, `\citep`, etc.)
- http://merkel.texture.rocks/Latex/natbib.php?lang=en
- https://www.itread01.com/content/1544600046.html

You can generate the `natbib.sty` by `\...\yourpath\containing\the\file> LaTeX natbib.ins`. Read the documentation. I never successfully apply this style yet. 

## error 
### stupid error
- in some cases the naming in `.bib` file may cause error. For example, in my paper of 2019 of Chaos, it is ok to have entries with bottom line (e.g. `@Article{telesca_2017,...}`) but for gji class (`gji.cls`), bottom line should be removed (e.g. `@Article{telesca2017,...}`) otherwise error occurred using "xelatex -> bibtex -> xelatex*2".
- white space between entries in one `\cite{...}`. e.g.: 
  - `\cite{tomblabla2002, jerrymewmew2001}` will raise an error
  - `\cite{tomblabla2002,jerrymewmew2001}` is ok
- If a package that was able to be properly built but failed now, try to build using the same device that was used; and sync on vscode across devices may solve the problem.

## Lessons from Template for Geophysical Journal International (GJIRAS)
Here is the [official template](https://www.overleaf.com/latex/templates/template-for-geophysical-journal-international-gjiras/zjhxtdhcnprg) for GJI publication.
However, the template `gjiguide2e.tex` or `gji_extraguide.tex` alone does not produce the correct format; we have to not only integrate the two but with some additional packages in order to make it work correctly.

Based on the `gjiguide2e.tex` template:
```
\documentclass{gji} % refers to gji.cls 

%% SECTION I %%
\usepackage{timet,color}

% \author, \title \date \pubyer... etc. are not displayed here

%% SECTION II %%
\begin{document}
\label{firstpage}

% from abstract to acknowledgments...

%% SECTION III %%

\label{lastpage}
\end{document}

```
we can enable the following functionality:

- **Hyperlink of citation to bibliography**: add `\usepackage[urlcolor=blue,citecolor=black,linkcolor=black]{hyperref}` to `SECTION I`
- **to enable `includegraphics[]{...}`**: add `\usepackage{graphicx}` to `SECTION I`
- **to enable latex math**: add `\usepackage{amsmath}` to `SECTION I`
- **additional facilities (allow `\citet`, `\citep`, etc.)**: 
  - change `\documentclass{gji}` to `\documentclass[extra]{gji}`
  - Add `\usepackage{gji_extra}` to `SECTION I`. This is superfluous; at the end of `gji.cls` we can see `gji_extra.sty` has already been used:
    ```
    \ifGJ@extra
    \def\refname{REFERENCES}
    \usepackage{gji_extra}
    \fi
    ```
  - disable/delete `\usepackage{timet}` in `SECTION I`; otherwise it applies `timet.sty` and the previous `\usepackage{gji_extra}` is voided.
- producing the bibliography via BibTeX. 
  - add `\bibliographystyle{gji}` in `SECTION I`
  - Add for example `\bibliography{main}` in `SECTION III` right before `\label{lastpage}`.
  - In this example, `main.bib` have to be generated (use Zotero with BetterBibTex is recommended)
    
The modified one with all facilities above applied will be like:
```
\documentclass[extra]{gji} % refer to gji.cls 
\usepackage[urlcolor=blue,citecolor=black,linkcolor=black]{hyperref}
\usepackage{graphicx} % to enable includegraphics[]{...}
\usepackage{amsmath} % for latex math
\bibliographystyle{gji} 

\usepackage{gji_extra} % This is superfluous, 
% since this in fact the second time executes `\usepackage{gji_extra}`; 
% the first time is in the end of `gji.cls` as the `extra` option is specified.

% \author, \title \date \pubyer... etc. are not displayed here

\begin{document}
\label{firstpage}

% from abstract to acknowledgments...

\bibliography{main}% Produces the bibliography via BibTeX. (e.g. main.bib)
\label{lastpage}
\end{document}

```

Other key points I learned:

- `gji.bst` is created automatically when applying `\bibliographystyle{gji}`. The content are generated according to bibtex (e.g., `main.bib`).

If there is something in generating the `.bst` file (i.e. it is not properly generated), you can temporarily use a built-in bibliography style while editing (for example, use `\bibliographystyle{apalike}` instead). If unfortunately the bug have not able been found, we can manually copy-and-paste the entries in the `.bbl` file that generated with the not-working bibliography style into the manuscript after the manuscript is 100% ready.
> After the article is finished, generate the `.bbl` file with `\bibliographystyle{gji}`, then copy the `\thebibliography` section inside and manually fix all the error, and replace `\bibliography{main}` by this modified `\begin{thebibliography}{}...\end{thebibliography}` section (i.e. delete `\bibliography{main}` and put the `\thebibliography` section right before `\label{lastpage}` and `\end{document}`.

- Why use BetterBibTeX?

If not Better BibTeX, error may occurred due to some defects in the auto-generated `.bib` file (e.g., incorrect line break; unnecessary information, etc.).

#### The submission style
Output the one-column version of copy by switching from `\documentclass[extra]{gji}` to `\documentclass[extra,mreferee]{gji}`.

# Other topic
## Tikz

Press `ctrl+shift+enter` to execute all codes in `.md` file in vscode editor and display the results on Markdown Preview Enhanced

```latex {cmd=true, hide=false}
\documentclass{standalone}
\usepackage{tikz}
\begin{document}
\begin{tikzpicture}

\draw[thick,->] (-1.5,0) -- (6.5,0) node[anchor=north west] {$t$};
\draw[thick,->] (0,-3.5) -- (0,3.5) node[anchor=south east] {$y$};
\foreach \x in {-1,0,1,2,3,4,5,6}
\draw (\x cm,2pt) -- (\x cm,-0pt) node[anchor=north] {$\x$};
\foreach \y in {-3,-2,-1,1,2,3}
\draw (2pt,\y cm) -- (-0pt,\y cm) node[anchor=east] {$\y$};
\draw[step=1.0 ,help lines, thin] (-1.5,-3.5) grid (6.5,3.5);	


\draw[rotate=-90, color=red] (-2.45,6) parabola bend (0,0) (2.45,6);
\draw (6,2.45) node[above] {$\sqrt{t}$}; % Latex Math
\draw (6,-2.45) node[below] {$-\sqrt{t}$}; % Latex Math
% \draw (3,2.0) node[rotate=11, color=red] {$\mathrm{std}(X_t)$}; % Latex Math
\draw (3,2) node[rotate=0, color=black] {$\mathrm{std}(X_t)$}; % Node label in Latex Math
\draw[thick] (0,0) -- (1,1) -- (2,2) -- (3,1) -- (4,2) -- (5,3) -- (9,-1);
\draw[dashed, thick] (1,1) -- (2,0);

\end{tikzpicture}
\end{document}
```

or use pgfplots
```latex {cmd=true, hide=false}
\documentclass{standalone}
\usepackage{tikz}
\usepackage{pgfplots}
\usetikzlibrary{matrix}
\begin{document}
\begin{tikzpicture}
\begin{axis}[ % please \usepackage{pgfplots} first
axis lines = middle,
xlabel=$ t$, ylabel=$ y$,
xmin=-1.5, xmax=10,
ymin=-3.5, ymax=4,
xtick distance=1, ytick distance=1 % try also xtick={0,...,4}, xtick distance=2
]
% Plot line/curve according to a parametric equation
% Line styles: dashed, solid... and many more
\addplot[domain=-6:6,samples=40, dashed] ({x^2},{x});
% Plot a point and a label
% set 1. angle away from the point; 2. label string; 3. the coordinate of the point
% `180` means the label will be put on west; similarly, `0` on east, `90` on north, etc. 
\node[label={90:{$\mathrm{std}(X_t)=\sqrt{t}$}}] at (axis cs:8,2.7) {};
% NOTE that NO COMMENT inside the table {}
% use line break to separate new points
% You may also try `table {datafile.dat}`
% you may delete `mark=o` to make markers solid
% you may delete `only marks` to have marks linked
\addplot [mark=o] table {
0 0
1 1
2 2
3 1
4 2
5 3
6 2
};
\addplot [dashed] table {
6 2
9 -1
};

% Plot a point and a label
% set 1. angle away from the point; 2. label string; 3. the coordinate of the point
% `180` means the label will be put on west; similarly, `0` on east, `90` on north, etc. 
\node[label={-90:{Simple Random Walk}}] at (axis cs:4,1) {};
\end{axis}
\end{tikzpicture}
\end{document}
```