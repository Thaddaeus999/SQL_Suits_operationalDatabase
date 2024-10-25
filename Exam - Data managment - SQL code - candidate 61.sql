---DATA MANAGEMENT EXAM------------
--Below you will find 3 parts:
--Part 1: Creating Schema and creating tables
--Part 2: Inserting into tables, the information
--Part 3: Creating queires which are all phrased as questions

-- ###-----------------------------

-- -------------------------------------------
-- Part 1: Creating Schema and creating tables
-- -------------------------------------------

--Reset code: ---------------------
-- Schema dropping to add variables
DROP SCHEMA IF EXISTS ruleX CASCADE;
-- ---------------------------------

CREATE SCHEMA ruleX;

-- Core entities
CREATE TABLE ruleX.Specialization(
    SpecializationID INTEGER PRIMARY KEY,
    Specialization VARCHAR(55),
    SpecializationFixedPrice NUMERIC);

CREATE TABLE ruleX.LawyerInfo(
    LawyerID SERIAL PRIMARY KEY,
    LawyerName VARCHAR(55),
    SpecializationID INTEGER REFERENCES ruleX.Specialization(SpecializationID),
    Qualification VARCHAR(55));

CREATE TABLE ruleX.Cases(
    CaseID SERIAL PRIMARY KEY,
    CaseDetails VARCHAR(55),
	CaseStatus varchar(50),
	SpecializationID INTEGER references ruleX.Specialization(SpecializationID));

CREATE TABLE ruleX.ClientInfo(
    ClientID SERIAL PRIMARY KEY,
    DateOfBirth TIMESTAMP,
	ClientName VARCHAR(55),
    Country VARCHAR(55));

CREATE TABLE ruleX.ClientContact(
    ClientContactID SERIAL PRIMARY KEY,
    ClientCalling VARCHAR(55),
    InformationNoted VARCHAR(55),
    ClientID INTEGER REFERENCES ruleX.ClientInfo(ClientID));

CREATE TABLE ruleX.MeetingRoom(
    MeetingRoomID SERIAL PRIMARY KEY,
    MeetingRoomName VARCHAR(1));

CREATE TABLE ruleX.MeetingRecord(
    MeetingRecordID SERIAL PRIMARY KEY,
    MeetingRoomPlanned VARCHAR(255),
    MeetingStartTime TIMESTAMP,
    MeetingEndTime TIMESTAMP,
    MeetingRoomID INTEGER REFERENCES ruleX.MeetingRoom(MeetingRoomID));

--Combo entities
CREATE TABLE ruleX.Case_Lawyer_Combo(
    CaseLawyerComboID SERIAL PRIMARY KEY,
    CaseID INTEGER REFERENCES ruleX.Cases(CaseID),
    LawyerID INTEGER REFERENCES ruleX.LawyerInfo(LawyerID),
    LawyerRole VARCHAR(55));

CREATE TABLE ruleX.Client_Case_Combo(
    ClientCaseComboID SERIAL PRIMARY KEY,
    CaseID INTEGER REFERENCES ruleX.Cases(CaseID),
    ClientID INTEGER REFERENCES ruleX.ClientInfo(ClientID),
	ClientType varchar(55));

CREATE TABLE ruleX.Client_Contact_ClientInfo_Combo(
    ClientRecordCombinationID SERIAL PRIMARY KEY,
    ClientRecordID INTEGER REFERENCES ruleX.ClientContact(ClientContactID),
    ClientID INTEGER REFERENCES ruleX.ClientInfo(ClientID));

CREATE TABLE ruleX.Client_Contact_MeetingRecord_Combo(
    ClientContactMeetingRecordID SERIAL PRIMARY KEY,
    ClientContactID INTEGER REFERENCES  ruleX.ClientContact(ClientContactID),
    MeetingRecordID INTEGER REFERENCES  ruleX.MeetingRecord(MeetingRecordID));

CREATE TABLE ruleX.Lawyer_Meeting_Combo(
    LawyerMeetingComboID SERIAL PRIMARY KEY,
    LawyerID INTEGER REFERENCES ruleX.LawyerInfo(LawyerID),
    MeetingRecordID INTEGER REFERENCES ruleX.MeetingRecord(MeetingRecordID));

