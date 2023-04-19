DROP DATABASE IF EXISTS PlaytopiaDB;
CREATE DATABASE IF NOT EXISTS PlaytopiaDB;

grant all privileges on PlaytopiaDB.* to 'webapp'@'%';
flush privileges;

USE PlaytopiaDB;

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

CREATE TABLE Distributors
(
    distributor_id integer AUTO_INCREMENT NOT NULL,
    name           varchar(50)            NOT NULL,
    email          varchar(100) UNIQUE    NOT NULL,
    PRIMARY KEY (distributor_id)
);


CREATE TABLE Developers
(
    developer_id integer AUTO_INCREMENT NOT NULL,
    name         varchar(50)            NOT NULL,
    PRIMARY KEY (developer_id)
);

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
        FOREIGN KEY (developer_id) REFERENCES Developers (developer_id) ON DELETE CASCADE,
    CONSTRAINT GamesDistributor
        FOREIGN KEY (distributor_id) REFERENCES Distributors (distributor_id) ON DELETE CASCADE,
    CHECK (sales_price > 0)
);

CREATE TABLE Order_Details
(
    order_id integer AUTO_INCREMENT NOT NULL,
    game_id  integer                NOT NULL,
    discount decimal(5, 2)          NOT NULL,
    quantity integer                NOT NULL,
    PRIMARY KEY (order_id, game_id),
    CONSTRAINT OrdDet_Orders
        FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT OrdDet_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade ON DELETE cascade,
    CHECK (discount <= 1)
);

CREATE TABLE Publishers
(
    publisher_id   integer AUTO_INCREMENT NOT NULL,
    publisher_name varchar(50)            NOT NULL,
    developer_id   integer                NOT NULL,
    PRIMARY KEY (publisher_id),
    CONSTRAINT Publishers_Devs
        FOREIGN KEY (developer_id) REFERENCES Developers (developer_id)
);


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

CREATE TABLE Genres
(
    genre_id    integer AUTO_INCREMENT NOT NULL,
    description text                   NOT NULL,
    genre_name  varchar(30),
    PRIMARY KEY (genre_id)
);


CREATE TABLE Game_Genres
(
    genre_id    integer AUTO_INCREMENT NOT NULL,
    game_id     integer                NOT NULL,
    description text                   NOT NULL,
    PRIMARY KEY (genre_id, game_id),
    CONSTRAINT GameGenres_Games
        FOREIGN KEY (game_id) REFERENCES Games (game_id) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT GameGenres_Genres
        FOREIGN KEY (genre_id) REFERENCES Genres (genre_id) ON UPDATE cascade ON DELETE cascade
);

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

INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (1,'Delbert','Reaper','dreaper0@google.ru','Male','818-912-1011',28);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (2,'Randie','Gosswell','rgosswell1@vinaora.com','Male','233-213-4901',66);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (3,'Gaston','Troutbeck','gtroutbeck2@bloglovin.com','Male','811-311-1925',67);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (4,'Hymie','Joskovitch','hjoskovitch3@joomla.org','Male','462-137-0329',78);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (5,'Cortney','Strotton','cstrotton4@businessinsider.com','Female','230-809-0133',48);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (6,'Orelle','Care','ocare5@nih.gov','Female','917-990-8045',24);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (7,'Yulma','Bakey','ybakey6@rakuten.co.jp','Male','101-765-5455',27);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (8,'Paolina','Curwen','pcurwen7@xinhuanet.com','Female','897-151-9617',24);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (9,'Sumner','Wedmore.','swedmore8@sogou.com','Male','719-310-0697',19);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (10,'Graham','Coppins','gcoppins9@cnet.com','Male','368-239-7084',84);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (11,'Brigitta','Wynett','bwynetta@comcast.net','Female','835-658-5148',23);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (12,'Hunfredo','Purkiss','hpurkissb@patch.com','Male','705-509-7204',23);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (13,'Cyrus','Willoughway','cwilloughwayc@unesco.org','Male','648-148-6503',52);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (14,'Dulcie','Batalle','dbatalled@bloglovin.com','Female','488-377-3400',24);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (15,'Gale','Schwanden','gschwandene@exblog.jp','Male','999-627-0287',78);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (16,'Hedi','Langman','hlangmanf@intel.com','Female','136-120-3476',61);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (17,'Damaris','Dunderdale','ddunderdaleg@sitemeter.com','Female','491-500-7671',13);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (18,'Kathleen','Revely','krevelyh@myspace.com','Female','327-561-1892',29);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (19,'Stillmann','Hurdman','shurdmani@51.la','Male','750-643-8325',34);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (20,'Pierre','Dance','pdancej@youtube.com','Male','933-862-4899',75);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (21,'Felicity','Carlos','fcarlosk@unicef.org','Female','640-504-2848',9);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (22,'Paxton','Isacsson','pisacssonl@wikispaces.com','Male','447-767-2067',10);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (23,'Rodger','Dulake','rdulakem@miitbeian.gov.cn','Male','794-715-4145',61);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (24,'Symon','Stoyell','sstoyelln@ucoz.com','Male','799-153-4852',48);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (25,'Ritchie','Frigout','rfrigouto@usgs.gov','Male','441-406-4399',62);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (26,'Josefina','Chansonne','jchansonnep@liveinternet.ru','Female','962-489-8057',53);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (27,'Parker','Faires','pfairesq@g.co','Male','215-745-3313',52);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (28,'Hyacinth','Presdee','hpresdeer@netscape.com','Female','356-935-5362',77);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (29,'Charline','Bewly','cbewlys@vistaprint.com','Female','130-187-3234',37);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (30,'Melicent','Markovich','mmarkovicht@gravatar.com','Female','162-575-2820',77);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (31,'Lou','Collen','lcollenu@wordpress.com','Male','777-975-5986',66);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (32,'Sherye','Birdall','sbirdallv@wiley.com','Female','861-728-8246',15);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (33,'Brendon','Lynnett','blynnettw@mit.edu','Male','527-275-5858',51);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (34,'Madonna','Aindrais','maindraisx@youku.com','Female','219-816-1363',72);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (35,'Adeline','Blaxley','ablaxleyy@weather.com','Female','673-140-3977',84);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (36,'Gleda','Barron','gbarronz@flavors.me','Female','154-862-3990',77);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (37,'Reid','Varley','rvarley10@linkedin.com','Non-binary','510-248-1435',52);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (38,'Benjy','Walby','bwalby11@tripadvisor.com','Male','280-870-1062',47);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (39,'Veda','Scougal','vscougal12@state.gov','Female','865-891-7863',71);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (40,'Allie','Sorbie','asorbie13@networkadvertising.org','Non-binary','699-480-2576',66);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (41,'Marga','Rustich','mrustich14@live.com','Female','556-146-4137',15);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (42,'Tabby','Colnett','tcolnett15@multiply.com','Male','389-940-0776',27);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (43,'Regine','Sinkin','rsinkin16@discuz.net','Female','277-125-7424',51);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (44,'Carin','Quarry','cquarry17@constantcontact.com','Female','965-827-5620',80);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (45,'Fergus','McEllen','fmcellen18@cpanel.net','Male','935-576-4674',41);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (46,'Lissy','Curnucke','lcurnucke19@pbs.org','Female','477-494-3117',83);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (47,'Ninnette','Chillcot','nchillcot1a@tinyurl.com','Female','323-145-2571',45);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (48,'Obediah','Hatchette','ohatchette1b@ed.gov','Non-binary','126-286-5195',43);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (49,'Brade','Cohn','bcohn1c@dot.gov','Male','923-914-8760',22);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (50,'Kessiah','Bosnell','kbosnell1d@github.io','Non-binary','383-879-5589',70);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (51,'Karissa','Walewski','kwalewski1e@xing.com','Female','294-707-3120',78);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (52,'Jayne','Scarre','jscarre1f@spotify.com','Female','244-357-7703',20);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (53,'Adelina','Roddan','aroddan1g@cnn.com','Female','406-654-4558',85);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (54,'Maje','Imesen','mimesen1h@mysql.com','Male','384-144-0583',21);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (55,'Son','Giacomini','sgiacomini1i@dell.com','Non-binary','923-503-6237',58);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (56,'Mayor','Cowap','mcowap1j@businessinsider.com','Male','448-244-5919',12);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (57,'Iorgo','Tiplady','itiplady1k@chron.com','Male','650-922-3913',65);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (58,'Ynes','Arsnell','yarsnell1l@reuters.com','Female','446-466-5085',70);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (59,'Haze','Harwood','hharwood1m@reddit.com','Male','569-366-3868',8);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (60,'Helge','Habbert','hhabbert1n@godaddy.com','Non-binary','522-729-6464',57);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (61,'Charlotte','Wilcott','cwilcott1o@alexa.com','Female','321-601-6878',41);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (62,'Skippy','De La Haye','sdelahaye1p@i2i.jp','Non-binary','338-101-5817',19);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (63,'Nicol','Wilce','nwilce1q@plala.or.jp','Non-binary','190-466-1759',85);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (64,'Frasquito','Aimson','faimson1r@over-blog.com','Male','970-895-1345',14);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (65,'Robenia','Kidby','rkidby1s@discuz.net','Female','845-244-8771',81);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (66,'Eward','Rodolfi','erodolfi1t@bing.com','Male','756-435-2220',47);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (67,'Sonnie','Mechi','smechi1u@spiegel.de','Non-binary','292-969-8373',55);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (68,'Currie','Heads','cheads1v@patch.com','Male','762-549-2025',30);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (69,'Gus','Island','gisland1w@fc2.com','Male','134-606-2529',32);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (70,'Daisi','Wooles','dwooles1x@creativecommons.org','Female','725-359-1897',56);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (71,'Chaunce','Rostern','crostern1y@census.gov','Male','149-866-1082',56);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (72,'Deborah','Blaxill','dblaxill1z@instagram.com','Female','201-597-8030',16);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (73,'Shadow','Juarez','sjuarez20@deviantart.com','Male','477-780-6050',31);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (74,'Meyer','Sherar','msherar21@devhub.com','Male','201-802-2124',47);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (75,'Birch','Kintzel','bkintzel22@so-net.ne.jp','Male','870-364-6321',31);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (76,'Boothe','Bayston','bbayston23@angelfire.com','Male','753-440-9172',11);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (77,'Jenni','Kingswell','jkingswell24@goo.ne.jp','Female','644-175-3357',22);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (78,'Rossy','Spyer','rspyer25@phpbb.com','Male','178-666-5159',83);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (79,'Milissent','Leafe','mleafe26@slate.com','Female','541-234-7944',47);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (80,'Euphemia','Duxbury','eduxbury27@indiatimes.com','Female','582-941-8017',52);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (81,'Godfrey','Crinage','gcrinage28@imdb.com','Male','192-296-0388',9);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (82,'Gilberto','Garwill','ggarwill29@geocities.com','Male','404-302-0570',72);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (83,'Audra','Isles','aisles2a@ustream.tv','Female','885-537-2575',47);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (84,'Brenden','MacDirmid','bmacdirmid2b@comsenz.com','Male','830-530-7520',17);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (85,'Massimiliano','Deporte','mdeporte2c@bloomberg.com','Male','968-847-7470',82);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (86,'Alair','Chaplyn','achaplyn2d@diigo.com','Male','851-164-8952',19);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (87,'Eulalie','Lepard','elepard2e@earthlink.net','Female','328-766-9639',36);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (88,'Lamond','Camies','lcamies2f@baidu.com','Male','743-880-8867',29);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (89,'Rosemarie','Tour','rtour2g@shop-pro.jp','Female','613-157-1827',69);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (90,'Debra','Christoforou','dchristoforou2h@un.org','Non-binary','839-265-7033',12);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (91,'Stacy','Rudyard','srudyard2i@diigo.com','Female','711-549-8996',26);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (92,'Stefa','Klimsch','sklimsch2j@pen.io','Female','942-333-8465',56);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (93,'Justine','Iles','jiles2k@fda.gov','Female','727-341-8843',35);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (94,'Farleigh','Happer','fhapper2l@rakuten.co.jp','Male','961-640-1252',12);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (95,'Cullan','Bend','cbend2m@gizmodo.com','Male','775-977-1328',80);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (96,'Trula','Klais','tklais2n@deliciousdays.com','Female','355-578-5728',36);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (97,'Kandace','Heading','kheading2o@hibu.com','Female','313-830-6149',12);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (98,'Emmalynne','Coppard','ecoppard2p@mapquest.com','Female','445-152-2323',41);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (99,'Jilli','Bexon','jbexon2q@google.cn','Female','476-860-5076',37);
INSERT INTO Customers(customer_id,first_name,last_name,email,gender,phone,age) VALUES (100,'Israel','Rylands','irylands2r@ihg.com','Male','880-754-2524',52);

INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (1,'Lonni','McPeeters','2017-02-10',66.49,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (2,'Priscella','Pressnell','2001-09-01',50.03,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (3,'Philis','Paolo','2020-08-16',20.46,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (4,'Zebulon','Trevithick','2002-12-20',72.64,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (5,'Haven','Passe','2010-10-13',43.77,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (6,'Cesar','Noblett','2020-07-05',17.95,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (7,'Imojean','Hickinbottom','2006-10-28',74.94,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (8,'Denis','Hamsher','2019-04-22',26.82,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (9,'Sarah','Rodrigo','2016-04-17',93.6,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (10,'Alexandro','Ledstone','2018-06-23',51.58,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (11,'Shaine','Lechmere','2022-12-18',82.48,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (12,'Mendy','Lahrs','2019-04-03',96.27,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (13,'Nickie','Worledge','2009-04-11',84.85,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (14,'Broderick','Sorrill','2004-12-24',15.08,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (15,'Theodoric','Klaves','2020-03-29',26.2,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (16,'Shauna','Stormouth','2018-08-02',37.2,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (17,'Jenn','Buttriss','2021-02-10',63.97,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (18,'Christy','Braiden','2003-04-26',51.99,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (19,'Riki','Spoor','2006-06-08',27.47,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (20,'Nate','Ringe','2016-07-06',52.28,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (21,'Tine','Pakes','2005-06-05',18.57,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (22,'Uriah','Dorkins','2017-07-21',22.99,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (23,'Averell','Ridesdale','2008-02-15',75.65,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (24,'Murray','Fatharly','2014-12-21',79.68,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (25,'Sol','Clackson','2004-07-22',69.05,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (26,'Alaric','Lusted','2020-04-29',39.82,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (27,'Justin','Physic','2011-12-11',70.11,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (28,'Vivien','Siuda','2002-11-08',25.91,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (29,'Bernita','Levington','2006-04-06',78.56,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (30,'Francene','Darbishire','2022-12-02',80.59,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (31,'Audrie','Peinton','2011-08-08',62.73,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (32,'Ewell','Mulvin','2019-05-13',35.22,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (33,'Hinze','Absolom','2012-06-08',16.27,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (34,'Vera','Fasson','2018-08-25',74.9,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (35,'Vince','Warrell','2009-09-10',95.7,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (36,'Mufi','Haffard','2020-06-23',87.76,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (37,'Billie','Faas','2003-01-22',67.86,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (38,'Owen','Corsham','2016-12-29',56.1,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (39,'Abbey','Greason','2010-03-15',64.06,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (40,'Margalit','Harberer','2005-07-29',41.84,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (41,'Alverta','Diviny','2017-09-15',75.82,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (42,'Farley','Lundberg','2011-10-01',58.49,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (43,'Freda','Dahill','2005-06-12',78.4,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (44,'Dougy','Jaeggi','2021-09-22',36.3,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (45,'Gilburt','Tubb','2002-02-28',68.22,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (46,'Emeline','Langfitt','2012-06-20',78.24,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (47,'Brandtr','Reicharz','2019-05-19',97.81,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (48,'Anna','Bicksteth','2006-05-05',71.54,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (49,'Heidi','Sommersett','2006-10-29',31.68,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (50,'Susannah','Broker','2011-04-05',68.61,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (51,'Nady','Humpherston','2013-12-05',67.75,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (52,'Colene','Picton','2016-09-20',24.49,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (53,'Evelin','Hould','2020-05-02',83.74,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (54,'Ruperta','Byllam','2017-11-22',37.79,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (55,'Mufi','Squirrell','2001-10-02',29.02,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (56,'Rachele','Spracklin','2009-08-30',63.37,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (57,'Ardyth','O''Dyvoy','2012-11-10',98.73,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (58,'Irma','McNysche','2022-01-16',76.86,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (59,'Lilia','Roller','2017-11-30',57.48,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (60,'Darelle','Lepper','2021-10-01',38.96,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (61,'Verne','Huyge','2013-06-20',84.2,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (62,'Lynnea','Boughton','2007-09-11',19.94,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (63,'Birgit','O''Hoey','2007-04-16',61.86,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (64,'Alica','Georgievski','2014-08-10',60.95,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (65,'Adelaida','Drayson','2020-09-21',53.89,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (66,'Alister','Sanzio','2002-10-01',73.3,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (67,'Alexandros','Coales','2016-12-05',51.98,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (68,'Crysta','Mattevi','2010-07-29',67.48,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (69,'Donny','Ryce','2015-03-08',55.02,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (70,'Claudius','Cavy','2013-08-30',56.15,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (71,'Fidel','Bartalot','2022-09-02',59.11,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (72,'Revkah','Espinosa','2008-02-09',31.52,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (73,'Kerwinn','Greeveson','2001-09-23',19.55,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (74,'Beverley','Liverock','2017-04-05',63.53,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (75,'Clarinda','Ransome','2007-06-08',38.61,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (76,'Rik','Sultana','2007-09-06',43.39,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (77,'Griffy','Phizacklea','2001-11-21',62.21,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (78,'Giff','Sambrook','2012-06-09',54.53,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (79,'Tasha','Dellenbach','2004-01-08',43.28,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (80,'Ozzy','Delos','2001-12-23',83.42,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (81,'Lonni','Denver','2006-04-18',80.7,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (82,'Abdul','Clapson','2007-06-22',38.44,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (83,'Lonny','Philbrick','2010-05-16',51.2,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (84,'Delmore','Wordington','2022-11-01',67.92,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (85,'Dolores','Venditto','2005-04-20',97.52,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (86,'Kriste','Caen','2016-11-14',98.19,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (87,'Lauretta','Jockle','2013-08-11',30.82,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (88,'Thebault','Bickle','2020-06-25',92.29,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (89,'Everett','Roebottom','2018-02-18',90.71,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (90,'Morgun','Kleis','2007-01-04',85.46,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (91,'Pete','Attryde','2022-03-18',93.55,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (92,'Adorne','Bohlin','2021-08-21',25.48,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (93,'Merralee','Denys','2013-11-21',55.56,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (94,'Janey','Josifovic','2013-12-29',22.85,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (95,'Ross','Polglaze','2002-08-30',15.31,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (96,'Reed','Eslinger','2012-11-13',17.06,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (97,'Borden','Coal','2001-08-16',82.55,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (98,'Alyssa','Bazylets','2017-12-18',33.47,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (99,'Stern','Sarginson','2003-03-07',41.16,1);
INSERT INTO Employees(employee_id,first_name,last_name,hire_date,hourly_pay,supervisor_id) VALUES (100,'Kalindi','Barritt','2019-02-05',51.3,1);

INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (1,'2023-04-10',1237.45,88,1);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (2,'2022-09-04',56.74,2,35);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (3,'2022-08-24',139.7,97,68);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (4,'2023-02-12',1238.07,81,33);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (5,'2023-03-04',540.67,88,72);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (6,'2022-10-09',1096.59,47,66);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (7,'2022-05-09',1397.22,11,72);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (8,'2023-03-17',705.13,82,62);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (9,'2022-09-26',1175.26,89,56);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (10,'2022-04-19',137.34,6,77);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (11,'2022-12-05',1175.16,53,44);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (12,'2022-12-29',1029.54,65,94);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (13,'2022-09-08',846.23,30,40);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (14,'2022-10-10',1452.09,55,66);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (15,'2022-08-19',665.73,35,49);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (16,'2022-09-12',903.57,85,90);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (17,'2022-07-04',1481.45,83,45);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (18,'2022-08-14',445.63,43,42);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (19,'2022-06-22',1452.17,32,97);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (20,'2022-10-01',526.93,24,40);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (21,'2022-05-05',1274.46,70,17);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (22,'2022-05-20',535.9,47,25);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (23,'2022-07-20',769.29,25,41);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (24,'2023-03-15',275.79,64,84);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (25,'2022-08-14',733.59,65,59);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (26,'2022-10-02',715.32,33,95);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (27,'2022-05-11',1177.72,86,78);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (28,'2022-05-05',500.15,71,65);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (29,'2022-10-10',485.38,36,89);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (30,'2022-08-16',920.9,14,74);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (31,'2022-05-08',657.81,56,53);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (32,'2022-07-11',1190.88,20,45);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (33,'2023-01-13',1016.7,9,15);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (34,'2022-04-25',1252.01,80,39);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (35,'2023-01-30',750.52,46,79);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (36,'2022-08-02',189.39,97,91);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (37,'2022-12-10',1473.99,60,35);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (38,'2023-02-16',416.4,35,4);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (39,'2022-12-01',763.34,59,66);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (40,'2023-03-26',653.72,20,72);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (41,'2022-09-29',972.17,19,49);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (42,'2022-08-05',459.71,44,5);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (43,'2023-04-13',182.63,19,51);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (44,'2022-05-14',78.38,17,97);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (45,'2022-05-31',78.68,93,48);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (46,'2022-07-19',1322.83,61,81);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (47,'2023-01-02',1291.98,11,50);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (48,'2022-08-19',595.6,72,100);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (49,'2022-08-23',19.55,10,12);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (50,'2023-03-07',283.94,61,81);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (51,'2022-09-11',44.38,62,23);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (52,'2023-01-18',914.1,5,17);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (53,'2022-12-04',526.61,48,61);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (54,'2022-06-16',74.45,77,38);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (55,'2022-06-27',1452.87,33,49);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (56,'2022-11-28',757.2,10,34);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (57,'2023-01-14',897.21,54,59);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (58,'2022-06-19',38.96,42,61);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (59,'2023-04-14',136.92,37,54);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (60,'2022-10-17',588.44,80,66);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (61,'2022-11-20',148.07,3,55);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (62,'2022-05-13',425.16,61,58);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (63,'2022-08-14',1032.15,89,35);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (64,'2023-03-07',1363.53,65,51);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (65,'2022-11-01',566.45,8,14);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (66,'2023-01-02',331.22,55,57);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (67,'2022-09-12',1149.92,69,76);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (68,'2022-05-13',1392.64,63,65);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (69,'2022-09-13',1464.92,13,13);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (70,'2022-09-03',1223.05,66,7);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (71,'2022-06-17',879.47,22,26);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (72,'2022-11-20',847.38,63,64);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (73,'2022-10-09',54.14,76,97);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (74,'2022-07-07',968.79,73,62);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (75,'2022-09-11',1463.63,11,7);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (76,'2022-06-09',83.23,3,52);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (77,'2023-02-12',1399.91,2,87);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (78,'2023-02-15',843.13,36,30);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (79,'2022-07-20',1079.85,49,75);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (80,'2022-08-09',1348.83,17,48);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (81,'2023-03-29',117.36,27,19);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (82,'2022-12-04',1132.93,10,16);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (83,'2022-05-19',15.84,41,13);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (84,'2023-02-07',554.76,16,1);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (85,'2023-01-05',1359.03,4,52);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (86,'2022-05-16',670.04,59,80);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (87,'2023-03-04',949.63,100,38);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (88,'2022-06-03',210.0,100,30);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (89,'2022-09-02',810.18,67,22);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (90,'2023-03-07',562.38,51,71);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (91,'2022-07-19',196.61,70,42);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (92,'2023-03-27',698.65,70,32);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (93,'2022-04-22',1319.98,18,32);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (94,'2022-09-11',305.87,63,97);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (95,'2022-12-29',434.7,72,7);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (96,'2022-10-16',166.28,66,80);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (97,'2022-07-06',461.12,61,38);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (98,'2023-02-06',329.36,27,62);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (99,'2023-02-06',674.82,83,19);
INSERT INTO Orders(order_id,order_date,transaction_value,employee_id,customer_id) VALUES (100,'2022-10-23',1016.94,99,74);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (1,'United States',34691,'Illinois','8928 Cambridge Place','Joliet',14);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (2,'United States',76715,'District of Columbia','8443 Pine View Plaza','Washington',68);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (3,'United States',11425,'West Virginia','6 Maywood Junction','Huntington',4);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (4,'United States',89311,'California','3 Monterey Point','San Diego',66);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (5,'United States',12772,'South Carolina','482 Hanson Terrace','Columbia',100);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (6,'United States',80671,'Tennessee','52 Northview Hill','Chattanooga',93);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (7,'United States',21483,'Colorado','692 Jana Court','Colorado Springs',28);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (8,'United States',78324,'Texas','6 Village Terrace','Corpus Christi',96);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (9,'United States',63351,'Louisiana','37544 Del Sol Trail','Shreveport',14);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (10,'United States',60301,'New York','83 Mallard Terrace','Syracuse',80);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (11,'United States',21368,'Oregon','93275 Longview Plaza','Salem',29);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (12,'United States',69874,'Texas','58453 Kennedy Terrace','Fort Worth',93);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (13,'United States',37800,'District of Columbia','10977 Larry Way','Washington',28);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (14,'United States',81247,'Texas','58534 Charing Cross Hill','San Antonio',75);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (15,'United States',93403,'Missouri','4 Kropf Road','Saint Louis',32);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (16,'United States',51549,'New Mexico','0795 Carberry Plaza','Albuquerque',34);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (17,'United States',77719,'Texas','8 Manitowish Point','Houston',56);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (18,'United States',51043,'Texas','2450 Monument Alley','Austin',57);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (19,'United States',76477,'Alabama','00745 Graedel Alley','Montgomery',15);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (20,'United States',47809,'Ohio','515 Manufacturers Way','Cleveland',97);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (21,'United States',12733,'Kentucky','6 Brentwood Street','Louisville',44);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (22,'United States',80135,'Arizona','4490 Mcbride Trail','Apache Junction',90);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (23,'United States',24106,'Tennessee','9849 Graedel Pass','Memphis',30);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (24,'United States',73165,'Oregon','2790 Pleasure Crossing','Beaverton',16);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (25,'United States',45014,'Georgia','51 Ridgeway Point','Atlanta',23);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (26,'United States',47514,'Georgia','971 Express Lane','Augusta',53);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (27,'United States',87283,'California','151 Sunfield Place','Van Nuys',39);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (28,'United States',50071,'New Mexico','162 Mitchell Drive','Albuquerque',35);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (29,'United States',30989,'Nevada','95 Doe Crossing Point','Las Vegas',76);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (30,'United States',38530,'Missouri','18819 Sunfield Parkway','Kansas City',60);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (31,'United States',62803,'Arizona','0844 Mcguire Alley','Phoenix',33);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (32,'United States',99767,'Missouri','4 Eliot Parkway','Saint Louis',47);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (33,'United States',78137,'Ohio','4619 Fieldstone Plaza','Columbus',55);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (34,'United States',59093,'New York','674 Susan Place','Rochester',84);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (35,'United States',47483,'Virginia','3771 Veith Hill','Sterling',66);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (36,'United States',47147,'Colorado','6725 Hazelcrest Trail','Colorado Springs',19);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (37,'United States',61708,'California','26292 Moland Terrace','Oakland',82);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (38,'United States',81014,'Texas','5555 Division Way','Dallas',23);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (39,'United States',67824,'Arizona','24 Lotheville Terrace','Scottsdale',35);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (40,'United States',98287,'New York','02 Carey Drive','New York City',82);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (41,'United States',45371,'Illinois','3 Maywood Terrace','Springfield',14);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (42,'United States',53358,'Michigan','26 Hollow Ridge Center','Saginaw',10);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (43,'United States',51471,'Minnesota','39321 Rowland Pass','Saint Paul',81);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (44,'United States',19087,'Texas','32249 Graedel Alley','College Station',31);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (45,'United States',40653,'Massachusetts','63038 Harper Way','Waltham',61);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (46,'United States',54124,'Tennessee','971 Rigney Plaza','Memphis',74);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (47,'United States',92396,'California','7086 Marcy Way','Pasadena',54);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (48,'United States',72571,'Tennessee','2 Darwin Parkway','Nashville',6);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (49,'United States',23294,'California','2273 Sheridan Terrace','San Diego',100);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (50,'United States',88036,'Ohio','35088 Ohio Street','Cleveland',26);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (51,'United States',14536,'Colorado','4580 Elka Pass','Denver',91);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (52,'United States',36658,'Oregon','2 Kings Parkway','Portland',3);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (53,'United States',43177,'California','5 Bunker Hill Lane','Long Beach',23);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (54,'United States',31953,'District of Columbia','64858 Hudson Crossing','Washington',40);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (55,'United States',84901,'Missouri','55376 Veith Lane','Kansas City',76);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (56,'United States',15503,'Texas','9 Thackeray Plaza','San Antonio',58);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (57,'United States',69058,'Illinois','30581 Red Cloud Circle','Chicago',15);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (58,'United States',60366,'Tennessee','86 Paget Pass','Murfreesboro',56);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (59,'United States',89254,'Arkansas','879 Buena Vista Plaza','Fort Smith',31);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (60,'United States',54020,'Texas','66 Aberg Alley','Dallas',56);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (61,'United States',20914,'Connecticut','62427 Dayton Pass','Waterbury',59);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (62,'United States',20182,'Minnesota','5785 Darwin Lane','Saint Paul',35);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (63,'United States',70397,'California','34 Heffernan Parkway','Santa Barbara',15);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (64,'United States',77006,'Texas','78846 Coleman Court','Austin',7);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (65,'United States',57243,'Arkansas','9028 Maywood Alley','Little Rock',50);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (66,'United States',39872,'Michigan','3101 Little Fleur Center','Lansing',15);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (67,'United States',15917,'North Carolina','4430 Lakeland Circle','Fayetteville',11);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (68,'United States',82032,'Tennessee','6 Helena Road','Memphis',65);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (69,'United States',85720,'Florida','76594 Fair Oaks Terrace','Jacksonville',16);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (70,'United States',63659,'New York','44 Meadow Ridge Parkway','Jamaica',97);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (71,'United States',94004,'Missouri','19 Bluestem Point','Kansas City',85);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (72,'United States',50566,'Indiana','24058 Merrick Plaza','Indianapolis',30);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (73,'United States',83255,'Florida','43 Hoard Plaza','Clearwater',21);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (74,'United States',24682,'Indiana','9 Di Loreto Pass','South Bend',14);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (75,'United States',86063,'Texas','66 Beilfuss Alley','Abilene',45);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (76,'United States',91658,'Arizona','0 Clyde Gallagher Place','Mesa',83);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (77,'United States',37677,'California','28403 Dwight Lane','Fresno',97);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (78,'United States',18553,'Oregon','52 Lindbergh Road','Salem',97);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (79,'United States',71856,'Georgia','73 5th Park','Atlanta',75);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (80,'United States',69221,'Virginia','84056 Rusk Terrace','Ashburn',51);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (81,'United States',81861,'California','67759 Raven Alley','Sacramento',84);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (82,'United States',76524,'Hawaii','397 Talisman Alley','Honolulu',28);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (83,'United States',21291,'Connecticut','9888 Graceland Street','Bridgeport',53);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (84,'United States',86750,'Colorado','097 Morrow Street','Denver',11);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (85,'United States',99823,'Utah','5 Lighthouse Bay Crossing','Salt Lake City',44);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (86,'United States',52842,'California','370 3rd Lane','Simi Valley',57);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (87,'United States',40665,'Texas','21 Calypso Place','Tyler',84);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (88,'United States',60907,'Texas','5271 Lillian Junction','Houston',37);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (89,'United States',13029,'Virginia','4 Nobel Drive','Virginia Beach',85);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (90,'United States',40428,'Alabama','86 Johnson Circle','Montgomery',16);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (91,'United States',85841,'Indiana','58856 Stang Parkway','Muncie',20);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (92,'United States',98614,'Colorado','49 Merry Place','Denver',54);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (93,'United States',32603,'New Jersey','350 2nd Point','Trenton',69);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (94,'United States',58449,'California','71 Atwood Plaza','Santa Clara',91);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (95,'United States',16423,'New York','9752 Bluestem Place','Brooklyn',33);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (96,'United States',19888,'Texas','2400 Calypso Court','Austin',66);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (97,'United States',78703,'Texas','679 Prairie Rose Lane','San Antonio',40);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (98,'United States',37274,'Oklahoma','81 Bonner Drive','Oklahoma City',82);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (99,'United States',63835,'New Jersey','92 Spaight Center','Trenton',56);
INSERT INTO OnlineOrders(online_order_id,region,postal_code,state,address,city,order_id) VALUES (100,'United States',54078,'District of Columbia','649 Coolidge Hill','Washington',69);

INSERT INTO Distributors(distributor_id,name,email) VALUES (1,'Stehr and Sons','gglazier0@spotify.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (2,'Collins, Grady and Schulist','aandrolli1@wufoo.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (3,'Orn-Kemmer','cortner2@addtoany.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (4,'Deckow-Hyatt','mlympany3@rambler.ru');
INSERT INTO Distributors(distributor_id,name,email) VALUES (5,'Will-Jones','dlindner4@goodreads.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (6,'Erdman LLC','msnarr5@homestead.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (7,'Jacobs and Sons','abootell6@businessinsider.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (8,'Goldner-Graham','rdooler7@archive.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (9,'Shields Inc','cbresman8@illinois.edu');
INSERT INTO Distributors(distributor_id,name,email) VALUES (10,'Williamson, Hessel and Wiegand','tjurisch9@jiathis.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (11,'Hartmann-Heller','lglassarda@marketwatch.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (12,'Collier-Mraz','hshotboulteb@ning.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (13,'Huels-Ullrich','tzamoranoc@ucla.edu');
INSERT INTO Distributors(distributor_id,name,email) VALUES (14,'Adams, Kihn and Franecki','groosd@rambler.ru');
INSERT INTO Distributors(distributor_id,name,email) VALUES (15,'McCullough, Schaefer and Batz','gbrunninge@imdb.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (16,'Herzog-Heidenreich','bfilyakovf@economist.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (17,'Schaden Inc','boniong@wikipedia.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (18,'Kling Group','itogherh@dropbox.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (19,'Metz-Lynch','hmawsoni@prweb.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (20,'Feest-Romaguera','vsaddj@redcross.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (21,'Haley, Fahey and Reinger','tisakovk@mozilla.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (22,'Emard-Hoeger','gliveseyl@microsoft.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (23,'Douglas, Turcotte and Powlowski','kcoomesm@craigslist.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (24,'Ebert, Stehr and Barrows','egrahlmann@instagram.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (25,'Muller-Swift','lduffieldo@seattletimes.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (26,'Wiegand-Spencer','pnicholsp@linkedin.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (27,'Murazik, Rosenbaum and Wuckert','lmimmackq@360.cn');
INSERT INTO Distributors(distributor_id,name,email) VALUES (28,'Waelchi, Smith and Spinka','aveeversr@jiathis.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (29,'Hagenes Inc','vstollens@github.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (30,'Borer-Kihn','kmcnellyt@gizmodo.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (31,'Reilly, Abernathy and Block','bpeattu@example.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (32,'Abernathy Group','imacdonoghv@360.cn');
INSERT INTO Distributors(distributor_id,name,email) VALUES (33,'Emmerich Inc','lmcquaidew@comcast.net');
INSERT INTO Distributors(distributor_id,name,email) VALUES (34,'McGlynn-Walker','edaintonx@1688.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (35,'Cartwright-Schuster','cdabelsy@de.vu');
INSERT INTO Distributors(distributor_id,name,email) VALUES (36,'Streich LLC','ayukhnevichz@google.pl');
INSERT INTO Distributors(distributor_id,name,email) VALUES (37,'Carter and Sons','ytyrie10@dion.ne.jp');
INSERT INTO Distributors(distributor_id,name,email) VALUES (38,'Cummings, Bartell and Treutel','rboutflour11@barnesandnoble.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (39,'Swift Group','bbortolutti12@barnesandnoble.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (40,'Walsh-Harris','ctaunton13@yellowbook.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (41,'Heaney, Roob and Rice','cdewey14@t.co');
INSERT INTO Distributors(distributor_id,name,email) VALUES (42,'Wisozk-Leuschke','cborg15@dmoz.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (43,'Fahey, Runolfsson and Ward','nsimmonite16@sakura.ne.jp');
INSERT INTO Distributors(distributor_id,name,email) VALUES (44,'Heidenreich-Lesch','ehigbin17@is.gd');
INSERT INTO Distributors(distributor_id,name,email) VALUES (45,'Haag, Bins and Schaden','rjacobsohn18@yellowbook.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (46,'Skiles Inc','cgorvin19@g.co');
INSERT INTO Distributors(distributor_id,name,email) VALUES (47,'Senger-Windler','ahaestier1a@geocities.jp');
INSERT INTO Distributors(distributor_id,name,email) VALUES (48,'Crona-Swaniawski','wloverock1b@tuttocitta.it');
INSERT INTO Distributors(distributor_id,name,email) VALUES (49,'Kuphal, Runte and Farrell','cmerit1c@google.it');
INSERT INTO Distributors(distributor_id,name,email) VALUES (50,'Koelpin-Nader','kducker1d@themeforest.net');
INSERT INTO Distributors(distributor_id,name,email) VALUES (51,'Rippin Group','nkelsow1e@goodreads.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (52,'West-Sauer','wedwicker1f@umich.edu');
INSERT INTO Distributors(distributor_id,name,email) VALUES (53,'Von-Ledner','rbroker1g@elpais.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (54,'Hilll-Jaskolski','jsarjeant1h@rakuten.co.jp');
INSERT INTO Distributors(distributor_id,name,email) VALUES (55,'Kihn-Pouros','mknifton1i@reference.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (56,'Kreiger-Quitzon','bireson1j@ibm.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (57,'Mills, Effertz and Gottlieb','barrault1k@gizmodo.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (58,'Sanford Inc','mneljes1l@eventbrite.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (59,'Beahan-Schiller','woxborrow1m@jalbum.net');
INSERT INTO Distributors(distributor_id,name,email) VALUES (60,'Dickinson, Schultz and Pfeffer','hfischer1n@ftc.gov');
INSERT INTO Distributors(distributor_id,name,email) VALUES (61,'Anderson, West and Kerluke','lwanell1o@gmpg.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (62,'Rosenbaum Group','bgamble1p@webeden.co.uk');
INSERT INTO Distributors(distributor_id,name,email) VALUES (63,'Ruecker, Emard and Bosco','etejada1q@microsoft.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (64,'Pollich-Dooley','alineen1r@ted.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (65,'Bergnaum-Prohaska','bfourcade1s@g.co');
INSERT INTO Distributors(distributor_id,name,email) VALUES (66,'Kessler-Aufderhar','kwinkell1t@123-reg.co.uk');
INSERT INTO Distributors(distributor_id,name,email) VALUES (67,'Cruickshank-Hauck','lsetford1u@hostgator.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (68,'Altenwerth-Mertz','egarley1v@ustream.tv');
INSERT INTO Distributors(distributor_id,name,email) VALUES (69,'Kihn, Hand and Hammes','dsnaith1w@hugedomains.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (70,'Kemmer-Corwin','bluckie1x@nytimes.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (71,'Nienow-Reynolds','naspital1y@alexa.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (72,'Veum Inc','ndikles1z@youtube.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (73,'Reilly LLC','glathaye20@springer.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (74,'Senger, Wiegand and Schmidt','dafield21@nba.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (75,'Bartell-Witting','ehumphries22@hp.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (76,'Koepp, Leffler and Volkman','cmaund23@eepurl.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (77,'Lowe and Sons','kwheble24@noaa.gov');
INSERT INTO Distributors(distributor_id,name,email) VALUES (78,'Cremin-Rutherford','jburtenshaw25@csmonitor.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (79,'Ruecker and Sons','dlangsbury26@wikia.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (80,'Streich, Wuckert and Christiansen','jharvett27@surveymonkey.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (81,'Tromp, Welch and Rowe','mpike28@ca.gov');
INSERT INTO Distributors(distributor_id,name,email) VALUES (82,'Langosh-Harris','kdransfield29@parallels.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (83,'Rowe, Cummings and Schiller','tcockburn2a@taobao.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (84,'Conn-Parker','scockrem2b@canalblog.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (85,'McKenzie Inc','hblinckhorne2c@themeforest.net');
INSERT INTO Distributors(distributor_id,name,email) VALUES (86,'Williamson, Jones and Bartoletti','gmilliken2d@google.co.uk');
INSERT INTO Distributors(distributor_id,name,email) VALUES (87,'Russel-Davis','tloveredge2e@webnode.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (88,'Fahey and Sons','rsimmank2f@oracle.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (89,'Gleason-O''Kon','mbennoe2g@plala.or.jp');
INSERT INTO Distributors(distributor_id,name,email) VALUES (90,'Daugherty and Sons','wdahlman2h@hc360.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (91,'Haag-Boehm','rramsey2i@rambler.ru');
INSERT INTO Distributors(distributor_id,name,email) VALUES (92,'Bergnaum and Sons','akorneichik2j@multiply.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (93,'Walker Inc','rgreatbach2k@pcworld.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (94,'Rosenbaum Inc','qmeekings2l@zdnet.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (95,'Kulas, Pfannerstill and Homenick','tsaddler2m@earthlink.net');
INSERT INTO Distributors(distributor_id,name,email) VALUES (96,'Littel Group','sfleetwood2n@prlog.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (97,'Hickle-Schaefer','lcorder2o@wikispaces.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (98,'Hane-Hackett','hmcduffie2p@joomla.org');
INSERT INTO Distributors(distributor_id,name,email) VALUES (99,'Bernier and Sons','zarne2q@vk.com');
INSERT INTO Distributors(distributor_id,name,email) VALUES (100,'Olson, Waelchi and O''Connell','rdwelley2r@wsj.com');

INSERT INTO Developers(developer_id,name) VALUES (1,'O''Connell, Wisoky and Kreiger');
INSERT INTO Developers(developer_id,name) VALUES (2,'Schneider-Krajcik');
INSERT INTO Developers(developer_id,name) VALUES (3,'Braun, Ryan and Bahringer');
INSERT INTO Developers(developer_id,name) VALUES (4,'Blick and Sons');
INSERT INTO Developers(developer_id,name) VALUES (5,'Upton and Sons');
INSERT INTO Developers(developer_id,name) VALUES (6,'Abshire and Sons');
INSERT INTO Developers(developer_id,name) VALUES (7,'Hartmann and Sons');
INSERT INTO Developers(developer_id,name) VALUES (8,'Hyatt and Sons');
INSERT INTO Developers(developer_id,name) VALUES (9,'Berge Inc');
INSERT INTO Developers(developer_id,name) VALUES (10,'Hartmann and Sons');
INSERT INTO Developers(developer_id,name) VALUES (11,'Fay, Strosin and Mante');
INSERT INTO Developers(developer_id,name) VALUES (12,'Crist-Greenholt');
INSERT INTO Developers(developer_id,name) VALUES (13,'Renner Group');
INSERT INTO Developers(developer_id,name) VALUES (14,'D''Amore-Welch');
INSERT INTO Developers(developer_id,name) VALUES (15,'Pouros-Sawayn');
INSERT INTO Developers(developer_id,name) VALUES (16,'Bogan, Nader and Renner');
INSERT INTO Developers(developer_id,name) VALUES (17,'Walsh-Hermann');
INSERT INTO Developers(developer_id,name) VALUES (18,'Gutkowski, Ankunding and Nitzsche');
INSERT INTO Developers(developer_id,name) VALUES (19,'Ernser Group');
INSERT INTO Developers(developer_id,name) VALUES (20,'Rodriguez, Price and Goyette');
INSERT INTO Developers(developer_id,name) VALUES (21,'Carroll, West and Lubowitz');
INSERT INTO Developers(developer_id,name) VALUES (22,'D''Amore, Jast and Rippin');
INSERT INTO Developers(developer_id,name) VALUES (23,'Runolfsson and Sons');
INSERT INTO Developers(developer_id,name) VALUES (24,'Torphy and Sons');
INSERT INTO Developers(developer_id,name) VALUES (25,'King Inc');
INSERT INTO Developers(developer_id,name) VALUES (26,'Abernathy-Gulgowski');
INSERT INTO Developers(developer_id,name) VALUES (27,'Kiehn, Toy and Douglas');
INSERT INTO Developers(developer_id,name) VALUES (28,'Hane Group');
INSERT INTO Developers(developer_id,name) VALUES (29,'Hessel Group');
INSERT INTO Developers(developer_id,name) VALUES (30,'Stanton and Sons');
INSERT INTO Developers(developer_id,name) VALUES (31,'Bode, King and Schoen');
INSERT INTO Developers(developer_id,name) VALUES (32,'Tromp-Powlowski');
INSERT INTO Developers(developer_id,name) VALUES (33,'Casper-Heidenreich');
INSERT INTO Developers(developer_id,name) VALUES (34,'Kreiger, Feest and Toy');
INSERT INTO Developers(developer_id,name) VALUES (35,'Bode and Sons');
INSERT INTO Developers(developer_id,name) VALUES (36,'Howe, Reichert and Koch');
INSERT INTO Developers(developer_id,name) VALUES (37,'Miller and Sons');
INSERT INTO Developers(developer_id,name) VALUES (38,'Grimes, Hagenes and Runolfsdottir');
INSERT INTO Developers(developer_id,name) VALUES (39,'Koelpin-Beier');
INSERT INTO Developers(developer_id,name) VALUES (40,'Rowe-Rempel');
INSERT INTO Developers(developer_id,name) VALUES (41,'Bailey-Deckow');
INSERT INTO Developers(developer_id,name) VALUES (42,'Jakubowski LLC');
INSERT INTO Developers(developer_id,name) VALUES (43,'Hermiston-Jast');
INSERT INTO Developers(developer_id,name) VALUES (44,'Kuvalis Group');
INSERT INTO Developers(developer_id,name) VALUES (45,'Walker, Beer and Bechtelar');
INSERT INTO Developers(developer_id,name) VALUES (46,'Goldner-Haag');
INSERT INTO Developers(developer_id,name) VALUES (47,'Kiehn-Fadel');
INSERT INTO Developers(developer_id,name) VALUES (48,'Aufderhar, Schiller and Bins');
INSERT INTO Developers(developer_id,name) VALUES (49,'O''Hara, Okuneva and Feil');
INSERT INTO Developers(developer_id,name) VALUES (50,'Waters, Quigley and Kreiger');
INSERT INTO Developers(developer_id,name) VALUES (51,'Parisian, Sanford and Strosin');
INSERT INTO Developers(developer_id,name) VALUES (52,'McGlynn Inc');
INSERT INTO Developers(developer_id,name) VALUES (53,'Keebler-Rolfson');
INSERT INTO Developers(developer_id,name) VALUES (54,'Thompson Inc');
INSERT INTO Developers(developer_id,name) VALUES (55,'Glover Inc');
INSERT INTO Developers(developer_id,name) VALUES (56,'Hermiston LLC');
INSERT INTO Developers(developer_id,name) VALUES (57,'O''Reilly Inc');
INSERT INTO Developers(developer_id,name) VALUES (58,'Grant Inc');
INSERT INTO Developers(developer_id,name) VALUES (59,'Sawayn-Crona');
INSERT INTO Developers(developer_id,name) VALUES (60,'Gorczany LLC');
INSERT INTO Developers(developer_id,name) VALUES (61,'Pfeffer-Schultz');
INSERT INTO Developers(developer_id,name) VALUES (62,'Bins-Prosacco');
INSERT INTO Developers(developer_id,name) VALUES (63,'Bode, Roob and Kreiger');
INSERT INTO Developers(developer_id,name) VALUES (64,'Paucek, Turner and Abshire');
INSERT INTO Developers(developer_id,name) VALUES (65,'White-Oberbrunner');
INSERT INTO Developers(developer_id,name) VALUES (66,'Turner-Ernser');
INSERT INTO Developers(developer_id,name) VALUES (67,'Ryan, Hilpert and Jacobi');
INSERT INTO Developers(developer_id,name) VALUES (68,'Johnson, Lowe and Schneider');
INSERT INTO Developers(developer_id,name) VALUES (69,'Windler-Reynolds');
INSERT INTO Developers(developer_id,name) VALUES (70,'Daugherty-Cassin');
INSERT INTO Developers(developer_id,name) VALUES (71,'Braun-Bins');
INSERT INTO Developers(developer_id,name) VALUES (72,'Grady-Weimann');
INSERT INTO Developers(developer_id,name) VALUES (73,'O''Connell, Legros and Schuppe');
INSERT INTO Developers(developer_id,name) VALUES (74,'Prohaska, Flatley and Schuster');
INSERT INTO Developers(developer_id,name) VALUES (75,'Littel, Pouros and Walker');
INSERT INTO Developers(developer_id,name) VALUES (76,'Wisoky, Walsh and O''Conner');
INSERT INTO Developers(developer_id,name) VALUES (77,'Cole-Hyatt');
INSERT INTO Developers(developer_id,name) VALUES (78,'Swift Inc');
INSERT INTO Developers(developer_id,name) VALUES (79,'Denesik-Schmeler');
INSERT INTO Developers(developer_id,name) VALUES (80,'Cremin-Bergstrom');
INSERT INTO Developers(developer_id,name) VALUES (81,'Conn-Mertz');
INSERT INTO Developers(developer_id,name) VALUES (82,'Mosciski and Sons');
INSERT INTO Developers(developer_id,name) VALUES (83,'Wilderman-Osinski');
INSERT INTO Developers(developer_id,name) VALUES (84,'Franecki, Abbott and Conroy');
INSERT INTO Developers(developer_id,name) VALUES (85,'Herman LLC');
INSERT INTO Developers(developer_id,name) VALUES (86,'Morissette and Sons');
INSERT INTO Developers(developer_id,name) VALUES (87,'Lowe, Johns and Conn');
INSERT INTO Developers(developer_id,name) VALUES (88,'Goldner, Gibson and Conn');
INSERT INTO Developers(developer_id,name) VALUES (89,'Mosciski and Sons');
INSERT INTO Developers(developer_id,name) VALUES (90,'Parker-Torp');
INSERT INTO Developers(developer_id,name) VALUES (91,'Senger LLC');
INSERT INTO Developers(developer_id,name) VALUES (92,'Purdy, Hickle and Zieme');
INSERT INTO Developers(developer_id,name) VALUES (93,'Jast LLC');
INSERT INTO Developers(developer_id,name) VALUES (94,'Veum-Yundt');
INSERT INTO Developers(developer_id,name) VALUES (95,'Kerluke-Barrows');
INSERT INTO Developers(developer_id,name) VALUES (96,'Hahn and Sons');
INSERT INTO Developers(developer_id,name) VALUES (97,'Ward, Purdy and Schaefer');
INSERT INTO Developers(developer_id,name) VALUES (98,'Simonis, Conn and Hand');
INSERT INTO Developers(developer_id,name) VALUES (99,'Kutch-Satterfield');
INSERT INTO Developers(developer_id,name) VALUES (100,'Sipes, Wiza and Price');

INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (1,'Matsoft','2006-07-24',49.87,5,'Y','Ventosanzap',76,98);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (2,'Tempsoft','2022-09-11',50.64,2,'H','Solarbreeze',70,4);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (3,'Opela','1998-11-07',46.84,2,'X','Opela',89,34);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (4,'It','2018-02-18',46.58,3,'X','Subin',69,70);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (5,'Daltfresh','2001-10-01',46.99,5,'K','Bytecard',51,99);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (6,'Trippledex','2018-01-28',43.67,5,'D','Fintone',98,50);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (7,'Fintone','2015-01-26',48.45,5,'Y','Matsoft',15,17);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (8,'Cardify','2015-10-07',62.16,5,'B','Otcom',21,14);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (9,'Prodder','2003-05-17',50.55,5,'R','Flowdesk',36,53);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (10,'Span','1988-08-03',67.67,4,'Q','Sonsing',54,39);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (11,'Stim','1991-08-18',51.58,3,'J','Sub-Ex',6,93);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (12,'Andalax','2004-03-22',69.16,4,'K','Zoolab',94,54);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (13,'Transcof','1988-06-20',42.86,3,'B','Alphazap',48,46);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (14,'Bitwolf','1990-12-07',44.59,4,'H','Regrant',90,15);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (15,'Trippledex','1999-07-23',50.18,2,'S','Domainer',62,4);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (16,'Flowdesk','1994-12-19',41.67,4,'J','Konklux',69,9);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (17,'It','1997-03-13',58.84,1,'U','Transcof',79,50);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (18,'Viva','2002-10-10',42.56,3,'X','Keylex',70,64);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (19,'Duobam','1998-05-11',60.35,5,'A','Keylex',40,49);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (20,'Bigtax','2000-04-16',51.96,2,'Z','Viva',50,65);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (21,'Ronstring','2014-05-12',66.44,3,'N','Cardguard',1,64);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (22,'Rank','2012-06-10',49.1,5,'T','Stronghold',30,16);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (23,'Fintone','1988-09-29',63.39,4,'U','Trippledex',98,82);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (24,'Ventosanzap','1996-11-10',61.77,4,'G','Flowdesk',15,1);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (25,'Viva','1986-04-22',42.08,1,'U','Sonsing',99,73);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (26,'Biodex','2012-03-24',41.98,4,'V','Flowdesk',2,49);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (27,'Fixflex','2004-03-17',66.16,3,'B','Bitchip',34,83);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (28,'Quo Lux','2007-07-29',45.55,3,'Q','Alpha',68,10);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (29,'Veribet','1989-05-15',66.49,3,'X','Subin',60,87);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (30,'Duobam','2010-12-11',60.55,5,'C','Zamit',4,83);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (31,'Tampflex','2013-11-05',46.85,4,'X','Tempsoft',76,29);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (32,'Zathin','2011-08-21',48.58,2,'K','Home Ing',56,62);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (33,'Stim','2000-12-27',64.57,5,'S','Stringtough',51,28);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (34,'Kanlam','2020-11-20',64.43,4,'O','Bitwolf',5,36);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (35,'Pannier','2009-08-20',61.95,4,'H','Y-Solowarm',70,88);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (36,'Holdlamis','1990-05-22',41.09,1,'Y','Lotstring',54,88);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (37,'Quo Lux','1987-08-15',69.93,3,'U','Biodex',50,79);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (38,'Biodex','2003-04-25',46.18,5,'P','Voltsillam',45,92);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (39,'Toughjoyfax','2020-01-31',52.95,3,'V','Flexidy',13,63);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (40,'Temp','1999-07-10',40.21,5,'S','Keylex',71,34);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (41,'Lotstring','2003-02-14',44.58,2,'Q','Voltsillam',2,36);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (42,'Alpha','1995-09-09',51.39,4,'S','Quo Lux',77,96);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (43,'Zathin','2016-01-11',53.68,4,'E','Alphazap',86,84);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (44,'Biodex','2023-03-24',65.76,4,'U','Tres-Zap',66,66);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (45,'Namfix','1997-11-22',48.96,4,'Y','Bytecard',31,68);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (46,'Lotstring','2003-01-06',56.01,1,'I','Tempsoft',44,58);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (47,'Regrant','2000-03-20',65.73,3,'F','Sub-Ex',81,65);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (48,'Vagram','1994-05-03',53.93,2,'Q','Otcom',11,78);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (49,'Subin','1999-08-26',54.78,1,'M','Sonair',27,6);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (50,'Zoolab','1996-09-23',64.65,1,'H','Voltsillam',30,31);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (51,'Opela','1988-07-14',53.25,4,'D','Zoolab',54,55);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (52,'Latlux','1991-05-21',60.33,1,'L','Cardguard',3,45);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (53,'It','1992-05-22',55.76,5,'V','It',94,50);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (54,'Bitchip','1986-05-09',39.63,3,'U','Alpha',62,59);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (55,'Opela','2003-07-10',41.33,1,'A','Solarbreeze',59,46);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (56,'Overhold','2009-06-25',59.21,5,'K','Asoka',15,60);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (57,'Bigtax','1989-05-21',64.01,3,'I','Overhold',41,14);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (58,'Prodder','2014-09-19',63.74,1,'T','Kanlam',16,4);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (59,'Tin','2002-01-30',64.32,2,'C','Bigtax',75,16);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (60,'Konklux','2021-04-27',55.86,1,'U','Kanlam',66,50);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (61,'Alpha','1991-11-12',68.7,3,'J','Regrant',94,61);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (62,'Zathin','1994-03-10',41.19,1,'X','Home Ing',61,74);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (63,'Konklab','2001-06-18',64.65,1,'U','Sonsing',59,2);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (64,'Vagram','2012-02-11',42.11,5,'V','Span',58,32);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (65,'Trippledex','1993-07-19',54.12,5,'L','Tin',76,98);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (66,'Ventosanzap','2021-10-20',53.36,3,'D','Bamity',81,49);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (67,'Sub-Ex','2002-12-19',67.81,1,'W','Opela',70,98);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (68,'Asoka','2016-01-30',40.3,4,'Q','Flowdesk',59,82);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (69,'Zathin','2004-08-23',68.86,5,'D','Latlux',38,25);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (70,'Fix San','1997-10-03',63.16,4,'Y','Regrant',11,72);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (71,'Otcom','2022-12-03',42.58,5,'L','Ventosanzap',46,80);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (72,'Transcof','2002-03-18',43.03,1,'V','Veribet',19,62);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (73,'Solarbreeze','2002-05-10',39.21,2,'T','Tampflex',13,76);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (74,'Wrapsafe','2013-09-05',56.42,5,'S','Y-find',90,14);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (75,'Daltfresh','2008-12-20',48.12,4,'C','Tresom',56,55);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (76,'Bitchip','2019-07-20',45.38,1,'B','Andalax',25,22);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (77,'Konklux','2010-05-24',50.23,4,'O','Quo Lux',28,63);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (78,'Transcof','2012-08-31',39.31,3,'N','Veribet',75,62);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (79,'Bitwolf','2011-03-19',42.24,1,'O','Bytecard',54,89);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (80,'Voyatouch','2005-08-14',40.0,2,'O','Tin',84,37);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (81,'Regrant','2000-06-18',62.12,2,'N','Cardify',55,98);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (82,'Holdlamis','2018-07-17',40.81,4,'E','Tampflex',34,83);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (83,'Tin','2012-10-14',49.92,1,'F','Matsoft',42,8);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (84,'Overhold','1989-06-25',51.51,3,'T','Stim',63,51);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (85,'Domainer','2018-06-25',55.27,2,'R','Redhold',100,35);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (86,'Bigtax','2016-05-20',66.66,3,'V','Veribet',39,72);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (87,'Asoka','2006-05-23',56.05,4,'S','Temp',6,59);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (88,'Job','1990-07-21',42.57,2,'E','Bigtax',39,11);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (89,'Andalax','2017-08-02',58.02,2,'E','Fintone',68,62);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (90,'Lotlux','2009-04-09',51.49,1,'J','Quo Lux',98,18);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (91,'Zaam-Dox','2012-02-17',50.65,3,'G','Sonsing',67,88);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (92,'Andalax','2008-11-04',52.41,3,'T','Rank',48,24);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (93,'Quo Lux','1999-06-17',60.31,4,'S','Otcom',20,17);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (94,'Domainer','1996-06-17',51.09,2,'R','Rank',80,57);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (95,'Voyatouch','2020-11-26',40.45,2,'J','Otcom',13,62);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (96,'Stringtough','1992-05-26',62.86,4,'J','Home Ing',14,99);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (97,'Subin','2020-12-08',59.78,2,'V','Alpha',66,26);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (98,'Fixflex','2006-02-14',68.69,3,'Q','Toughjoyfax',35,8);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (99,'Konklab','2012-12-18',61.63,5,'K','Bigtax',50,26);
INSERT INTO Games(game_id,name,release_year,sales_price,cust_rating,age_rating,console,developer_id,distributor_id) VALUES (100,'Alphazap','2020-02-22',67.82,5,'D','Quo Lux',33,44);

INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (1,18,0.91,45);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (2,47,0.6,46);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (3,59,0.88,44);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (4,4,0.06,47);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (5,41,0.03,30);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (6,29,0.23,47);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (7,79,0.37,19);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (8,85,0.64,23);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (9,22,0.28,44);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (10,75,0.93,35);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (11,7,0.69,14);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (12,4,0.85,2);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (13,1,0.54,46);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (14,5,0.67,45);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (15,17,1.0,3);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (16,22,0.19,48);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (17,81,0.83,41);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (18,41,0.93,14);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (19,94,0.61,7);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (20,68,0.4,15);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (21,85,0.12,15);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (22,72,0.23,47);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (23,87,0.9,3);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (24,78,0.89,7);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (25,64,0.1,15);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (26,89,0.3,35);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (27,52,0.07,32);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (28,12,0.86,49);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (29,85,0.18,48);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (30,100,0.49,35);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (31,86,0.49,29);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (32,76,0.3,37);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (33,70,0.5,12);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (34,78,0.28,27);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (35,99,0.84,49);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (36,69,0.39,21);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (37,43,0.85,20);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (38,9,0.29,31);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (39,94,0.52,39);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (40,86,0.32,40);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (41,66,0.47,13);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (42,49,0.95,28);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (43,15,0.42,16);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (44,16,0.41,32);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (45,100,0.22,9);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (46,3,0.89,42);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (47,9,0.88,37);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (48,26,0.98,20);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (49,7,0.36,48);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (50,25,0.54,39);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (51,100,0.01,4);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (52,3,0.15,16);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (53,81,0.6,5);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (54,57,0.49,18);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (55,78,0.19,49);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (56,35,0.5,9);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (57,85,0.56,21);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (58,91,0.31,30);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (59,32,0.44,15);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (60,22,0.21,27);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (61,9,0.02,43);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (62,1,0.57,44);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (63,49,0.07,32);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (64,6,0.97,38);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (65,24,0.16,33);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (66,98,0.85,12);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (67,63,0.2,26);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (68,1,0.42,32);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (69,11,0.34,25);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (70,27,0.62,10);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (71,53,0.56,26);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (72,63,0.09,30);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (73,10,0.22,20);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (74,13,0.39,42);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (75,22,0.35,30);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (76,87,0.84,28);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (77,93,0.6,18);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (78,29,0.31,29);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (79,91,0.06,43);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (80,15,0.57,3);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (81,76,0.26,33);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (82,38,0.2,48);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (83,33,0.49,34);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (84,96,0.14,23);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (85,26,0.28,8);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (86,88,0.05,22);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (87,13,0.42,36);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (88,8,0.79,18);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (89,75,0.61,25);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (90,67,0.0,42);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (91,39,0.32,27);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (92,74,0.41,49);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (93,75,0.8,22);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (94,97,0.65,20);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (95,55,0.72,11);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (96,62,0.4,40);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (97,42,0.74,9);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (98,57,0.83,20);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (99,75,0.96,10);
INSERT INTO Order_Details(order_id,game_id,discount,quantity) VALUES (100,65,0.63,26);

INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (1,'Koch, Runolfsson and Paucek',51.34);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (2,'Gislason Group',35.81);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (3,'Fritsch-Jacobi',73.69);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (4,'Legros LLC',56.98);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (5,'Nader, Bernhard and Heidenreich',98.74);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (6,'Mayert, Quitzon and Schamberger',18.87);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (7,'Brown, Breitenberg and Hackett',18.17);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (8,'Mitchell-Collier',74.22);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (9,'Johnson-Feil',37.64);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (10,'Hilll, Fisher and Skiles',36.65);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (11,'Windler-Kohler',18.42);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (12,'Schmeler Inc',7.51);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (13,'Jaskolski LLC',74.2);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (14,'Carroll and Sons',13.45);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (15,'Gottlieb-Mosciski',17.06);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (16,'Hudson LLC',57.12);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (17,'Walter and Sons',89.55);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (18,'Bechtelar Group',91.48);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (19,'Kiehn, Reichel and Treutel',78.71);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (20,'Wintheiser Group',21.51);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (21,'Huels Group',75.42);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (22,'Schroeder-Schulist',68.56);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (23,'Miller-Kling',49.52);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (24,'Bechtelar-Auer',39.42);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (25,'Grady, Turcotte and Dibbert',78.69);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (26,'Pacocha-Rippin',61.78);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (27,'Kreiger, Aufderhar and Lebsack',87.59);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (28,'Carter-Yost',48.15);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (29,'Douglas, Bashirian and Barton',16.04);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (30,'Schaefer, Graham and Cronin',89.11);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (31,'Kozey-Murphy',61.64);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (32,'Schaefer, Schimmel and Schultz',16.71);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (33,'Kulas, Price and Dibbert',53.09);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (34,'Langworth and Sons',38.79);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (35,'Sawayn-Lockman',48.89);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (36,'Kuhn, Stracke and Klein',95.96);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (37,'Yundt, Gottlieb and Schmeler',54.45);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (38,'Ratke Group',5.97);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (39,'Gislason-Mosciski',44.18);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (40,'Kemmer and Sons',71.21);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (41,'Hyatt, Cremin and Oberbrunner',25.45);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (42,'Bruen LLC',39.66);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (43,'Crona, Hessel and Cormier',37.17);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (44,'Mitchell, Moore and Thompson',45.0);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (45,'Boyer, Hyatt and Crona',21.57);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (46,'Klocko-Dooley',18.6);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (47,'Leuschke, Kassulke and Weimann',5.97);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (48,'Rolfson-Rau',33.36);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (49,'Ortiz Group',1.94);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (50,'Beahan Inc',25.31);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (51,'Legros LLC',66.79);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (52,'Gutmann LLC',64.14);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (53,'Romaguera Inc',85.35);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (54,'Doyle LLC',27.33);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (55,'Kuhn-Reilly',6.69);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (56,'Cartwright-Keeling',54.78);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (57,'Lind LLC',24.68);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (58,'Stehr-D''Amore',25.5);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (59,'Little Inc',44.73);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (60,'Gerhold, McLaughlin and Willms',20.14);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (61,'Bernhard Group',40.4);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (62,'Dickinson, Williamson and Jacobs',84.88);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (63,'Buckridge-Hermiston',30.26);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (64,'Adams Inc',88.37);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (65,'Roob, Ryan and Tremblay',28.23);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (66,'Weissnat-Smith',87.31);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (67,'Pfannerstill, Hickle and Boyer',34.86);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (68,'Daugherty-Bahringer',46.93);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (69,'Robel, Hoeger and Schoen',51.89);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (70,'Fahey-Rippin',45.53);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (71,'Zulauf-Roob',40.39);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (72,'Murazik, Hackett and Schinner',86.42);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (73,'King, Denesik and Kovacek',1.47);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (74,'Bradtke-Luettgen',21.55);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (75,'Stoltenberg, Marvin and King',39.1);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (76,'Rogahn Inc',1.85);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (77,'Bradtke and Sons',56.53);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (78,'Gulgowski-O''Reilly',22.08);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (79,'Feeney, Yundt and Wiegand',24.79);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (80,'Bartell Group',41.48);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (81,'Zulauf-Bergstrom',76.91);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (82,'Nienow Inc',65.02);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (83,'Little, Heller and Auer',36.09);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (84,'Zieme Group',78.22);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (85,'Windler, Sipes and Shields',8.62);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (86,'Fadel, Lang and Walter',72.62);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (87,'Ortiz and Sons',53.28);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (88,'Ondricka, Bayer and Fay',48.68);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (89,'Torp, Krajcik and Stokes',83.05);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (90,'Kiehn LLC',7.8);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (91,'Gottlieb, Tillman and Pouros',61.72);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (92,'Nikolaus-Harris',24.82);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (93,'Lemke, Terry and Kohler',66.31);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (94,'Batz, Abshire and Roberts',10.36);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (95,'Witting and Sons',52.61);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (96,'Corwin, Kub and Halvorson',61.26);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (97,'Walker, Friesen and Larkin',28.3);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (98,'Kling-Barrows',17.29);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (99,'Cole Group',2.71);
INSERT INTO Publishers(publisher_id,publisher_name,developer_id) VALUES (100,'Jaskolski and Sons',20.66);

INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (1,36);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (2,88);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (3,36);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (4,76);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (5,96);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (6,46);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (7,74);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (8,51);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (9,98);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (10,55);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (11,6);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (12,73);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (13,72);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (14,5);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (15,8);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (16,10);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (17,45);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (18,21);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (19,19);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (20,16);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (21,56);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (22,57);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (23,38);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (24,41);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (25,11);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (26,21);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (27,2);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (28,56);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (29,78);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (30,57);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (31,72);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (32,97);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (33,35);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (34,40);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (35,99);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (36,26);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (37,15);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (38,46);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (39,28);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (40,87);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (41,75);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (42,10);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (43,66);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (44,45);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (45,89);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (46,77);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (47,46);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (48,99);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (49,99);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (50,98);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (51,14);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (52,57);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (53,55);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (54,91);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (55,82);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (56,78);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (57,19);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (58,30);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (59,24);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (60,22);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (61,68);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (62,6);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (63,19);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (64,24);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (65,29);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (66,10);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (67,37);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (68,79);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (69,22);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (70,45);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (71,77);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (72,9);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (73,28);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (74,15);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (75,72);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (76,69);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (77,18);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (78,26);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (79,18);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (80,49);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (81,12);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (82,90);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (83,22);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (84,24);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (85,99);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (86,77);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (87,50);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (88,46);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (89,53);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (90,79);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (91,45);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (92,65);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (93,18);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (94,22);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (95,74);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (96,33);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (97,40);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (98,52);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (99,91);
INSERT INTO Distributor_Publishers(distributor_id,publisher_id) VALUES (100,47);

INSERT INTO Genres(genre_id,description,genre_name) VALUES (1,'Bvfiliorse','Adventure|Comedy|Sci-Fi');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (2,'Vordzugvmh','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (3,'Nszbcqxkav','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (4,'Yimzfmxuzz','Crime|Drama|Mystery');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (5,'Xtjzqfmeha','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (6,'Xndzjphmre','Action|Crime|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (7,'Pdllcslzcj','Horror');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (8,'Fbkhditegx','Comedy|Musical');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (9,'Qjcdnidbhz','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (10,'Xlwzjeombx','Comedy|Musical|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (11,'Wiiclbkegr','Horror|Mystery|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (12,'Dqslfodjvy','Comedy|Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (13,'Rwmiubmzrb','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (14,'Jlucqnwbxa','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (15,'Iqkmkfdldl','Comedy|Musical|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (16,'Nofwykbeed','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (17,'Vjsxhsemlc','Action|Crime');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (18,'Bykififsvs','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (19,'Toanbnluba','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (20,'Gmwlgayayj','Horror');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (21,'Htupztktxy','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (22,'Txxsmohqkl','Documentary');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (23,'Rtreqruhms','Action|Comedy|IMAX');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (24,'Fzangbaelc','Adventure|Animation|Children');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (25,'Mqxrptydux','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (26,'Obqwlifolc','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (27,'Bhmkmbptlh','Crime|Drama|Mystery|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (28,'Ddpxdfoytq','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (29,'Hzwtnvqywj','Adventure|Drama|War');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (30,'Xpogkvxzsm','Horror|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (31,'Ngurraquip','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (32,'Agepsioytd','Comedy|Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (33,'Lngzuwtkuj','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (34,'Befzisvwte','Western');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (35,'Xtmrxlrxfw','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (36,'Xdulmhaaod','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (37,'Wylzduvnvy','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (38,'Kdhdhewoyb','Drama|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (39,'Cclwudsnuj','Comedy|Musical|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (40,'Yhmelyukme','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (41,'Qqbzyrcjbf','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (42,'Yggnqcuzzo','Drama|Mystery|Sci-Fi');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (43,'Jbjhgslvpy','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (44,'Orndubfefs','Drama|War');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (45,'Fpzhklwcor','Comedy|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (46,'Tmaxahcqeh','Animation|Documentary');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (47,'Guuozhbhlu','Comedy|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (48,'Keecvlsqmy','Comedy|Crime|Drama|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (49,'Hpalfjfocu','Adventure|Animation');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (50,'Qzlptonuxy','Action|Comedy|Crime');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (51,'Ivdlmnvukp','Animation');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (52,'Nzquscfztn','Adventure|Fantasy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (53,'Vrwngolzos','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (54,'Geudegnxby','Documentary|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (55,'Xxtrwcuddp','Action');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (56,'Osfavbxdav','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (57,'Nesmyfwnhd','Action|Sci-Fi');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (58,'Aknvrduhut','Western');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (59,'Sqboddqpnt','Horror|Sci-Fi');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (60,'Uokvmwjmkh','Action|Crime');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (61,'Pizctgwoxo','Comedy|Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (62,'Mzvfjvqfye','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (63,'Bmzmzwhiol','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (64,'Csstbczumt','Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (65,'Nwpqrjdbzp','Action|Adventure');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (66,'Parenavmlj','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (67,'Mtogyxldmw','Drama|Fantasy|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (68,'Jxtzyjlarz','Comedy|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (69,'Eflumhblno','Action|Adventure|Sci-Fi|IMAX');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (70,'Obugkujvls','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (71,'Kkmnvitcrq','Action|Comedy|Horror');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (72,'Gpvszibhil','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (73,'Krqovhitvt','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (74,'Rvjojsnbmi','Comedy|Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (75,'Ohxnphequd','Crime|Film-Noir');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (76,'Uopqvgsner','Documentary');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (77,'Vjpvjrqwsu','Animation|Children');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (78,'Mfgxjpbawb','Comedy|Thriller');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (79,'Gdznidylhh','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (80,'Gjtkosilfx','Adventure|Children');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (81,'Rweomfflqv','Action|Fantasy|War');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (82,'Sqyzfxocba','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (83,'Mgfeyoyntp','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (84,'Golqhiotxv','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (85,'Uiiwpmhjxd','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (86,'Opmrlupsnv','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (87,'Eblcupivak','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (88,'Ixnkdlvway','Adventure|Fantasy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (89,'Meafljbuyt','Animation');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (90,'Ksydstfixj','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (91,'Fatgiqkpye','Drama|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (92,'Tjyrutzcmo','Comedy');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (93,'Sruyewzwet','Action|Adventure');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (94,'Bylojvjzcc','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (95,'Rrvfwsphbq','Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (96,'Saqkfjqnta','Crime|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (97,'Zszeddzcfv','Comedy|Romance');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (98,'Jlclnbhbmm','Comedy|Drama');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (99,'Ryaypwvbmm','Crime|Horror');
INSERT INTO Genres(genre_id,description,genre_name) VALUES (100,'Izzplksxay','Comedy');

INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (1,39,'Rscyovjqqj');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (2,18,'Shqgsafsfx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (3,64,'Qzisqxrsuh');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (4,81,'Debwhooeag');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (5,81,'Gkwtvokkcp');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (6,39,'Rkqqduhucw');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (7,100,'Rchuheemqy');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (8,77,'Mhvxnfmzal');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (9,82,'Svblmtdzqi');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (10,99,'Yjhlbkpccg');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (11,13,'Uzvmhyfwil');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (12,8,'Gkpxcpgcdf');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (13,92,'Bjrmodfneu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (14,86,'Hqpewahtgm');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (15,99,'Lfnzeydovn');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (16,41,'Wchucwfnmf');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (17,47,'Dwtwrhajxx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (18,63,'Cwghsaluqq');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (19,20,'Axxnjwvlaz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (20,51,'Etpznfrpvm');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (21,41,'Xrvwkaaxyg');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (22,57,'Umzclgbrqr');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (23,62,'Iaogamelkt');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (24,79,'Ujczyapqnw');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (25,66,'Jdjdrmgjid');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (26,68,'Ccaenrfwyu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (27,18,'Slcemddnui');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (28,33,'Orzorfqdrf');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (29,51,'Qlfbktrxai');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (30,30,'Qzbdqqklan');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (31,77,'Epttlgxged');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (32,70,'Epfjqugqkv');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (33,67,'Dkbaouluqx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (34,53,'Dbhnemgnia');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (35,5,'Kpvylpltjb');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (36,45,'Vsdffmuetf');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (37,5,'Mmacisqrgt');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (38,85,'Egfndzmndj');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (39,95,'Ijpuikbhta');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (40,71,'Cmcyqqdwtz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (41,26,'Dbgmktybuz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (42,51,'Ezdjiejcze');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (43,92,'Wybaozcbvi');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (44,52,'Wyplianhxh');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (45,77,'Gloxkbqodg');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (46,18,'Cyhmenoroj');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (47,31,'Cotpewkulu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (48,61,'Mpjspnnuue');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (49,1,'Lbquidltqn');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (50,60,'Rmqeiesmhx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (51,62,'Wqnpbjsqed');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (52,10,'Wqvfnitvmd');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (53,14,'Btpqtyeiye');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (54,16,'Wpnkphijde');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (55,24,'Cqbhiqvyud');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (56,62,'Wdafdgnbtl');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (57,90,'Chvtukpjrx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (58,74,'Gbdtrdvpyd');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (59,59,'Aqanpjixvu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (60,87,'Baixtxdpxn');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (61,91,'Ipbgorjphl');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (62,20,'Dwbmdfczwn');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (63,88,'Gatnjbrpjj');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (64,18,'Gxtbfydjlz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (65,48,'Hdkichdwqr');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (66,100,'Vmjfhaobtc');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (67,68,'Twgyyggxpv');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (68,74,'Daqldjdwvz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (69,80,'Dycgfbbvcj');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (70,90,'Qnkmvzfqkv');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (71,79,'Ggeamugemk');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (72,33,'Brcrznwknx');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (73,85,'Irnghexrik');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (74,60,'Nunuyqimxb');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (75,24,'Iiibqdofib');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (76,100,'Sgrveyzezu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (77,62,'Kpgjsgzojf');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (78,56,'Ijawuplhrs');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (79,58,'Orxtvtywbl');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (80,61,'Yhyroehhlh');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (81,42,'Ivalklulda');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (82,50,'Xilpypmtrt');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (83,96,'Lcaakvjsfi');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (84,87,'Ergytrdlgy');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (85,64,'Zgvgzhfrml');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (86,23,'Lawnnowajs');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (87,79,'Gqagmxmice');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (88,47,'Frjxexfezs');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (89,37,'Oeqldibziz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (90,54,'Pemgsryyae');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (91,12,'Wjnvbuatji');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (92,43,'Lldrbshcij');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (93,98,'Odntlodlra');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (94,40,'Paywusxheu');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (95,29,'Vuzolycsxa');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (96,24,'Olyojgrqxs');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (97,2,'Izlxogdqja');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (98,39,'Qfjspnkyir');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (99,33,'Zdtbjsarfz');
INSERT INTO Game_Genres(genre_id,game_id,description) VALUES (100,22,'Aizvvyywja');

INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (1,67,47.06);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (2,7,19.43);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (3,46,48.75);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (4,83,33.78);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (5,25,47.52);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (6,43,36.62);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (7,41,55.57);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (8,18,85.69);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (9,19,92.67);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (10,75,10.55);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (11,47,85.41);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (12,8,5.05);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (13,18,4.02);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (14,43,66.9);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (15,51,69.31);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (16,96,31.09);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (17,39,52.89);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (18,65,31.02);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (19,50,67.23);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (20,53,6.99);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (21,53,91.09);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (22,57,90.21);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (23,4,30.85);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (24,1,95.42);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (25,96,79.46);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (26,93,41.68);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (27,29,67.04);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (28,80,22.63);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (29,81,52.92);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (30,93,36.27);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (31,29,26.21);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (32,9,93.85);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (33,61,4.51);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (34,14,10.05);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (35,22,93.83);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (36,69,39.68);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (37,51,72.32);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (38,29,20.74);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (39,61,98.64);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (40,4,53.53);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (41,61,2.58);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (42,3,27.81);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (43,93,55.56);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (44,96,30.17);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (45,40,15.79);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (46,37,1.94);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (47,15,94.79);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (48,7,83.64);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (49,87,66.46);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (50,78,92.63);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (51,11,75.18);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (52,98,46.86);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (53,38,39.9);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (54,91,92.97);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (55,27,35.25);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (56,43,65.9);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (57,72,38.32);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (58,17,17.67);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (59,6,47.23);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (60,16,91.69);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (61,15,39.08);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (62,12,22.27);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (63,72,28.51);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (64,78,59.55);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (65,59,98.81);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (66,47,54.19);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (67,21,97.22);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (68,32,1.82);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (69,95,57.26);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (70,18,52.86);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (71,55,13.74);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (72,45,62.44);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (73,84,87.29);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (74,47,61.04);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (75,31,96.02);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (76,88,61.26);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (77,18,54.58);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (78,81,32.02);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (79,58,92.3);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (80,69,3.26);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (81,11,10.94);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (82,87,40.45);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (83,70,20.8);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (84,8,63.99);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (85,78,97.24);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (86,96,19.83);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (87,23,47.5);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (88,53,21.17);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (89,99,11.86);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (90,29,69.2);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (91,5,50.82);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (92,45,89.32);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (93,90,40.96);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (94,56,57.59);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (95,61,45.38);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (96,75,47.72);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (97,62,71.1);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (98,91,84.24);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (99,19,39.53);
INSERT INTO Customer_Games(customer_id,game_id,resell_price) VALUES (100,74,56.74);

INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (1,'2022-10-05',738,70,7.82);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (2,'2022-10-27',867,21,52.42);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (3,'2022-10-29',315,94,21.17);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (4,'2022-07-24',892,95,55.2);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (5,'2022-08-30',39,98,70.15);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (6,'2023-01-28',755,17,83.01);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (7,'2023-01-28',991,38,45.22);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (8,'2022-05-19',726,37,2.17);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (9,'2023-03-22',613,38,54.42);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (10,'2022-06-29',369,89,20.61);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (11,'2022-12-06',590,95,33.11);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (12,'2023-02-08',926,91,34.67);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (13,'2022-04-18',591,14,92.36);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (14,'2023-02-19',330,76,34.27);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (15,'2023-03-14',782,12,47.06);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (16,'2023-03-12',911,17,36.09);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (17,'2022-08-13',960,4,9.13);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (18,'2022-08-06',878,34,15.11);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (19,'2022-07-02',986,16,56.95);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (20,'2023-01-15',645,97,72.65);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (21,'2022-08-17',776,81,73.17);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (22,'2022-12-17',144,98,28.62);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (23,'2022-12-19',528,25,83.66);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (24,'2022-12-20',166,65,95.63);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (25,'2022-04-23',977,1,56.37);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (26,'2023-03-15',33,5,23.99);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (27,'2022-07-24',397,68,70.4);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (28,'2023-04-17',62,87,86.67);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (29,'2022-12-23',710,67,59.21);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (30,'2023-04-03',215,28,70.16);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (31,'2022-08-15',918,17,49.38);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (32,'2023-03-24',47,27,4.35);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (33,'2022-09-01',189,38,78.28);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (34,'2022-05-06',578,72,99.06);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (35,'2023-04-05',162,80,53.31);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (36,'2022-05-13',472,95,32.83);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (37,'2023-04-06',141,14,85.49);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (38,'2023-03-31',671,13,93.47);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (39,'2023-02-20',402,14,86.47);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (40,'2023-04-01',935,84,29.95);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (41,'2022-07-26',757,63,5.49);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (42,'2022-09-14',286,15,11.21);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (43,'2022-05-03',217,57,36.33);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (44,'2022-08-19',574,12,96.46);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (45,'2023-02-20',425,20,24.71);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (46,'2023-02-01',144,37,31.48);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (47,'2023-02-02',957,21,75.17);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (48,'2023-03-16',427,84,7.37);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (49,'2022-11-09',9,63,58.45);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (50,'2022-08-07',810,43,54.7);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (51,'2022-06-01',588,9,84.39);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (52,'2022-04-29',886,20,58.97);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (53,'2022-04-24',246,92,50.12);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (54,'2022-05-24',639,4,76.33);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (55,'2023-01-03',68,91,30.38);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (56,'2023-02-19',547,48,35.8);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (57,'2022-06-10',968,69,61.61);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (58,'2023-03-04',657,45,2.94);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (59,'2022-06-09',200,83,78.23);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (60,'2022-07-31',127,26,69.73);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (61,'2023-01-20',143,85,79.12);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (62,'2022-08-27',198,98,75.69);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (63,'2022-11-01',380,64,50.73);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (64,'2022-04-25',918,23,24.81);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (65,'2022-10-21',220,32,1.47);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (66,'2022-07-06',147,43,52.84);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (67,'2023-03-24',310,64,24.67);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (68,'2022-11-02',224,25,26.69);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (69,'2022-09-28',859,91,78.52);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (70,'2022-08-04',238,98,40.74);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (71,'2023-02-04',531,20,99.32);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (72,'2022-10-14',190,44,14.02);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (73,'2022-08-15',85,54,77.41);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (74,'2023-02-07',922,87,68.81);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (75,'2022-08-26',970,48,53.72);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (76,'2022-09-01',180,66,28.26);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (77,'2023-02-02',219,63,77.08);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (78,'2022-10-26',589,96,29.18);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (79,'2022-05-04',369,25,56.04);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (80,'2022-08-13',112,73,67.65);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (81,'2022-08-11',306,49,93.54);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (82,'2023-03-22',15,98,54.64);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (83,'2022-10-07',620,73,83.81);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (84,'2022-12-22',955,76,12.84);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (85,'2022-10-20',245,37,30.8);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (86,'2022-12-05',901,4,17.68);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (87,'2022-09-05',694,17,14.22);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (88,'2022-09-28',203,50,46.9);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (89,'2022-05-18',290,18,44.29);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (90,'2022-10-16',442,49,17.53);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (91,'2023-01-05',787,40,16.13);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (92,'2022-11-22',741,34,23.98);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (93,'2022-10-04',435,62,40.69);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (94,'2022-11-03',718,85,23.32);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (95,'2023-03-29',916,16,45.37);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (96,'2023-02-13',665,30,77.36);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (97,'2022-07-08',920,1,66.54);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (98,'2022-07-17',832,34,57.08);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (99,'2022-06-08',432,20,6.54);
INSERT INTO Inventory_Stats(inventory_stats_id,time_arrived,quantity,game_id,returned_quantity) VALUES (100,'2022-11-01',79,65,91.3);

