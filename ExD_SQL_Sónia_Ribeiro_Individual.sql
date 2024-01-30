drop table snsuser cascade constraints;
drop table local cascade constraints;
drop table HealthcareFacility cascade constraints;
drop table vaccineappointment cascade constraints;
drop table checkin cascade constraints;
drop table Nurse cascade constraints;
drop table vaccinecall cascade constraints;
drop table vaccinationcertificate cascade constraints;
drop table lot cascade constraints;
drop table Vaccine cascade constraints;
drop table vaccinationRegistration cascade constraints;
drop table adversereaction cascade constraints;
drop table waitingroom cascade constraints;
drop table vaccinationroom cascade constraints;
drop table recoveryroom cascade constraints;
drop table vaccinetechnology cascade constraints;
drop table VaccinationCenter cascade constraints;
drop table Receptionist cascade constraints;
drop table HealthCenter cascade constraints;
drop table Employee cascade constraints;
drop table Brand cascade constraints;
drop table VaccineType cascade constraints;



create table snsuser (
name varchar(50),
birthDate date,
sex varchar(10),
postalAddress varchar(100),
phoneNumber number,
emailAddress varchar(100),
citizenCardNumber varchar(20),
snsUserNumber number);

alter table snsuser add constraint pk_snsUserNumber primary key (snsUserNumber);

create table local (
localID number);

alter table local add constraint pk_localID primary key (localID);

create table HealthcareFacility (
healthcareFacilityID number,
namehf varchar(50),
adresshf varchar(200),
phoneNumberhf number,
emailAddresshf varchar(50),
faxNumberhf number,
websiteAddresshf varchar (200),
openingHourshf date,
closingHourshf date);

alter table HealthcareFacility add constraint pk_healthcareFacility primary key (healthcareFacilityID);

create table vaccineappointment (
vaccineAppointmentID number, 
dataVaccine date,
timeVaccine date,
vaccineType varchar(15),
healthcareFacility varchar(30),
snsUserNumberID number,
healthcareFacilityID number);


alter table vaccineappointment add constraint pk_vaccineAppointmentID primary key (vaccineAppointmentID);
alter table vaccineappointment add constraint fk_snsUserNumber_snsUser foreign key (snsUserNumberID) references snsuser (snsUserNumber);
alter table vaccineappointment add constraint fk_healthcareFacilityID foreign key (healthcareFacilityID) references HealthcareFacility (healthcareFacilityID);


create table checkin (
checkInID number,
vaccineAppointmentID number,
localID number,
receptionistid number);

alter table checkin add constraint pk_checkInID primary key (checkInID);
alter table checkin add constraint fk_vaccineAppointmentID foreign key (vaccineAppointmentID) references vaccineappointment (vaccineAppointmentID);
alter table checkin add constraint fk_localID foreign key (localID) references local (localID);

create table Nurse (
nurseID number,
healthcareFacilityID number,
employeeID number
);

alter table Nurse add constraint pk_nurseID primary key (nurseID);

create table vaccinecall (
vaccineCallID number,
checkInID number,
nurseID number);

alter table vaccinecall add constraint pk_vaccineCallID primary key (vaccineCallID);
alter table vaccinecall add constraint fk_checkInID foreign key (checkInID) references checkin (checkInID);
alter table vaccinecall add constraint fk_nurseID foreign key (nurseID) references Nurse (nurseID);


create table vaccinationcertificate (
vaccinationCertificateID number);

alter table vaccinationcertificate add constraint pk_vaccinationCertificateID primary key (vaccinationCertificateID);

create table lot (
lotID number,
vaccineID number
);

alter table lot add constraint pk_lotID primary key (lotID);

create table Vaccine (
vaccineID number,
name_vaccine varchar(20),
vaccineTypeCode number,
brandID number);

alter table Vaccine add constraint pk_vaccineID primary key (vaccineID);

create table vaccinationRegistration (
vaccinationRegistrationID number,
vaccineID number,
vaccineCallID number,
localid number,
lotID number,
vaccinationCertificateID number,
nurseID number);

alter table vaccinationRegistration add constraint pk_vaccinationRegistrationID primary key (vaccinationRegistrationID);
alter table vaccinationRegistration add constraint fk_vaccineCallID foreign key (vaccineCallID) references vaccinecall (vaccineCallID);
alter table vaccinationRegistration add constraint fk_local_ID foreign key (localid) references local (localID);
alter table vaccinationRegistration add constraint fk_vaccinationCertificateID foreign key (vaccinationCertificateID) references vaccinationCertificate (vaccinationCertificateID);
alter table vaccinationRegistration add constraint fk_vaccineID foreign key (vaccineID) references Vaccine (vaccineID);
alter table vaccinationRegistration add constraint fk_lotID foreign key (lotID) references lot (lotID);
alter table vaccinationRegistration add constraint fk_nurse foreign key (nurseID)references Nurse (nurseID);