CREATE TABLE ruleX.Case_Meeting_Combo(
    CaseMeetingComboID SERIAL PRIMARY KEY,
    MeetingRecordID INTEGER REFERENCES  ruleX.MeetingRecord(MeetingRecordID),
    CaseID INTEGER REFERENCES  ruleX.Cases(CaseID));


-- ------------------------------------------------
-- Part 2: Inserting into tables, the information 
-- ------------------------------------------------

--Inserting data:
insert into ruleX.Specialization (SpecializationID, Specialization, SpecializationFixedPrice)
values (1,'Corporate law',10000), (2,'Family',1700),(3,'Traffic',600),(4,'CriminalCases',6000);

select * from ruleX.Specialization;

--insert meeting room
insert into ruleX.MeetingRoom(MeetingRoomID,MeetingRoomName)
values (1,'A'), (2,'B'),(3,'C'),(4,'D'),(5,'E'),(6,'F'),(7,'G'),(8,'H'),(9,'I'),(10,'J');
select * from ruleX.MeetingRoom;

-- Lawyer data

insert into ruleX.LawyerInfo (LawyerID, LawyerName, SpecializationID, Qualification)
values (1,'Harvy Specter',1,'Harvard law'), (2,'Mike Ross',1,'No education'),(3,'Louis Litt',2,'Harvard law'),
(4,'Jessica Pearson',4,'Harvard law'),(5,'Daniel Hardman',4,'Harvard law'),(6,'Rachel Zane',3,'Columbia Law'),
(7,'JAck Solof',4,'Harvard law'),(8,'Kristina Bennet',1,'Harvard law'),
(9,'Paul Porter',1,'Harvard law'),(10,'John Doe',1,'Harvard law');
select * from ruleX.LawyerInfo;

--Cases insert

insert into ruleX.Cases (CaseID, CaseDetails,SpecializationID, CaseStatus)
values (1,'Gillis industries takeover',1,'open'),(2,'Mike Ross trial',4,'open'), (3,'Folsom foods trial',1,'pending'),
(4,'Liquid water suit',1,'open'), (5,'Hessington oil murder trial',4,'closed');
select * from ruleX.Cases;

-- Client info
insert into ruleX.ClientInfo(ClientID,DateOfBirth,Country,ClientName)
values (1,'1960-01-15 10:30:00', 'Ireland','Connor McGregor'),(2,'1988-10-05 14:45:00','United States',  'Mike Ross'),
(3,'2022-12-25 08:00:00', 'United States','Demetrious Jonson'),
(4,'2025-07-04 18:20:00','United States','Michael Bisping'), (5,'2021-03-30 23:59:59', 'Canada','GSP');

select * from ruleX.ClientInfo;

--drop table if exists ruleX.Case_Law CASCADE;
-- Case_Lawyer_Combo: Assign lawyers to cases
insert into ruleX.Case_Lawyer_Combo (CaseLawyerComboID,CaseID, LawyerID, LawyerRole)
values 
(1,1, 1, 'primary'), (2,1, 2, 'secondary'),(3,1, 7,'secondary' ),
(4,2, 2, 'primary'),(5,2, 1, 'secondary'),(6,2, 4, 'secondary'),
(7,3, 3, 'primary'),(8, 3, 2, 'secondary'),(9, 3, 9, 'secondary'),
(10,4, 4, 'primary'),(11,4, 9, 'secondary'),(12,4, 10, 'secondary'),
(13, 4, 2, 'secondary'),
(14,5, 5, 'primary'), (15, 5, 2, 'secondary'),(16, 5, 8, 'secondary'); 
select * from ruleX.Case_Lawyer_Combo;


-- Insert records into the ClientContact table
insert into ruleX.ClientContact (ClientCalling, InformationNoted, ClientID)
values ('Called regarding Gillis industries', 'Discussed merger details', 1),('Called regarding Mike Ross trial', 'Discussed trial strategy', 2), 
    ('Called regarding Folsom foods trial', 'Discussed legal advice', 3),('Called regarding Liquid water suit', 'Discussed case details', 4),  
    ('Called regarding Hessington oil murder trial', 'Reviewed evidence', 5); 

select * from ruleX.ClientContact;

