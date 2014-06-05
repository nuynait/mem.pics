# IOS Development README

This folder contains all the development for ios app


# Working with IOS Dev

## Clone only the IOS Branch 

	`git clone -b ios --single-branch git://github.com/shan199105/mem.pics.git`


## Create Your Own Local Branch

	`git checkout -b ios-local`

## When Finished, Switch to Remote Branch, Update

	`git checkout ios`

	`git pull origin ios`

## Switch to Local Branch, Rebase Remote Branch

	`git checkout ios-local`
	
	`git rebase ios`

## Switch to Remote Branch, Rebase Local Branch

	`git checkout ios`

	`git rebase ios-local`


## Finally, Push to Server

	`git push origin ios`