create table adversereaction (
adverseReactionID number,
vaccinationRegistrationID number);

alter table adversereaction add constraint pk_adverseReactionID primary key (adverseReactionID);
alter table adversereaction add constraint fk_vaccinationRegistrationID foreign key (vaccinationRegistrationID) references vaccinationRegistration (vaccinationRegistrationID);

create table waitingroom (
waitingRoomID number,
localID number);

alter table waitingroom add constraint pk_waitingRoomID primary key (waitingRoomID);
alter table waitingroom add constraint fk_localId_waitingRoom foreign key (localID) references local (localID);

create table vaccinationroom (
vaccinationRoomID number,
localID number);

alter table vaccinationroom add constraint pk_vaccinationRoomID primary key (vaccinationRoomID);
alter table vaccinationroom add constraint fk_localID_vaccinationRoom foreign key (localID) references local (localID);

create table recoveryroom (
recoveryRoomID number,
localID number);

alter table recoveryroom add constraint pk_recoveryRoomID primary key (recoveryRoomID);
alter table recoveryroom add constraint fk_localId_recoveryRoom foreign key (localID) references local (localID);

create table vaccinetechnology(
vaccineTechnologyID number,
name varchar(10),
description varchar(200));

create table VaccinationCenter (
vaccinationCenterID number,
maxNumbVacPerhour number,
healthcareFacilityID number
);

alter table VACCINATIONCENTER add CONSTRAINT pk_VACCINATIONCENTERID primary key (VACCINATIONCENTERID);
alter table VACCINATIONCENTER add CONSTRAINT fk_HEALTHCAREFACILITY FOREIGN KEY (HEALTHCAREFACILITYID) REFERENCES HEALTHCAREFACILITY (HEALTHCAREFACILITYID);

create table Receptionist (
receptionistID number,
healthcareFacilityID number,
employeeID number);

alter table RECEPTIONIST add constraint pk_RECEPTIONISTID primary key (RECEPTIONISTID);

create table HealthCenter (
healthCenterID number,
healthcareFacilityID number);

alter table HEALTHCENTER add constraint pk_HEALTHCENTERID primary key (HEALTHCENTERID);
alter table HEALTHCENTER add CONSTRAINT fk_HEALTHCENTERID FOREIGN KEY (HEALTHCAREFACILITYID) REFERENCES HEALTHCAREFACILITY (HEALTHCAREFACILITYID);

create table Employee (
employeeID number,
employee_Name varchar(50),
employee_Email varchar(50),
employee_Role varchar (20),
employee_PhoneNumber number);

alter table employee add constraint pk_employeeID primary key (employeeID);


create table Brand (
brandID number,
name_Brand varchar(20)
);

create table VaccineType (
vaccineTypeCode number,
shortDescription_vaccinetype varchar(20),
vaccineTechnologyID number
);


alter table RECEPTIONIST add CONSTRAINT fk_RECEPTIONIST  FOREIGN key (employeeid) REFERENCES employee (employeeID);
alter table RECEPTIONIST add CONSTRAINT fk_HEALTHCAREFACILITYID2 foreign key (HEALTHCAREFACILITYID) references HEALTHCAREFACILITY (HEALTHCAREFACILITYID);

alter table lot add constraint fk_vaccineID2 foreign key (vaccineid) references vaccine (vaccineid);

alter table brand add constraint pk_brandID primary key (brandid);
alter table vaccine add constraint fk_brandid foreign key (brandid) references brand (brandid);

alter table vaccinetype add constraint pk_VACCINETYPECODE primary key (VACCINETYPECODE);

alter table vaccine add constraint fk_VACCINETYPECODE2 FOREIGN key (VACCINETYPECODE) references VACCINETYPE (VACCINETYPECODE);

alter table VACCINETECHNOLOGY add constraint pk_VACCINETECHNOLOGYID primary key (VACCINETECHNOLOGYID);

alter table vaccinetype add constraint fk_VACCINETECHOLOGYID foreign key (VACCINETECHNOLOGYID) references VACCINETECHNOLOGY (VACCINETECHNOLOGYID);

alter table nurse add constraint fk_HEALTHCAREFACILITYID3 foreign key (HEALTHCAREFACILITYID) references HEALTHCAREFACILITY (HEALTHCAREFACILITYID);

alter table nurse add constraint fk_EMPLOYEEID2 foreign key (EMPLOYEEID) references EMPLOYEE (EMPLOYEEID);

alter table checkin add constraint fk_receptionistid foreign key (receptionistid) references receptionist (receptionistid);