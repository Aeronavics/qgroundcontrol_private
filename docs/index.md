# Introduction

This is the developer guide for Aeronavics QGroundControl fork.
This document follow up all the changes from the mainline and will describe the architecture-specific changes from Aeronavics QGC.

# Development Strategy

This work follows the migration process intended for Aeronavics to move from MissionPlanner (Ground control software part of the ArduPilot stack) to QGroundControl.  
This migration was intended to propose a nicer and simpler UI to Aeronavics customers that will expose only the relevant features to the user.   
This version of QGC denominated Aeronavics QGC is a private fork of QGroundControl with respect to the open source license applied on this software.   
It will only contain the features that are not relevant to share with the mainline for the listed reasons :   

- This feature is specific to Aeronavics product and thus non-relevant for the common QGC users
- This feature is valuable for Aeronavics and enter in the intellectual property of the company

For the majority of features that are bug fix or UI improvements it will be shared with the mainline.   
In fact, sharing with the mainline offer us some extremely valuable review, test and feedback from the main maintainers and the community.    

This helps us to develop more reliable software with shorter time/resources.

This following parts will describe briefly the process used to develop a new feature in Aeronavics QGC.

## Project Organization

This project is tracked by a GitHub Project. Every bug, feature and enhancement are listed through issues that are classified by status : 

[Link to the project](https://github.com/orgs/Aeronavics/projects/3)

- Todo : Corresponds to the backlog, every issues are put in there
- Release : Corresponds to the issues that needs to be addressed for the next release
- In Progress : Issue ongoing, with an associated dev branch
- Waiting for review : Issue with an associated PullRequest ongoing
- Done : Issue close/merged

## Git Repositories

Aeronavics owns 2 git repositories that are related to QGroundControl: 

### [The private repository](https://github.com/Aeronavics/qgroundcontrol_private)
This is only accessible from the Aeronavics organization, is based on the mainline and contains all changes made to QGroundControl by Aeronavics developers.   
This repository contains changes adopted by the mainline as well as changed made in this qgroundcontrol_private repo.   
This repository is used to create release binaries of QGroundControl through a Jenkins pipeline.



### [The public fork](https://github.com/Aeronavics/qgroundcontrol) 
This is a git repository that follow the mainline and will contain development branches for all the features shared with the mainline.
    This repository is mainly used to send Github Pull Requests to the main maintainers.

# Development Work flow

## Private Repository 

When it's relevant the master branch of this repository will be updated with the mainline. In practice it occurs when a new stable version of QGC is released or 
as soon a Pull-Request from an Aeronavics Developer is merged (This to insure that our work from the public repo ends in the private repo as soon as possible).

While developing a private feature, an issue will be raised explaining why and how this will be implemented.    
An associated dev branch will be created and will contains commits from this feature.
As soon as this feature is tested and stable, the developer open a Pull-Request on the private repo. This code is review and merged to the master branch.


## Generate a release package

The prod branch is used for releases : As soon as master is stable, it will be merged in "prod" branch via a Pull-Request. 

The merge action will trigger the release pipeline that will compile
a release installers for every target (Windows, Linux, Android) and upload a new release package on [Nexus](https://services.aeronavics.com/nexus).


## Public Feature

While developing a public feature, an associate issue will be raise in the mainline repository to explain the reason of the fix/feature and describing the work to be intended.   

Once the discussion started with the mainline and the feature/fix is specified, a dev branch will be created on Aeronavic public fork.
When this branch is stable and tested, a Pull-Request will be open on the mainline repository. After review/discussions and iteration on the dev branch, this branch will be merged into the mainline master branch.   

As soon as practicable, the private repository should be updated with the mainline after a P.R. has been accepted. 



