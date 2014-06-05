# WebApp Development README

This folder contains all the development for web app


# Working with WebApp Dev

## Clone only the WebApp Branch 

	`git clone -b webapp --single-branch git://github.com/shan199105/mem.pics.git`


## Create Your Own Local Branch

	`git checkout -b webapp-local`

## When Finished, Switch to Remote Branch, Update

	`git checkout webapp`

	`git pull origin webapp`

## Switch to Local Branch, Rebase Remote Branch

	`git checkout webapp-local`
	
	`git rebase webapp`

## Switch to Remote Branch, Rebase Local Branch

	`git checkout webapp`

	`git rebase webapp-local`


## Finally, Push to Server

	`git push origin webapp`

