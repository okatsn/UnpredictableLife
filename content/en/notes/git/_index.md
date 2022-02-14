---
title: "Git"
date: 2021-08-05T17:24:17+08:00
draft: false
---

## Initiate/Clone
- `git init`: initiate the current directory as a git repository
- `git clone https://github.com/someones/ACertainRepo.git`: copy the repository of other's to local

## Add
- `git remote add origin https://github.com/yourname/YourRepo.git`: create a remote named `origin` and establish the connection between local and the remote.

- `git add -A`: make every file to be tracked and stage all changes (i.e., make all of them ready to be committed)

## Commit and push

- `git commit -am "whatever message is OK"`: stage all changes of tracked files and commit; untracked files won't be committed.


- `git push --set-upstream origin master`: Setting `master` as upstream means that from now on the target branch is set to be the `master`, and you can push and pull without specifying the target branch. 

> 💩 Explain furthermore:
> - ["origin" is a shorthand name for the remote repository that a project was originally cloned from.](https://www.git-tower.com/learn/git/glossary/origin/)

## Handling file renames in Git
`git mv css/iphone.css css/mobile.css`
See [this](https://stackoverflow.com/questions/2641146/handling-file-renames-in-git).

## Working with remote repo

### `fetch` (download commits)
`git fetch` download commits and new data from remote, but it **DOES NOT** integrate any of these new data to your working files.

Update with the remote (local files will not change) using 
- `git fetch` or `git fetch <remote name>`: update with one remote
- `git fetch --all` (or equivalently `git remote update`): update with all remotes

### list branches
and then you can list the branches by either
- `git branch -v -a` (all the branches available for checkout with)
- `git branch -r` (all the remote branches)
- `git branch -a` (all the local and remote branches)
> or use `git status` to see all remote branches for merge if an upstream has already been set.

### `pull` (download commits and merge)
`git pull` download commits and files, **AND** merge your current HEAD branch with the remote `master`.


`git pull` is equivalent to 
```
git fetch github
git merge remotes/github/master
```
, whereas `git pull --rebase` is equivalent to 
```
git fetch github
git rebase remotes/github/master
```

for example, we can merge local `master` with the remote one using:
```
git checkout master
git pull # solve the conflicts using `merge`
```

or 
```
git checkout master
git pull --rebase # solve the conflicts using `rebase`
```
> if no upstream has been defined, is required; for example, `git pull <option> <remote name> <branch name>`



> **💡 Hint:**
> - Use `git merge --abort` to return the state before your merge.
> 
> **📖 More readings:**
> - [How merge dealing with conflicts](https://www.git-tower.com/learn/git/ebook/en/command-line/advanced-topics/merge-conflicts)
> - [同步遠端分支](https://zlargon.gitbooks.io/git-tutorial/content/remote/sync.html)

### `checkout`, `switch` and `restore`
`checkout` is split into `switch` and `restore`; in which
- `switch`: "checking out a branch to work on advancing its history"
- `resotre`: "checking out paths out of the index and/or a tree-ish to work on advancing the current history"

For more details, see [this simple tutorial](https://bluecast.tech/blog/git-switch-branch/) and [this thread](https://stackoverflow.com/questions/57265785/whats-the-difference-between-git-switch-and-git-checkout-branch).