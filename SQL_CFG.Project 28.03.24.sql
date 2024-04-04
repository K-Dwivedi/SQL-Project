--CFG PROJECT USING SQL-- by Kiran Dwivedi  28/03/2024

--This is a music store dataset that I found from a source.

--This dataset has 11 tables named- album, artist, customer, employee, genre, invoice,invoice_line, media_type, playlist, playlist_track, and track.
--Let's see the data in all the tables:

SELECT * FROM album
SELECT * FROM artist
SELECT * FROM customer
SELECT * FROM employee
SELECT * FROM genre
SELECT * FROM invoice
SELECT * FROM invoice_line
SELECT * FROM media_type
SELECT * FROM playlist
SELECT * FROM playlist_track
SELECT * FROM track


--I will be doing some questions to fetch the data and find relationships between the tables. 
--I will be mentioning the questions and the process/query to find the answers. I will start with easy questions.


------------------------------------------------------------------------------------------------------------------------------------



--Ques:1. Who is the senior most employee based on job title?
--Solution:
--I need to check the employee table for this

SELECT * FROM employee

-- Now I will use order by clause in descending order to find the seniority of the employee, will use limit to find only one record 
SELECT * FROM employee
ORDER BY levels desc
limit 1

--Answer: Mohan Madan is the senior most having L7 level.


-------------------------------------------------------------------------------------------------------------------------------



--Ques:2- Which countries have the most invoices?
--Solution:
-- I will be using invoice table and let's see what columns are present there

SELECT * FROM invoice 

-- so billing_country field would be useful to get info about the ques-2
-- I would use count() to get the total number of the countries with most invoices, I would use group by function to the billing_country column to get total number of the invoices occured in a single country(which are presented more then once)

SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC

--Answer: USA has the most invoices as 131.


--------------------------------------------------------------------------------------------------------------------------------



--Ques:3- What are the top 3 values of total invoice?
--Solution:
-- I will be using invoice table 

SELECT* FROM invoice

-- will use total column and sort that using order by with using limit for top 3


SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3

--Answer: I found the top 3 values now.



---------------------------------------------------------------------------------------------------------------------------------



--Ques:4- Who is the best customer? The customer who has spent the most money will be declared the best customer.
--Write a query that returns the person who has spent the most money. 

--Solution:
--In this ques I need the information about the customer so I would use customer table

SELECT * FROM customer
-- in the customer table there is no info related to invoice so that I could get who spent most. 
-- So I have to join the invoice table with the customer table.
-- customer_id is the column present in both the table so I will join the tables based on this column
--customer_id would work as Primary key in customer table and Foreign key in the invoice table 
-- I will fetch customer data from customer table and sum of total from invoice table 

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total)as total
FROM customer
JOIN invoice ON customer.customer_id  = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1

--Answer: R Madhav is the person who spent the most money.


---------------------------------------------------------------------------------------------------------------------------


-- Ques: 5 Write a query to return the email, first name, last name & genre of all Rock Music listeners. Return the list ordered alphabetically by email starting with letter A.
--Solution: 
--I will answer this question in parts.
-- I have to join multiple tables on the basis of Primary and Foreign keys to establish relation among them and to get result


SELECT DISTINCT email AS Email, first_name AS FirstName, last_name AS LastName, genre.name as GenreName    --(Distinct function is used to get different values and avoid the duplicates)
FROM customer
JOIN invoice ON customer.customer_id  = invoice.customer_id 
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email

-- I found this optimised query structure to avoid lots of joins

SELECT DISTINCT email, first_name, last_name  --(Distinct function is used to get different values and avoid the duplicates)
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
  SELECT track_id FROM track
  JOIN genre ON track.genre_id = genre.genre_id
  WHERE genre.name LIKE 'Rock'
)
ORDER BY email



--------------------------------------------------------------------------------------------------

--Ques:6- Which top 10 tracks are the bestseller?
--Solution:

-- First I would check the track table 
SELECT * FROM track

--Now I will use count function to count the name of track and will group by the name column

SELECT COUNT(*) AS c, name
FROM track
GROUP BY name
ORDER BY c DESC
LIMIT 10

--------------------------------------------------------------------------------------------------

--Ques:7- Find out which genre was being purchased the most.
--Solution:
-- 

SELECT * FROM genre


SELECT COUNT(name) AS c, name
FROM genre
GROUP BY name
ORDER BY c DESC
LIMIT 1


--------------------------------------------------------------------------------------------------------------------------------------


--Ques:8- Which city has the best customers? Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name and sum of all invoice totals.

--Solution:

--So I can find data in invoice table so let's see the data in the table
SELECT * FROM invoice

--I need city and invoice total data to solve the question as with the invoice total I can find the most money spent by the particular city
--I will use group by clause for billing_city column to get result based on city

SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
Limit 1

--Answer: Prague

-- If I put Limit as 3 or 5 then I will get top 3 or 5 results.




--------------------------------------------------------------------------------------------------------------------------------------



--Ques:9 Which artist is the most loved? 
--Solution:


SELECT artist.artist_id, artist.name, Count(album.title) AS c
FROM artist
JOIN album ON artist.artist_id  = album.artist_id
GROUP BY artist.name, artist.artist_id
ORDER BY c DESC
LIMIT 1

--Answer: Iron Maiden


---------------------------------------------------------------------------------------------------------------------------------------

--Ques:10- Find the artist who has written the most rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 rock bands.
--Solution:

--I would need to get data from artist, album and genre tables so I have to join them. 
-- All these table have a foreign key in track table so I will join them but to join artist table on artist_id with track table I have to join album table to track table on album_id

SELECT artist.artist_id,artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
limit 10


-- I got the artist name(seems like a band name) according to the number of songs.


--------------------------------------------------------------------------------------------------------------------------------------