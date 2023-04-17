CREATE DATABASE PlaytopiaDB;

USE PlaytopiaDB;

SHOW TABLES;

CREATE TABLE Customers
(
    customer_id integer AUTO_INCREMENT                NOT NULL,
    age         integer unsigned                      NOT NULL,
    gender      ENUM ('Male', 'Female', 'Non-binary') NOT NULL,
    first_name  varchar(50)                           NOT NULL,
    last_name   varchar(50)                           NOT NULL,
    email       varchar(100) UNIQUE                   NOT NULL,
    phone       varchar(20) UNIQUE                    NOT NULL,
    PRIMARY KEY (customer_id)
);

insert into Customers
values (1, 53, 'Female', 'Romola', 'Rooze', 'rrooze0@linkedin.com', '305-161-8119'),
       (2, 6, 'Female', 'Julianna', 'Canada', 'jcanada1@mayoclinic.com', '488-177-6303'),
       (3, 15, 'Female', 'Rafaelia', 'Correa', 'rcorrea2@purevolume.com', '677-919-2376'),
       (4, 53, 'Male', 'Anders', 'Braunthal', 'abraunthal3@privacy.gov.au', '376-740-9675'),
       (5, 31, 'Male', 'Zollie', 'Caser', 'zcaser4@instagram.com', '252-223-0479'),
       (6, 17, 'Non-binary', 'Alvy', 'McKew', 'amckew5@canalblog.com', '467-467-5963'),
       (7, 44, 'Female', 'Gelya', 'McAlinion', 'gmcalinion6@economist.com', '314-426-5283'),
       (8, 61, 'Female', 'Elfreda', 'Lamping', 'elamping7@microsoft.com', '804-967-2292'),
       (9, 21, 'Male', 'Ulrick', 'Duffyn', 'uduffyn8@nature.com', '793-880-0609'),
       (10, 43, 'Female', 'Joeann', 'Vittery', 'jvittery9@free.fr', '511-323-3723');

CREATE TABLE Employees
(
    employee_id   integer AUTO_INCREMENT             NOT NULL,
    first_name    varchar(50)                        NOT NULL,
    last_name     varchar(50)                        NOT NULL,
    hire_date     datetime DEFAULT current_timestamp NOT NULL,
    hourly_pay    DECIMAL(10, 2)                     NOT NULL,
    supervisor_id int                                NOT NULL,
    PRIMARY KEY (employee_id),
    CONSTRAINT supervisor FOREIGN KEY (supervisor_id) REFERENCES Employees (employee_id)
);

insert into Employees
values (1, 'Tybie', 'Twaite', '2022-05-13', 50.87, 1),
       (2, 'Jenifer', 'Meadmore', '2023-03-09', 45.17, 2),
       (3, 'Georgianna', 'Whaley', '2022-11-20', 41.74, 1),
       (4, 'Pearline', 'Yateman', '2022-07-27', 42.03, 4),
       (5, 'Debi', 'Barde', '2022-05-13', 48.83, 3),
       (6, 'Silvia', 'Groarty', '2022-11-20', 25.23, 2),
       (7, 'Tonnie', 'Walkowski', '2022-11-20', 26.57, 4),
       (8, 'Ulysses', 'Pucknell', '2022-11-20', 49.81, 4),
       (9, 'Fawnia', 'Sappson', '2022-11-20', 59.32, 4),
       (10, 'Gracia', 'Paulat', '2022-11-20', 36.87, 4);

CREATE TABLE Orders
(
    order_id          integer AUTO_INCREMENT             NOT NULL,
    order_date        datetime DEFAULT current_timestamp NOT NULL,
    transaction_value DECIMAL(10, 2)                     NOT NULL,
    employee_id       integer                            NOT NULL,
    customer_id       integer                            NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT OrdersEmployees
        FOREIGN KEY (employee_id) REFERENCES Employees (employee_id),
    CONSTRAINT OrdersCustomers
        FOREIGN KEY (customer_id) REFERENCES Customers (customer_id)
);

insert into Orders
values (1, 2023-04-07, 10.00, 1, 1),
       (2, 2022-03-24, 114.32, 5, 3),
       (3, 2023-04-07, 24.02, 2, 2);

CREATE TABLE OnlineOrders
(
    online_order_id integer AUTO_INCREMENT NOT NULL,
    region          varchar(50)            NOT NULL,
    postal_code     varchar(10)            NOT NULL,
    state           varchar(50)            NOT NULL,
    address         varchar(50)            NOT NULL,
    city            varchar(50)            NOT NULL,
    order_id        integer                NOT NULL,
    PRIMARY KEY (online_order_id, order_id),
    CONSTRAINT OOrders
        FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE cascade
);

insert into OnlineOrders
values (1,'US', '02120', 'Massachusetts', '123 Sunny Drive', 'Boston', 1),
       (2,'US', '77777', 'Nevada', '567 Casino Ave', 'Las Vegas', 2);

CREATE TABLE Distributors
(
    distributor_id integer AUTO_INCREMENT NOT NULL,
    name           varchar(50)            NOT NULL,
    email          varchar(100) UNIQUE    NOT NULL,
    PRIMARY KEY (distributor_id)
);

insert into Distributors
values (1, 'Wholesale Inc', 'wholesale@wholesale.com'),
       (2, 'Media Discount LLC', 'media@discount.com');

