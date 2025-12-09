-- יצירת מסד נתונים
CREATE DATABASE MADA
GO

-- שימוש במסד הנתונים שיצרנו
USE MADA
GO

-- יצירת טבלת דרגות
CREATE TABLE darga (
    idDarga INT IDENTITY(1,1) PRIMARY KEY,
    nameDara VARCHAR(20) NOT NULL
)
GO

-- יצירת טבלת סוגי רכבים
CREATE TABLE typeCars (
    idCar INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(20) NOT NULL
)
GO

-- יצירת טבלת סניפים
CREATE TABLE branchs (
    idB INT IDENTITY(1,1) PRIMARY KEY,
    nameB VARCHAR(20) NOT NULL,
    addressb VARCHAR(20) NOT NULL,
    city VARCHAR(20) NOT NULL
)
GO

-- יצירת טבלת אירועים
CREATE TABLE eventss (
    idEvent INT IDENTITY(1,1) PRIMARY KEY,
    nameE VARCHAR(20),
    idCar INT REFERENCES typeCars,
    idDmin INT REFERENCES darga,
    sumConan INT,
    sumGeneralConan INT
)
GO

-- יצירת טבלת כוננים פעילים
CREATE TABLE conanim (
    idConan INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    idA INT REFERENCES branchs,
    idD INT REFERENCES darga NOT NULL,
    idCar INT REFERENCES typeCars,
    phone VARCHAR(10) NOT NULL,
    tokef DATE NOT NULL
)
GO

-- יצירת טבלת קריאות
CREATE TABLE calls (
    idCall INT IDENTITY(1,1) PRIMARY KEY,
    time_call DATE NOT NULL,
    idA INT REFERENCES branchs,
    idEvent INT REFERENCES eventss,
    discribe VARCHAR(40),
    exactAddress VARCHAR(50),
    story VARCHAR(50)
)
GO

-- טבלת כוננים לא פעילים
CREATE TABLE no_active (
    idConan INT PRIMARY KEY,
    name VARCHAR(20),
    idA INT REFERENCES branchs,
    idD INT REFERENCES darga NOT NULL,
    idCar INT REFERENCES typeCars,
    phone VARCHAR(10) NOT NULL,
    tokef DATE NOT NULL
)
GO

-- טבלת תגובות כוננים פעילים
CREATE TABLE replay_Of_Conan (
    idReplay INT IDENTITY(1,1) PRIMARY KEY,
    idCall INT REFERENCES calls NOT NULL,
    idConan INT REFERENCES conanim NOT NULL,
    time_arrive DATE NOT NULL,
    ps VARCHAR(40)
)
GO

-- טבלת תגובות היסטוריות לכוננים לא פעילים
CREATE TABLE old_replay (
    idReplay INT PRIMARY KEY,
    idCall INT REFERENCES calls NOT NULL,
    idConan INT REFERENCES no_active NOT NULL,
    time_arrive DATE NOT NULL,
    ps VARCHAR(40)
)
GO
