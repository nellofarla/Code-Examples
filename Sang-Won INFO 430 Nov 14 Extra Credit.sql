-- INFO 430 Nov 14 Extra Credit
-- Author: Sang-Won Yu

-- Write the SQL to determine the students that meet the following conditions:

-- 1. Have spent between the 11th and 57th percentile of registration fees on classes held on the Quad.

WITH CTE_Q1 (S_ID, Fname, Lname, RegFee, Ranky)
AS (SELECT S.StudentID, S.StudentFname, S.StudentLname, CL.RegistrationFee,
NTILE(100) OVER (order by CL.RegistrationFee DESC)
    FROM tblSTUDENT S
        JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
        JOIN tblCLASS CS ON CL.ClassID = CS.ClassID
        JOIN tblCLASSROOM CR ON CS.ClassroomID = CR.ClassroomID
        JOIN tblBUILDING BL ON CR.BuildingID = BL.BuildingID
        JOIN tblLOCATION LC ON BL.LocationID = LC.LocationID
    AND LC.LocationName LIKE '%Quad%'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname, CL.RegistrationFee)

SELECT * FROM CTE_Q1 WHERE Ranky BETWEEN 11 AND 57

-- 2. The credits they have earned in Arts and Sciences or Medicine are ranked between 32nd and 71st among all students born after 1954.

WITH CTE_Q2 (S_ID, Fname,Lname, Creds, Ranky)
AS (SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(CR.Credits) AS CumCreds,
NTILE(100) OVER (order by SUM(CR.Credits) DESC)
    FROM tblSTUDENT S
        JOIN tblCLASS_LIST CL ON S.StudentID = CL.StudentID
        JOIN tblCLASS CS ON CL.ClassID = CS.ClassID
        JOIN tblCOURSE CR ON CS.CourseID = CR.CourseID
        JOIN tblDEPARTMENT DP ON CR.DeptID = DP.DeptID
        JOIN tblCOLLEGE CO ON DP.CollegeID = CO.CollegeID
    WHERE CO.CollegeName LIKE 'Medicine'
    OR CO.CollegeName LIKE 'Arts%Sciences'
    AND S.StudentBirth > '1954'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname)

SELECT * FROM CTE_Q2 WHERE Ranky BETWEEN 32 AND 71

-- 3. The amount of money spent on UW dorm/housing is between 23rd and 81st of all students born after 1956.

WITH CTE_Q3 (S_ID, Fname,Lname, Fees, Ranky)
AS (SELECT S.StudentID, S.StudentFname, S.StudentLname, SUM(SD.DormLeaseFee) AS CumFees,
NTILE(100) OVER (order by SUM(SD.DormLeaseFee) DESC)
    FROM tblSTUDENT S
        JOIN tblSTUDENT_DORMROOM SD ON S.StudentID = SD.StudentID
    WHERE S.StudentBirth > '1956'
GROUP BY S.StudentID, S.StudentFname, S.StudentLname)

SELECT * FROM CTE_Q3 WHERE Ranky BETWEEN 23 AND 81