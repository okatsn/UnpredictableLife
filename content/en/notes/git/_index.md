---
title: "Git"
date: 2021-08-05T17:24:17+08:00
draft: false
---


### Initiate/Clone
- `git init`: initiate the current directory as a git repository
- `git clone https://github.com/someones/ACertainRepo.git`: copy the repository of other's to local

### Add
- `git remote add origin https://github.com/yourname/YourRepo.git`: create a remote named `origin` and establish the connection between local and the remote.

- `git add -A`: make every file to be tracked and stage all changes (i.e., make all of them ready to be committed)

### Commit and push

- `git commit -am "whatever message is OK"`: stage all changes of tracked files and commit; untracked files won't be committed.


- `git push --set-upstream origin master`: Setting `master` as upstream means that from now on the target branch is set to be the `master`, and you can push and pull without specifying the target branch. 

> 💩 Explain furthermore:
> - ["origin" is a shorthand name for the remote repository that a project was originally cloned from.](https://www.git-tower.com/learn/git/glossary/origin/)

### Handling file renames in Git
`git mv css/iphone.css css/mobile.css`
See [this](https://stackoverflow.com/questions/2641146/handling-file-renames-in-git).

