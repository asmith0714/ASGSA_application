# README

## Introduction ##

Our team is developing an application for the Animal Science Graduate Student Association of Texas A&M University (ASGSA). This will be a web application that will be used as a member tracking interface for the organization. Members of the organization will be able to log in through their own accounts and have the ability to view important information, track their status (points) within the organization, and connect with other members. Additionally, officers of the organization will have hold accounts with elevated permissions to carry out their responsibilities, including creating organization events, sending out notifications, and assigning points to members through a check in system.

## Requirements ##

This code has been run and tested on:

* Ruby - 3.1.2p20
* Rails - 7.1.3
* Ruby Gems - Listed in `Gemfile`
* PostgreSQL - 13.7 
* Nodejs - v18.19.0
* Yarn - 1.22.18

## External Deps  ##

* Docker - Download latest version at https://www.docker.com/products/docker-desktop
* Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
* Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

## Installation ##

Download this code repository by using git:

 `git clone https://github.com/nicknguyen72/ASGSA_Application.git`

## Documentation

Our product and sprint backlog can be found in Jira, with project name Wade

`https://asgsa.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog`


## Tests ##

An RSpec test suite is available and can be ran using:

  `rspec spec/`

## Execute Code ##

Run the following code in Powershell if using windows or the terminal using Linux/Mac

  `cd ASGSA_Application`

  `docker run -it --volume "${PWD}:/directory" -e DATABASE_USER=scraper_user -e DATABASE_PASSWORD=scraper_password -p 3000:3000 paulinewade/csce431:latest`

* Note: directory is where the app code is located. If you want to re-enter an existing container, run the following:
  docker start -ai determined_dubinsky (determined_dubinsky is the name of the docker container)

Install the app

  `bundle install && rails webpacker:install && rails db:create && db:migrate`

Run the app
  `rails server --binding:0.0.0.0`

The application can be seen using a browser and navigating to http://localhost:3000/

## Environmental Variables/Files ##

Google OAuth2 support requires two keys to function as intended: Client ID and Client Secret

Create a new file called application.yml in the /config folder and add the following lines:

  `GOOGLE_OAUTH_CLIENT_ID: 'YOUR_GOOGLE_OAUTH_CLIENT_ID_HERE'`

  `GOOGLE_OAUTH_CLIENT_SECRET: 'YOUR_GOOGLE_OAUTH_CLIENT_SECRET_HERE'`


## Deployment ##

Setup a Heroku account: https://signup.heroku.com/

From the heroku dashboard select `New` -> `Create New Pipline`

Name the pipeline, and link the respective git repo to the pipline

Our application does not need any extra options, so select `Enable Review Apps` right away

Click `New app` under review apps, and link your test branch from your repo

Under staging app, select `Create new app` and link your main branch from your repo

--------

To add enviornment variables to enable google oauth2 functionality, head over to the settings tab on the pipeline dashboard

Scroll down until `Reveal config vars`

Add both your client id and your secret id, with fields `GOOGLE_OAUTH_CLIENT_ID` and `GOOGLE_OAUTH_CLIENT_SECRET` respectively

Now once your pipeline has built the apps, select `Open app` to open the app

With the staging app, if you would like to move the app to production, click the two up and down arrows and select `Move to production`

And now your application is setup and in production mode!


## CI/CD ##

For continuous development, we set up Heroku to automatically deploy our apps when their respective github branches are updated.

  `Review app: test branch`

  `Staging app: main branch`

  `Production app: main branch`

For continuous integration, we set up a Github action to run our specs, security checks, linter, etc. after every push or pull-request. This allows us to automatically ensure that our code is working as intended.

## References ##

- https://stackoverlfow.com
- https://chat.openai.com
- https://guides.rubyonrails.org/index.html

## Support ##

All users looking for support should first look at the FAQ page linked in the footer.

If further assistance is required, users should navigate to the Contact Us page linked in the footer and fill out the support form, and a representative from the support team will get back to you.

The support of this app has been officially closed as the support team has been
reassigned to other projects. No major features remain for development and any bugs
are no longer responsibility of the dev team.

