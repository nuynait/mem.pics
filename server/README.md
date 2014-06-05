# Server Development README

This folder contains all the development for backend server


# Working with Server Dev

## Clone only the Server Branch 

	`git clone -b server --single-branch git://github.com/shan199105/mem.pics.git`


## Create Your Own Local Branch

	`git checkout -b server-local`

## When Finished, Switch to Remote Branch, Update

	`git checkout server`

	`git pull origin server`

## Switch to Local Branch, Rebase Remote Branch

	`git checkout server-local`
	
	`git rebase server`

## Switch to Remote Branch, Rebase Local Branch

	`git checkout server`

	`git rebase server-local`


## Finally, Push to Server

	`git push origin server`
