# Playtopia Database Project - CS3200 Final Project

This repo contains the same setup that our flask-mysql-boilerplate contained to create 3 Docker containers: 
1. A MySQL 8 container
1. A Python Flask container
1. A Local AppSmith Server

## Project Description
The Playtopia database project is a project designed to help the fictitious brick and mortar video game retailer Playtopia manage their customers, stores, inventory, and more. Playtopia was founded in 2003 in Newton, Massachusetts. Playtopia has grown significantly since 2003 in size. Due to their rewards system that can be redeemed for future discounts on purchases, they have many loyal returning customers. However, their current customer and inventory management systems are serviceable but unsatisfactory as system silos restrict opportunities for the advanced analysis required to help educate company decision makers and guide their long term strategy as a business.
Playtopia has commissioned the Jersey Crew group to create a robust inventory and customer management database. Playtopia hopes to increase accuracy of their data across all their store locations in order to help manage their costs and shrinking margins, while also providing a useful dataset for game developer marketers. 

## User Personas

This project was created with three different user personas for Playtopia in mind:
1. Game Hobbyist/Collector
2. Hobbyist Store Manager
3. Marketing Analyst for Third Party Game Developer

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 


## Project Credits

The "Jersey Crew" is three students of Dr. Fontenot's CS3200 class listed below:

1. Vinay Thomas - thomas.vin@northeastern.edu
2. Cynthia Chen - chen.cyn@northeastern.edu
3. Alex Karousos - karousos.a@northeastern.edu

