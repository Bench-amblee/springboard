/*PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables.

QUESTIONS */
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT facid, name, membercost
FROM Facilities
WHERE membercost <> 0

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(facid) as total_facilities
FROM Facilities
WHERE membercost = 0


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost <> 0
AND membercost < 0.2 * monthlymaintenance


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * 
FROM Facilities
WHERE facid
IN (1,5)


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100
THEN 'Expensive'
ELSE 'Cheap'
END AS Label
FROM Facilities


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM Members
WHERE joindate = (
SELECT MAX(joindate)
FROM Members
)


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT(f.name) as facility_name, CONCAT(m.firstname,' ',m.surname) AS member_name
FROM Members as b
USING (memid)
INNER JOIN Facilities as f
USING (facid)
WHERE facid IN (0,1)
ORDER BY member_name


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT CONCAT(m.firstname,' ',m.surname) AS member_name, f.name as facility_name,
CASE WHEN m.memid = 0 THEN b.slots * f.guestcost
ELSE b.slots * f.membercost
END AS cost
FROM Members AS m
INNER JOIN Bookings as b
USING (memid)
INNER JOIN Facilities as f
USING (facid)
WHERE b.starttime LIKE '2012-09-14%'
AND ((m.memid = 0 AND b.slots*f.guestcost > 30) OR (m.memid != AND b.slots*f.membercost > 30))
ORDER BY cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT member_name, facility_name, cost FROM (
    SELECT CONCAT(m.firstname,' ',m.surname) AS member_name, f.name as facility_name,
    CASE WHEN m.memid = 0 THEN b.slots * f.guestcost
    ELSE b.slots * f.membercost
    END AS cost
    FROM Members AS m
    INNER JOIN Bookings AS b
    USING (memid)
    INNER JOIN Facilities AS f
    USING (facid)
    WHERE b.starttime LIKE '2012-09-14%'
    ) AS bookings
WHERE cost > 30
ORDER BY cost DESC