-- Client_Case_Combo: Connect clients to their cases
insert into ruleX.Client_Case_Combo (CaseID, ClientID,ClientType)
values 
(1, 1,'plaintif'), 
(2, 2,'plaintif'), 
(3, 3,'defendant'), 
(4, 4, 'defendant'),
(5, 5,'plaintif'); 

select * from ruleX.Client_Case_Combo;


-- Client_Contact_ClientInfo_Combo: Associate client contacts with clients
insert into ruleX.Client_Contact_ClientInfo_Combo (ClientRecordID, ClientID)
values 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5);

select * from ruleX.Client_Contact_ClientInfo_Combo;

-- drop table if exists ruleX.MeetingRecord CASCADE;
-- Insert records into the MeetingRecord table
insert into ruleX.MeetingRecord (MeetingRoomPlanned, MeetingStartTime, MeetingEndTime, MeetingRoomID)
values
  ('Room A', '2024-01-15 10:00:00', '2024-01-15 11:30:00', 1), 
    ('Room B', '2024-02-10 14:10:00', '2024-02-10 15:30:00', 2), 
 ('Room C', '2024-03-20 09:00:00', '2024-03-20 10:30:00', 3), 
    ('Room D', '2024-04-05 13:00:00', '2024-04-05 14:45:00', 4),
    ('Room E', '2024-05-12 16:05:00', '2024-05-12 17:30:00', 5);
select * from ruleX.MeetingRecord;


-- Client_Contact_MeetingRecord_Combo: Link client contact to meeting records
insert into ruleX.Client_Contact_MeetingRecord_Combo (ClientContactID, MeetingRecordID)
values 
(1, 1),
(2, 2), 
(3, 3),
(4, 4), 
(5, 5); 

select * from ruleX.Client_Contact_MeetingRecord_Combo;

-- Lawyer_Meeting_Combo: Associate lawyers with meeting records
insert into ruleX.Lawyer_Meeting_Combo (LawyerID, MeetingRecordID)
values 
(1, 1),
(2, 1), 
(3, 2), 
(4, 3), 
(5, 4), 
(6, 5);

select * from ruleX.Lawyer_Meeting_Combo;

-- drop table if exists ruleX.Case_Meeting_Combo Cascade;

-- Case_Meeting_Combo: Link cases to meeting records
insert into ruleX.Case_Meeting_Combo (MeetingRecordID, CaseID)
values 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5); 

select * from ruleX.Case_Meeting_Combo;

-- -----------------------------------------------------------
-- Part 3: Creating queires which are all phrased as questions
-- -----------------------------------------------------------

--1. What is the count of clients by different countries and client type?
select  ci.country, ccc.clienttype,  count(ci.clientid) from ruleX.ClientInfo ci
left join ruleX.Client_Case_Combo ccc on ccc.clientid = ci.clientid
group by ci.country,ccc.clienttype
order by ci.country desc;


--2.sum of revenue from all cases by specialization /type of case
select s.specialization, sum(s.specializationfixedprice) rev from ruleX.Specialization s
right join ruleX.Cases c on s.specializationid =c.specializationid
group by s.specialization
order by rev desc;

--3. average time of a meeting by country of client
select ci.country, avg(m.meetingendtime-m.meetingstarttime) average from ruleX.meetingrecord m
left join ruleX.Client_Contact_MeetingRecord_Combo CC_MR on CC_MR.meetingrecordid = m.meetingrecordid
join ruleX.ClientContact cc on CC_MR.clientcontactid = cc.clientcontactid
join ruleX.ClientInfo ci on ci.clientid = cc.clientid
group by ci.country
order by average desc;

--4. what is the number of cases per lawyer?
select li.lawyername, count(c.caseid) from ruleX.LawyerInfo li
left join ruleX.Case_Lawyer_Combo clc on clc.lawyerid =li.lawyerid
join ruleX.Cases c on clc.caseid = c.caseid
group by li.lawyername
order by count(c.caseid) desc;

--5. what is the number of primary and secondary lawyer roles for each lawyer
select li.lawyername, clc.LawyerRole, count(clc.LawyerRole) from ruleX.LawyerInfo li
left join ruleX.Case_Lawyer_Combo clc on clc.lawyerid =li.lawyerid
join ruleX.Cases c on clc.caseid = c.caseid
group by li.lawyername, clc.LawyerRole
order by clc.LawyerRole desc, count(clc.LawyerRole) desc;






