-- VIEW המציג את הכוננים שענו לקריאות
ALTER VIEW viewlink AS
SELECT conanim.idConan, name
FROM replay_Of_Conan
JOIN conanim ON conanim.idConan = replay_Of_Conan.idConan
GO

-- פונקציה שמחזירה את מזהה הכונן שענה להכי הרבה קריאות
CREATE FUNCTION max_call()
RETURNS INT AS
BEGIN
    DECLARE @idconan INT
    SELECT @idconan = idConan FROM (
        SELECT idConan, COUNT(*) AS c,
               ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rowNumber
        FROM viewlink
        GROUP BY idConan
    ) q
    WHERE rowNumber = 1
    RETURN @idconan
END
GO

-- פרוצדורה להעברת כוננים שתוקפם פג לטבלת לא פעילים
CREATE PROCEDURE no_act AS
BEGIN
    DECLARE crs_tokef CURSOR FOR SELECT tokef FROM conanim
    OPEN crs_tokef
    DECLARE @date DATE
    FETCH NEXT FROM crs_tokef INTO @date
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@date <= GETDATE())
        BEGIN
            EXEC move_to_noAct @date
        END
        FETCH NEXT FROM crs_tokef INTO @date
    END
    CLOSE crs_tokef
    DEALLOCATE crs_tokef
END
GO

-- פרוצדורה להעברת כונן אחד ללא פעיל כולל תגובות
CREATE PROCEDURE move_to_noAct (@tokef DATE) AS
BEGIN
    INSERT INTO no_active
    SELECT * FROM conanim WHERE tokef = @tokef

    INSERT INTO old_replay
    SELECT * FROM replay_Of_Conan
    WHERE idConan IN (SELECT idConan FROM conanim WHERE tokef = @tokef)

    DELETE FROM replay_Of_Conan
    WHERE idConan IN (SELECT idConan FROM conanim WHERE tokef = @tokef)

    DELETE FROM conanim WHERE tokef = @tokef
END
GO

-- טריגר שמחזיר כונן לפעילות אם התוקף עודכן לעתיד
CREATE TRIGGER update_tokef ON no_active
AFTER UPDATE AS
BEGIN
    DECLARE @tokef DATE
    SELECT @tokef = tokef FROM INSERTED
    IF UPDATE(tokef)
        IF (@tokef > GETDATE())
            EXEC move_to_Act @tokef
END
GO

-- פרוצדורה להעברת כונן לפעיל
CREATE PROCEDURE move_to_Act (@tokef DATE) AS
BEGIN
    INSERT INTO conanim
    SELECT * FROM no_active WHERE tokef = @tokef

    INSERT INTO replay_Of_Conan
    SELECT idCall, idConan, time_arrive, ps
    FROM old_replay
    WHERE idConan IN (SELECT idConan FROM conanim WHERE tokef = @tokef)

    DELETE FROM old_replay WHERE idConan IN (SELECT idConan FROM conanim WHERE tokef = @tokef)
    DELETE FROM no_active WHERE tokef = @tokef
END
GO

-- פונקציה שמחזירה את הסניף עם זמן ההגעה הממוצע הגבוה ביותר לכל דרגה
ALTER FUNCTION big_avg_arrive()
RETURNS TABLE AS
RETURN
    SELECT idD, COUNT(idConan) AS count_conan, MAX(branch) AS max_branch
    FROM conanim
    JOIN (
        SELECT idA AS branch,
               AVG(DATEDIFF(MINUTE, time_arrive, time_call)) AS avg_time_reply,
               ROW_NUMBER() OVER (ORDER BY AVG(DATEDIFF(MINUTE, time_arrive, time_call)) DESC) AS rowNumber
        FROM calls
        JOIN replay_Of_Conan ON calls.idCall = replay_Of_Conan.idCall
        GROUP BY idA
    ) branch_avg_time_reply
    ON branch_avg_time_reply.branch = idA
    WHERE rowNumber = 1
    GROUP BY idD
GO

-- פונקציה שמחזירה כוננים שתוקפם פג בעוד פחות מ-30 יום
CREATE FUNCTION tokef()
RETURNS TABLE AS
RETURN
    SELECT name, phone FROM conanim
    WHERE tokef < DATEADD(DAY, 30, GETDATE())
GO

-- פונקציה שמחזירה קריאות שלא נענו
CREATE FUNCTION not_in_call()
RETURNS TABLE AS
RETURN
    SELECT idCall, idA
    FROM calls
    WHERE idCall NOT IN (SELECT idCall FROM replay_Of_Conan)
GO

-- פונקציה שמחזירה את מספר הקריאות הקשות
CREATE FUNCTION num_hard_calls()
RETURNS SMALLINT AS
BEGIN
    DECLARE @count SMALLINT
    SELECT @count = COUNT(*) FROM (
        SELECT idCall FROM calls
        EXCEPT
        SELECT idCall FROM calls
        JOIN eventss ON calls.idEvent = eventss.idEvent
        WHERE idDmin < 4
    ) w
    RETURN @count
END
GO

-- VIEW להצגת כונן עם הכי הרבה תגובות ואירועים
CREATE VIEW report_max_replay AS
SELECT w.idConan, time_call, nameE
FROM replay_Of_Conan
JOIN (
    SELECT idConan, COUNT(*) AS countC,
           ROW_NUMBER() OVER (PARTITION BY idConan ORDER BY COUNT(*) DESC) AS rowNumber
    FROM replay_Of_Conan
    GROUP BY idConan
) w ON replay_Of_Conan.idConan = w.idConan
JOIN calls ON calls.idCall = replay_Of_Conan.idCall
JOIN eventss ON calls.idEvent = eventss.idEvent
WHERE rowNumber = 1
GO
