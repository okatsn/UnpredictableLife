---
linkTitle: "Coding with Jupyter"
title: "Install Jupyter lab without Anaconda"
date: 2021-07-26T14:18:23+08:00
draft: false
---

[TOC]

## Install julia and IJulia
- e.g. Run `julia-1.5.0-win64.exe`
- pkg> `add IJulia` (or `using Pkg`; `Pkg.add("IJulia")`);

## Install jupyterlab using `pip`
- install python
- cmd> `pip install jupyterlab`
- cmd> `pip install notebook`
  - classical notebook

To Run the notebook:
- cmd> `jupyter notebook`
To Run the JupyterLab:
- cmd> `jupyter lab`

### Ref
[what is pip](https://realpython.com/what-is-pip/)
[install jupyterlab](https://jupyter.org/install.html)
## Install `Conda` and configuring Julia to work with JupyterLab
[also see](https://subscription.packtpub.com/book/application_development/9781788998369/1/ch01lvl1sec23/configuring-julia-to-work-with-jupyterlab)
```julia
using Pkg
Pkg.add("Conda");
Pkg.build("Conda"); # required otherwise error will occur while using Conda
using Conda
Conda.add("jupyterlab"); # automatically download and install miniconda
```
## Upgrade jupyter
- cmd> `pip install -U jupyter`
and
- cmd> `pip install --upgrade jupyterlab`


## Install variable inspector for julia in jupyter lab
- cmd> `git clone https://github.com/lckr/jupyterlab-variableInspector`
- cmd> `cd jupyterlab-variableInspector`
- cmd> `npm install`
  - if error occurred, see if `npm -v` and `node -v`
    - if the version of `npm` and `nodejs` were printed, then they are correctly installed.
    - if not, install `node.js`, where `npm` will be installed automatically. 
      - **without additional tools** (e.g. chocolatey) seems to be Okay
    - after installed, **close command window and re-open it** again (as administrator) is required.
- cmd> `npm run build`
- cmd> `jupyter labextension install .`
In final
- cmd> `jupyter labextension list`
  - if you see `enabled` and `ok` are printed, the extension is correctly installed
- right click in jupyterlab to open variable inspector
[Reference](https://github.com/lckr/jupyterlab-variableInspector)

# Further reading
[How to set up your jupyter lab environment](https://towardsdatascience.com/how-to-setup-your-jupyterlab-project-environment-74909dade29b)

[28 Jupyter Notebook Tips, Tricks, and Shortcuts](https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/)

["jupyter lab build" failed on windows with encoding GBK](https://github.com/jupyterlab/jupyterlab/issues/8600)

[How to change the working directory of Jupyter](https://shanyitan.medium.com/how-to-change-the-working-directory-of-jupyter-and-jupyter-lab-on-windows-environment-bbe5a5a99f05)