CREATE TABLE Developers
(
    developer_id integer AUTO_INCREMENT NOT NULL,
    name         varchar(50)            NOT NULL,
    PRIMARY KEY (developer_id)
);

insert into Developers
values (1, 'Hal Inc'),
       (2, 'Supercell');

CREATE TABLE Games
(
    game_id        integer AUTO_INCREMENT             NOT NULL,
    name           varchar(100)                       NOT NULL,
    release_year   datetime DEFAULT current_timestamp NOT NULL,
    sales_price    DECIMAL(9, 2)                      NOT NULL,
    cust_rating    integer,
    age_rating     varchar(20)                        NOT NULL,
    console        varchar(20)                        NOT NULL,
    developer_id   integer                            NOT NULL,
    distributor_id integer                            NOT NULL,
    PRIMARY KEY (game_id),
    CONSTRAINT GamesDev
        FOREIGN KEY (developer_id) REFERENCES Developers (developer_id),
    CONSTRAINT GamesDistributor
        FOREIGN KEY (distributor_id) REFERENCES Distributors (distributor_id),
    CHECK (sales_price > 0)
);

insert into Games
values (1, 'Super Smash Bros Melee', '2001-11-27', 59.99, 5, 'E10+', 'Gamecube', 1, 1),
       (2, 'Clash Royale', '2012-01-01', 2.99, 3, 'E', 'Phone', 2, 2);

CREATE TABLE Order_Details
(
    order_id integer AUTO_INCREMENT NOT NULL,
    game_id  integer                NOT NULL,
    discount decimal(5, 2)          NOT NULL,
    quantity integer                NOT NULL,
    PRIMARY KEY (order_id, game_id),
    CONSTRAINT OrdDet_Orders
        FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON UPDATE cascade,
    CONSTRAINT OrdDet_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade,
    CHECK (discount <= 1)
);

insert into Order_Details
values (1, 1, 0.75, 2),
       (2, 2, 0, 10);

CREATE TABLE Publishers
(
    publisher_id   integer AUTO_INCREMENT NOT NULL,
    publisher_name varchar(50)            NOT NULL,
    developer_id   integer                NOT NULL,
    PRIMARY KEY (publisher_id),
    CONSTRAINT Publishers_Devs
        FOREIGN KEY (developer_id) REFERENCES Developers (developer_id)
);

insert into Publishers
values (1, 'Nintendo', 1),
       (2, 'Supercell, Inc.', 2);

CREATE TABLE Distributor_Publishers
(
    distributor_id integer AUTO_INCREMENT NOT NULL,
    publisher_id   integer                NOT NULL,
    PRIMARY KEY (distributor_id, publisher_id),
    CONSTRAINT DistrPub_Distr
        FOREIGN KEY (distributor_id) REFERENCES Distributors (distributor_id) ON UPDATE cascade,
    CONSTRAINT DistrPub_Pub
        FOREIGN KEY (publisher_id) REFERENCES Publishers (publisher_id) ON UPDATE cascade
);

insert into Distributor_Publishers
values (1, 1),
       (2, 2);

CREATE TABLE Genres
(
    genre_id    integer AUTO_INCREMENT NOT NULL,
    description text                   NOT NULL,
    genre_name  varchar(30),
    PRIMARY KEY (genre_id)
);

insert into Genres
values (1, 'Graphic violence and fighting', 'Fighting'),
       (2, 'Skillfull, board-game like strategy ', 'Tower Defense');

CREATE TABLE Game_Genres
(
    genre_id    integer AUTO_INCREMENT NOT NULL,
    game_id     integer                NOT NULL,
    description text                   NOT NULL,
    PRIMARY KEY (genre_id, game_id),
    CONSTRAINT GameGenres_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade,
    CONSTRAINT GameGenres_Genres
        FOREIGN KEY (genre_id) REFERENCES Genres (genre_id) ON UPDATE cascade
);

insert into Game_Genres
values (1, 1, 'Fighting'),
       (2, 2, 'Tower Defense');

CREATE TABLE Customer_Games
(
    customer_id  integer AUTO_INCREMENT NOT NULL,
    game_id      integer                NOT NULL,
    resell_price DECIMAL(9, 2),
    PRIMARY KEY (customer_id, game_id),
    CONSTRAINT CustGames_Customers
        FOREIGN KEY (customer_id) REFERENCES Customers (customer_id) ON UPDATE cascade,
    CONSTRAINT CustGames_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade,
    CHECK (resell_price > 0)
);

insert into Customer_Games
values (1, 1, 10.95),
       (2, 2, null);

CREATE TABLE Inventory_Stats
(
    inventory_stats_id integer AUTO_INCREMENT             NOT NULL,
    time_arrived       datetime DEFAULT current_timestamp NOT NULL,
    quantity           integer                            NOT NULL,
    game_id            integer                            NOT NULL,
    returned_quantity  integer                            NOT NULL,
    PRIMARY KEY (inventory_stats_id),
    CONSTRAINT InvStats_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade,
    CHECK (quantity >= 0),
    CHECK (returned_quantity >= 0)
);

insert into Inventory_Stats
values (1, '2004-04-05', 10, 1, 1),
       (2, '2016-12-30', 53, 2, 0);

