use master
go

create database PeopleGroups
go

use PeopleGroups
go

CREATE TABLE [dbo].[group_info](
	[group_id] [int] IDENTITY(1,1) primary key,
	[group_name] [varchar](50) NULL,
)
go

CREATE TABLE [dbo].[person](
	[person_id] [int] IDENTITY(1,1) primary key,
	[first_name] [varchar](50), 
	[last_name] [varchar](50),
	[nickname] [varchar](50),
	[email] [varchar](100),
	[add1] [varchar](100),
	[city] [varchar](100),
	[state] [varchar](30),
	[zip] [varchar](5),
) 
GO

CREATE TABLE [dbo].[person_group](
	[person_group_id] [int] IDENTITY(1,1) primary key,
	[group_id] [int] NULL,
	[person_id] [int] NULL)

	go



CREATE PROC Add_person_to_group(@group_id  INT,
                                @person_id INT)
AS
  BEGIN
      INSERT INTO person_group
                  (group_id,
                   person_id)
      VALUES     (@group_Id,
                  @person_id)
  END

go


CREATE PROC Get_persons
AS
  BEGIN
      SELECT *
      FROM   person
  END

go

create PROC Get_persons_in_group(@group_id INT)
AS
  BEGIN
      SELECT person.*
      FROM   person
             JOIN person_group
               ON person.person_id = person_group.person_id
             JOIN group_info
               ON person_group.group_id = group_info.group_id
      WHERE  group_info.group_id = @group_id
  END

go



create PROC Get_persons_not_in_group(@group_id INT)
AS
  BEGIN
      SELECT person.*
      INTO   #tmp_person
      FROM   person
             JOIN person_group
               ON person.person_id = person_group.person_id
             JOIN group_info
               ON person_group.group_id = group_info.group_id
      WHERE  group_info.group_id = @group_id


      SELECT *
      FROM   person
             LEFT JOIN #tmp_person
                    ON person.person_id = #tmp_person.person_id
      WHERE  #tmp_person.person_id IS NULL
  END

go




CREATE PROC Remove_person_from_group(@group_id  INT,
                                     @person_id INT)
AS
  BEGIN
      DELETE person_group
      WHERE  person_id = @person_id
             AND group_id = @group_id
  END

go


CREATE PROC Create_group(@group_name VARCHAR(50))
AS
  BEGIN
      INSERT INTO group_info
                  (group_name)
      VALUES     (@group_name)
  END

go 

CREATE PROC [dbo].[Get_groups]
AS
  BEGIN
      SELECT *
      FROM   group_info
  END

go 


CREATE PROC [dbo].[Delete_group](@group_id INT)
AS
  BEGIN
      DELETE person_group
      WHERE  group_id = @group_id

      DELETE group_info
      WHERE  group_id = @group_id
  END

go 


CREATE TYPE [dbo].person_type AS TABLE(
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[nickname] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[add1] [varchar](100) NULL,
	[city] [varchar](100) NULL,
	[state] [varchar](30) NULL,
	[zip] [varchar](5) NULL
)
GO

CREATE PROC [dbo].[Insert_persons](@persons person_type readonly)
AS
  BEGIN
      INSERT INTO person
                  (first_name,
                   last_name,
                   nickname,
                   email,
                   add1,
                   city,
                   state,
                   zip)
      SELECT *
      FROM   @persons
  END

go 