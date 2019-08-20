-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: library
-- ------------------------------------------------------
-- Server version	8.0.17

DROP   SCHEMA IF     EXISTS `library`;
CREATE SCHEMA IF NOT EXISTS `library`;
USE                         `library`;

--
-- Table structure for table `tbl_author`
--

DROP TABLE IF EXISTS `tbl_author`;
CREATE TABLE `tbl_author` (
  `authorId`    int(11)     NOT NULL    AUTO_INCREMENT,
  `authorName`  varchar(45) NOT NULL    UNIQUE,
  PRIMARY KEY (`authorId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_author`
--

LOCK TABLES `tbl_author` WRITE;
ALTER TABLE `tbl_author` DISABLE KEYS;

INSERT INTO `tbl_author` (authorId, authorName)
                  VALUES (1,        "J. K. Rowling"),
                         (2,        "Bernie Sanders"),
						 (3,		"Dr. Seuss"),
						 (4,		"Stephen King"),
						 (5,		"Dan Brown"),
						 (6,		"King James"),
						 (7,		"Daniel Kahneman"),
						 (8,		"Dale Carnegie");

ALTER TABLE `tbl_author` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_publisher`
--

DROP TABLE IF EXISTS `tbl_publisher`;
CREATE TABLE `tbl_publisher` (
  `publisherId`         int(11)     NOT NULL                    UNIQUE  AUTO_INCREMENT,
  `publisherName`       varchar(45) NOT NULL                    UNIQUE,
  `publisherAddress`    varchar(45)             DEFAULT NULL,
  `publisherPhone`      varchar(45)             DEFAULT NULL,
  PRIMARY KEY (`publisherId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_publisher`
--

LOCK TABLES `tbl_publisher` WRITE;
ALTER TABLE `tbl_publisher` DISABLE KEYS;

INSERT INTO `tbl_publisher` (publisherId, publisherName,    publisherAddress,               publisherPhone)
                     VALUES (1,           "British Press",  "3 Big Ben's Shadow, London",   "4 (118) 555-8779-24-0119-725-3"),
                            (2,           "Random House",   "25 10th St, Philadelphia",     "1 (800) 224-7677"),
                            (3,           "Scholastic", 	"421 Lincoln, Chicago",			"1 (847) 451-2277"),
                            (4,           "Mascot Books",   "22 W 12th St, Herndon, VA",	"1 (703) 437-3584");

ALTER TABLE `tbl_publisher` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_book`
--

DROP TABLE IF EXISTS `tbl_book`;
CREATE TABLE `tbl_book` (
  `bookId`  int(11)     NOT NULL                    AUTO_INCREMENT,
  `title`   varchar(45) NOT NULL                    UNIQUE,
  `pubId`   int(11)                 DEFAULT NULL,
  PRIMARY KEY (`bookId`),
  KEY `fk_publisher` (`pubId`),
  CONSTRAINT `fk_publisher` FOREIGN KEY (`pubId`) REFERENCES `tbl_publisher` (`publisherId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_book`
--

LOCK TABLES `tbl_book` WRITE;
ALTER TABLE `tbl_book` DISABLE KEYS;

INSERT INTO `tbl_book` (bookId, title,          							pubID)
                VALUES (1,      "Harry Potter", 							1),
                       (2,      "Our Revolution",							2),
					   (3,		"The Holy Bible",							4),
					   (4,      "Thinking: Fast and Slow", 					3),
					   (5,		"How to Win Friends and Influence People",	1);

ALTER TABLE `tbl_book` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_book_authors`
--

DROP TABLE IF EXISTS `tbl_book_authors`;
CREATE TABLE `tbl_book_authors` (
  `bookId`      int(11) NOT NULL,
  `authorId`    int(11) NOT NULL,
  PRIMARY KEY (`bookId`,`authorId`),
  KEY `fk_tbl_book_authors_tbl_author1_idx` (`authorId`),
  CONSTRAINT `fk_tbl_book_authors_tbl_author1` FOREIGN KEY (`authorId`) REFERENCES `tbl_author` (`authorId`),
  CONSTRAINT `fk_tbl_book_authors_tbl_book1` FOREIGN KEY (`bookId`) REFERENCES `tbl_book` (`bookId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tbl_book_authors`
--

LOCK TABLES `tbl_book_authors` WRITE;
ALTER TABLE `tbl_book_authors` DISABLE KEYS;

INSERT INTO `tbl_book_authors` (bookId, authorId)
                        VALUES (1,      1),
                               (2,      2),
							   (3,		6),
							   (4,		7),
							   (5,		8);

ALTER TABLE `tbl_book_authors` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_library_branch`
--

DROP TABLE IF EXISTS `tbl_library_branch`;
CREATE TABLE `tbl_library_branch` (
  `branchId`        int(11)     NOT NULL                    AUTO_INCREMENT,
  `branchName`      varchar(45)             DEFAULT NULL,
  `branchAddress`   varchar(45)             DEFAULT NULL,
  PRIMARY KEY (`branchId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_library_branch`
--

LOCK TABLES `tbl_library_branch` WRITE;
ALTER TABLE `tbl_library_branch` DISABLE KEYS;

INSERT INTO tbl_library_branch (branchId, 	branchName,                           	branchAddress)
                        VALUES (1,        	"City of Fairfax Regional Library",   	"10360 North St, Fairfax"),
                               (2,        	"Chicago Public Library",             	"2000 Milennium Dr, Chicago"),
							   (3,			"New York Public Library",				"224 e 125th St, New York");

ALTER TABLE `tbl_library_branch` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_book_copies`
--

DROP TABLE IF EXISTS `tbl_book_copies`;
CREATE TABLE `tbl_book_copies` (
  `bookId`      int(11) NOT NULL,
  `branchId`    int(11) NOT NULL,
  `noOfCopies`  int(11)             DEFAULT NULL,
  PRIMARY KEY (`bookId`,`branchId`),
  KEY `fk_bc_book` (`bookId`),
  KEY `fk_bc_branch` (`branchId`),
  CONSTRAINT `fk_bc_book` FOREIGN KEY (`bookId`) REFERENCES `tbl_book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bc_branch` FOREIGN KEY (`branchId`) REFERENCES `tbl_library_branch` (`branchId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_book_copies`
--

LOCK TABLES `tbl_book_copies` WRITE;
ALTER TABLE `tbl_book_copies` DISABLE KEYS;

INSERT INTO `tbl_book_copies` (bookId,  branchId,   noOfCopies)
                       VALUES (1,       1,          1),
                              (2,       1,          1),
                              (3,       2,          1),
                              (4,       2,          1),
                              (1,       3,          5),
                              (2,       3,          5),
                              (3,       3,          5),
                              (4,       3,          5),
                              (5,       3,          5);

ALTER TABLE `tbl_book_copies` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_genre`
--

DROP TABLE IF EXISTS `tbl_genre`;
CREATE TABLE `tbl_genre` (
  `genre_id`    int(11)     NOT NULL                    AUTO_INCREMENT,
  `genre_name`  varchar(45) NOT NULL    UNIQUE,
  PRIMARY KEY (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tbl_genre`
--

LOCK TABLES `tbl_genre` WRITE;
ALTER TABLE `tbl_genre` DISABLE KEYS;

INSERT INTO `tbl_genre` (genre_id, 	genre_name)
                 VALUES (1,        	"Fantasy"),
                        (2,        	"Non-Fiction"),
						(3,			"Mystery"),
						(4,			"Self-Help"),
						(5,			"Fiction"),
						(6,			"Mythology"),
						(7,			"Religious"),
						(8,			"Adventure"),
						(9,			"Political");

ALTER TABLE `tbl_genre` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_book_genres`
--

DROP TABLE IF EXISTS `tbl_book_genres`;
CREATE TABLE `tbl_book_genres` (
  `genre_id`    int(11) NOT NULL,
  `bookId`      int(11) NOT NULL,
  PRIMARY KEY (`genre_id`,`bookId`),
  KEY `fk_tbl_book_genres_tbl_book1_idx` (`bookId`),
  CONSTRAINT `fk_tbl_book_genres_tbl_book1` FOREIGN KEY (`bookId`) REFERENCES `tbl_book` (`bookId`),
  CONSTRAINT `fk_tbl_book_genres_tbl_genre1` FOREIGN KEY (`genre_id`) REFERENCES `tbl_genre` (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tbl_book_genres`
--

LOCK TABLES `tbl_book_genres` WRITE;
ALTER TABLE `tbl_book_genres` DISABLE KEYS;

INSERT INTO `tbl_book_genres` (genre_id,    bookId)
                       VALUES (1,           1),
							  (5,           1),
							  (3,           1),
							  (8,           1),
                              (2,           2),
                              (9,           2),
                              (6,           3),
                              (7,           3),
                              (2,           4),
                              (4,           4),
                              (2,           5),
                              (4,           5);

ALTER TABLE `tbl_book_genres` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_borrower`
--

DROP TABLE IF EXISTS `tbl_borrower`;
CREATE TABLE `tbl_borrower` (
  `cardNo`  int(11)     NOT NULL                    AUTO_INCREMENT,
  `name`    varchar(45) NOT NULL,
  `address` varchar(45)             DEFAULT NULL,
  `phone`   varchar(45)             DEFAULT NULL,
  PRIMARY KEY (`cardNo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_borrower`
--

LOCK TABLES `tbl_borrower` WRITE;
ALTER TABLE `tbl_borrower` DISABLE KEYS;

INSERT INTO `tbl_borrower` (cardNo, name,           address,                        phone)
                    VALUES (1,      "Kim Jung Un",  "1 Glorious Palace, Pyongyang", "384 (652) 634-5862"), -- He is grorious reader.
                           (2,      "John X. Doe",  "5 Main St, Boston",            "1 (104) 322-6857"),
						   (3,		"Michael Aman",	"25 Von Vaugn St, Wausau",		"1 (608) 122-8676"),
						   (4,		"Rosa Lampman",	"206 Seneca Ln, Port Edwards",	"1 (608) 353-2221"),
						   (5,		"Ann Jacobs",	"67 Beech View Ct, Fairfax",	"1 (703) 612-1239");

ALTER TABLE `tbl_borrower` ENABLE KEYS;
UNLOCK TABLES;

--
-- Table structure for table `tbl_book_loans`
--

DROP TABLE IF EXISTS `tbl_book_loans`;
CREATE TABLE `tbl_book_loans` (
  `bookId`          int(11)     NOT NULL,
  `branchId`        int(11)     NOT NULL,
  `cardNo`          int(11)     NOT NULL,
  `dateOut`         datetime    NOT NULL,
  `dueDate`         date                DEFAULT NULL,
  `returnedDate`    datetime            DEFAULT NULL,
  PRIMARY KEY (`bookId`,`branchId`,`cardNo`,`dateOut`),
  KEY `fk_bl_book` (`bookId`),
  KEY `fk_bl_branch` (`branchId`),
  KEY `fk_bl_borrower` (`cardNo`),
  CONSTRAINT `fk_bl_book` FOREIGN KEY (`bookId`) REFERENCES `tbl_book` (`bookId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bl_borrower` FOREIGN KEY (`cardNo`) REFERENCES `tbl_borrower` (`cardNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bl_branch` FOREIGN KEY (`branchId`) REFERENCES `tbl_library_branch` (`branchId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_book_loans`
--

LOCK TABLES `tbl_book_loans` WRITE;
ALTER TABLE `tbl_book_loans` DISABLE KEYS;

INSERT INTO `tbl_book_loans` (bookId,	branchId,	cardNo,	dateOut,		dueDate,		returnedDate)
					  VALUES (1,		1,			5,		'2019-03-21',	'2019-03-28',	'2019-03-27'),
							 (2,		2,			5,		'2019-04-21',	'2019-04-28',	'2019-04-24'),
							 (3,		3,			5,		'2019-05-21',	'2019-05-28',	'2019-05-26'),
							 (4,		3,			5,		'2019-06-21',	'2019-06-28',	NULL),
							 (5,		3,			5,		'2019-08-16',	'2019-08-23',	NULL);

ALTER TABLE `tbl_book_loans` ENABLE KEYS;
UNLOCK TABLES;

-- DONE initializing data


















-- START loading stored procedures

-- getBookTitleFromID
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a bookID, returns its title.
-- SHOULD have no strange behaviors due to FOREIGN KEYs preventing bad table data.
DROP FUNCTION IF EXISTS getBookTitleFromID;
DELIMITER //
CREATE FUNCTION getBookTitleFromID (bookID INT)
RETURNS VARCHAR(45)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE bookTitle VARCHAR(45);
    
    SELECT b.title INTO bookTitle
        FROM tbl_book b
        WHERE b.bookId = bookID;
    
    RETURN bookTitle;
END; //
DELIMITER ;

-- getBookCopies
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a bookID & branchID, returns the number of copies of that book.
-- Returns 0 (zero) when there is no entry in tbl_book_copies.
DROP FUNCTION IF EXISTS getBookCopies;
DELIMITER //
CREATE FUNCTION getBookCopies (bookID INT, branchID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE copies INT DEFAULT 0;
    
    SELECT bc.noOfCopies INTO copies
        FROM tbl_book_copies bc
        WHERE bc.bookId   = bookID
          AND bc.branchId = branchID;
    
    IF copies IS NULL THEN
        RETURN 0;
    END IF;
    
    RETURN copies;
END; //
DELIMITER ;

-- getDaysUntil
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a DATE, returns how many days until that DATE.
DROP FUNCTION IF EXISTS getDaysUntil;
DELIMITER //
CREATE FUNCTION getDaysUntil (dueDate DATE)
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
    DECLARE daysUntil INT;
    
    SET daysUntil = DATEDIFF(dueDate, NOW());
    
    RETURN daysUntil;
END; //
DELIMITER ;

-- getPublisherName
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a pubID, returns its name, or "N/A" if pubID is 0 (zero) or NULL.
DROP FUNCTION IF EXISTS getPublisherName;
DELIMITER //
CREATE FUNCTION getPublisherName (pubID INT)
RETURNS VARCHAR(45)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE pubName VARCHAR(45);
	
	IF pubID = 0 OR pubID IS NULL THEN
		RETURN "N/A";
	END IF;
	
	SELECT p.publisherName INTO pubName
		FROM tbl_publisher p
		WHERE p.publisherId = pubID;
	
	RETURN pubName;
END; //
DELIMITER ;

-- getLoans
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a borrower cardNo, returns all non-returned loans for that person.
--
-- Format:
-- Title | Due Date | Days Until Due
DROP PROCEDURE IF EXISTS getLoans;
DELIMITER //
CREATE PROCEDURE getLoans (cardNo INT)
BEGIN
    SELECT bl.branchId AS "Branch ID", bl.bookId AS "Book ID", getBookTitleFromID(bl.bookId) AS "Title", bl.dueDate AS "Due Date", getDaysUntil(bl.dueDate) AS "Days Until Due"
        FROM tbl_book_loans bl
        WHERE bl.cardNo = cardNo
          AND bl.returnedDate IS NULL;
END; //
DELIMITER ;

-- getLoansCount
--
-- AUTHOR Anthony Pergrossi
--
-- Helper function, accepts a borrower cardNo, returns count of non-returned loans for that person.
--
-- Format:
-- Count
DROP FUNCTION IF EXISTS getLoansCount;
DELIMITER //
CREATE FUNCTION getLoansCount (cardNo INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE loansCount INT;

    SELECT COUNT(1) INTO loansCount
        FROM tbl_book_loans bl
        WHERE bl.cardNo = cardNo
          AND bl.returnedDate IS NULL;
    
    RETURN loansCount;
END; //
DELIMITER ;

-- HW2 Problem #1, Check out a book.
-- Assumes we received as input: bookID, branchID, cardNo.
-- AUTHOR Anthony
DROP PROCEDURE IF EXISTS borrowBook;
DELIMITER //
CREATE PROCEDURE borrowBook (IN COBookID INT, COBranchID INT, COCardNo INT)
BEGIN
    DECLARE copies                INT;
    DECLARE alreadyBorrowed       INT;
    DECLARE duplicateTransactions INT;
    DECLARE curTime               DATETIME;
    DECLARE CODueDate             DATE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT "An error has occurred, operation rollbacked and the stored procedure was terminated." AS Error;
    END;
    
    SELECT NOW() INTO curTime;
    START TRANSACTION;
    
    -- Get book count, and store result.
    SELECT noOfCopies INTO copies
        FROM tbl_book_copies bc
        WHERE bc.bookID = COBookID
        AND bc.branchID = COBranchID
        FOR UPDATE;
    
    IF copies IS NULL OR copies <= 0 THEN
        ROLLBACK;
        SELECT "This branch does not have the requested book." AS Error;
    ELSE
        SELECT COUNT(1) INTO alreadyBorrowed
            FROM tbl_book_loans bl
            WHERE bl.bookID   = COBookID
              AND bl.branchID = COBranchID
              AND bl.cardNo   = COCardNo
              AND bl.returnedDate IS NULL;
        
        IF alreadyBorrowed IS NOT NULL AND alreadyBorrowed >= 1 THEN
            ROLLBACK;
            SELECT "Borrower already borrowed a copy of this book, and has not yet returned it." AS Error;
        ELSE
            SELECT COUNT(1) INTO duplicateTransactions
                FROM tbl_book_loans bl
                WHERE bl.bookID   = COBookID
                  AND bl.branchID = COBranchID
                  AND bl.cardNo   = COCardNo
                  AND bl.dateOut  = curTime;
            
            IF duplicateTransactions IS NOT NULL AND duplicateTransactions >= 1 THEN
                ROLLBACK;
                SELECT "Duplicate transaction, try again after at least 1 second." AS Error;
            ELSE
                -- Decrement the book count at that branch.
                UPDATE tbl_book_copies bc
                    SET noOfCopies = copies - 1
                    WHERE bc.bookID = COBookID
                    AND bc.branchID = COBranchID;
                
                SELECT DATE(DATE_ADD(curTime, INTERVAL 7 DAY)) INTO CODueDate;
                
                -- Add book loan record. Due in 1 week.
                INSERT INTO tbl_book_loans (bookID,     branchID,   cardNo,     dateOut,   dueDate)
                                     VALUE (COBookID,   COBranchID, COCardNo,   curTime,   CODueDate);
                
                COMMIT;
                SELECT "Borrow success! Your book is due in 7 days." AS Result, CODueDate AS "Due Date";
            END IF;
        END IF;
    END IF;
END; //
DELIMITER ;

-- HW2 Problem #2, Return a book.
-- Assumes we received as input: bookID, branchID, cardNo.
-- AUTHOR Anthony
DROP PROCEDURE IF EXISTS returnBook;
DELIMITER //
CREATE PROCEDURE returnBook (IN RBookID INT, RBranchID INT, RCardNo INT)
BEGIN
    DECLARE copies          INT;
    DECLARE alreadyBorrowed INT;
    DECLARE curTime         DATETIME;
    DECLARE overdueDays     INT;
    DECLARE returnDate      DATE;
    
    SELECT NOW() INTO curTime;
    SELECT DATE(curTime) INTO returnDate;
    START TRANSACTION;
    
    SELECT COUNT(1) INTO alreadyBorrowed
        FROM tbl_book_loans bl
        WHERE bl.bookID   = RBookID
          AND bl.branchID = RBranchID
          AND bl.cardNo   = RCardNo
          AND bl.returnedDate IS NULL
        FOR UPDATE;
        
    IF alreadyBorrowed IS NOT NULL AND alreadyBorrowed >= 1 THEN
        -- Get book count, and store result.
        SELECT noOfCopies INTO copies
            FROM tbl_book_copies bc
            WHERE bc.bookID = RBookID
            AND bc.branchID = RBranchID
            FOR UPDATE;
            
        -- Increment the book count at that branch.
        UPDATE tbl_book_copies bc
            SET noOfCopies = copies + 1
            WHERE bc.bookID = RBookID
            AND bc.branchID = RBranchID;
        
        -- Read the due date, subtract today, store result.
        SELECT DATEDIFF(curTime, bl.dueDate) INTO overdueDays
            FROM tbl_book_loans bl
            WHERE bl.bookID   = RBookID
              AND bl.branchID = RBranchID
              AND bl.cardNo   = RCardNo
              AND bl.returnedDate IS NULL;
        
        IF overdueDays IS NOT NULL AND overdueDays >= 1 THEN
            SELECT "Book is overdue. Collect fee from borrower." AS Result, "$25" AS Fee, overdueDays AS "Days Overdue";
        END IF;
        
        UPDATE tbl_book_loans bl
            SET returnedDate = curTime
            WHERE bl.bookID   = RBookID
              AND bl.branchID = RBranchID
              AND bl.cardNo   = RCardNo
              AND bl.returnedDate IS NULL;
        
        COMMIT;
        SELECT "Return success!" AS Result, curTime AS "Time Returned";
    ELSE
        ROLLBACK;
        SELECT "Borrower has not borrowed this book from this branch." AS Error;
    END IF;
END; //
DELIMITER ;

DELIMITER  //
DROP PROCEDURE IF EXISTS addBook;
CREATE PROCEDURE addBook(booktitle VARCHAR(45), publisherID INT, idofgenre INT, idofAuthor INT)
BEGIN
    DECLARE idofBook INT DEFAULT 0;
    
    IF publisherID = 0 THEN
        SET publisherID = NULL;
    END IF;
    
    START TRANSACTION;
    INSERT INTO tbl_book(title, pubId) 
    VALUES(booktitle, publisherID);
    
    SELECT bookId INTO idofBook
    FROM tbl_book
    WHERE booktitle = title;
    
    IF idofgenre <> 0 THEN
        INSERT INTO tbl_book_genres(bookId, genre_id)
        VALUES(idofBook, idofgenre);
    END IF;
    
    IF idofAuthor <> 0 THEN
        INSERT INTO tbl_book_authors(bookId, authorId)
        VALUES(idofBook, idofAuthor);
    END IF;
	
	COMMIT;
	
	SELECT b.bookId, b.title, getPublisherName(b.pubID) AS "Publisher"
		FROM tbl_book b
		WHERE b.bookID = idofbook;
	SELECT authorName FROM tbl_author WHERE authorID = idofAuthor;
	SELECT genre_name FROM tbl_genre WHERE genre_id = idofgenre;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS updateBook;
DELIMITER //
CREATE PROCEDURE updateBook(idofbook INT, newTitle VARCHAR(45), newPubId INT)
BEGIN
    IF newTitle <> 'N/A' THEN
        UPDATE tbl_book 
        SET title = newTitle
        WHERE idofbook = bookId;
    END IF;
    
    IF newPubId <> 'N/A' THEN
        UPDATE tbl_book
        SET pubId = newPubId
        WHERE idofbook = bookId;
    END IF;
    
    SELECT bookId, title, pubId FROM tbl_book WHERE bookId = idofbook;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS deleteBook;
DELIMITER //
CREATE PROCEDURE deleteBook(bookID INT)
BEGIN
    DELETE FROM tbl_book_loans bl
    WHERE bl.bookId = bookID;
    
    DELETE FROM tbl_book_copies bc
    WHERE bc.bookId = bookID;

    DELETE FROM tbl_book_genres g
    WHERE g.bookId = bookID;
    
    DELETE FROM tbl_book_authors a
    WHERE a.bookId = bookID;
    
    DELETE FROM tbl_book b
    WHERE b.bookId = bookID;
END; //
DELIMITER ;

-- addPublisher
--
-- AUTHOR Anthony Pergrossi
--
-- Requirements: pubName must be not null and unique.
DROP PROCEDURE IF EXISTS addPublisher;
DELIMITER //
CREATE PROCEDURE addPublisher (IN pubName VARCHAR(45), IN pubAddr VARCHAR(45), IN pubPhone VARCHAR(45))
BEGIN
    DECLARE duplicates INT;
    
    IF pubName IS NULL OR pubName = "N/A" THEN
        SELECT "Cannot add publisher, name is a required field." AS Error;
    ELSE
        IF pubAddr = "N/A" THEN
            SET pubAddr = NULL;
        END IF;
        IF pubPhone = "N/A" THEN
            SET pubPhone = NULL;
        END IF;
        
        -- Check that this publisher does not already exist.
        SELECT COUNT(1) INTO duplicates
            FROM tbl_publisher p
            WHERE p.publisherName = pubName;
        
        IF duplicates IS NOT NULL AND duplicates >= 1 THEN
            SELECT "Cannot add publisher, a publisher with that name already exists!" AS Error, pubName AS "Duplicate Name";
        ELSE
            START TRANSACTION;
            INSERT INTO tbl_publisher (publisherName,   publisherAddress,   publisherPhone)
                                VALUE (pubName,         pubAddr,            pubPhone);
            COMMIT;
            SELECT "Success! New publisher data stored." AS Message;
        END IF;
    END IF;
    
    SELECT publisherId, publisherName, publisherAddress, publisherPhone FROM tbl_publisher WHERE publisherName = pubName AND publisherAddress = pubAddr AND publisherPhone = pubPhone;
END; //
DELIMITER ;

-- updatePublisher
--
-- AUTHOR Anthony Pergrossi
--
-- Requirements:
-- pubID must be valid
-- pubName must be unique
DROP PROCEDURE IF EXISTS updatePublisher;
DELIMITER //
CREATE PROCEDURE updatePublisher (IN pubID INT, IN pubName VARCHAR(45), IN pubAddr VARCHAR(45), IN pubPhone VARCHAR(45))
BEGIN
    DECLARE idCount         INT;
    DECLARE duplicateNames  INT;
    
    START TRANSACTION;
    SELECT COUNT(1) INTO idCount
        FROM tbl_publisher p
        WHERE p.publisherId = pubID
        FOR UPDATE;
    
    IF idCount <> 1 THEN
        SELECT "Cannot update publisher, ID does not refer to a real publisher." AS Error, pubID AS "Publisher ID";
    ELSE
        -- Check that this publisher name does not already exist.
        SELECT COUNT(1) INTO duplicateNames
            FROM tbl_publisher p
            WHERE p.publisherId   = pubID
              AND p.publisherName = pubName;
        
        IF duplicateNames >= 1 THEN
            SELECT "Cannot update publisher, a different publisher with that name already exists!" AS Error, pubName AS "Duplicate Name";
        ELSE
            IF pubName <> "N/A" THEN
                UPDATE tbl_publisher p
                    SET p.publisherName = pubName
                    WHERE p.publisherId = pubID;
            END IF;
            IF pubAddr <> "N/A" THEN
                UPDATE tbl_publisher p
                    SET p.publisherAddress = pubAddr
                    WHERE    p.publisherId = pubID;
            END IF;
            IF pubPhone <> "N/A" THEN
                UPDATE tbl_publisher p
                    SET p.publisherPhone = pubPhone
                    WHERE  p.publisherId = pubID;
            END IF;
            
            COMMIT;
            SELECT "Success! New publisher data stored." AS Message;
        END IF;
    END IF;
    
    SELECT publisherId, publisherName, publisherAddress, publisherPhone FROM tbl_publisher WHERE pubID = publisherId;
END; //
DELIMITER ;

-- deletePublisher
--
-- AUTHOR Anthony Pergrossi
--
-- Requires:
-- None.
--
-- Side effects:
-- Clears all references to this publisher in tbl_book.
DROP PROCEDURE IF EXISTS deletePublisher;
DELIMITER //
CREATE PROCEDURE deletePublisher (IN pubID INT)
BEGIN
    DECLARE booksPublishedBy INT;
    SELECT COUNT(1) INTO booksPublishedBy
        FROM tbl_book b
        WHERE b.pubId = pubID;
    
    START TRANSACTION;
    
    UPDATE tbl_book b SET b.pubId = NULL WHERE b.pubId = pubID;
    DELETE FROM tbl_publisher p
        WHERE p.publisherId = pubID;
        
    COMMIT;
    SELECT "Success! Publisher data deleted." AS Message, booksPublishedBy AS "Books Affected";
END; //
DELIMITER ;

-- Alter Loan Due Date
-- 
-- AUTHOR Anthony Pergrossi
-- 
-- Admin function, allows a library system admin to change the due date on a book loan.
-- To identify a book loan, we require the BookID, BranchID, BorrowerID, and check out timestamp.
-- The timestamp will require a bash prompt to select the correct book loan.
--
-- Prompt Mockup
-- 
-- Enter BorrowerID:>_                     (User enter ID no.)
--                                          (System looks up book loans for that BorrowerID.)
--
--
--
-- Please select which book loan to alter:
-- 1) Harry Potter [out on loan, 2 days past due]            (Display sorted:
-- 2) Game of Thrones [out on loan, due in 3 days]                First:  Out on loan, past due,    ordered by MOST overdue
-- 3) The Little Prince [returned on 2019-08-15 19:05:32]         Second: Out on loan, not yet due, ordered by LEAST time until due
-- 4) The Art of War [returned on 2019-06-10 15:12:44]            Third:  Returned,                 ordered by MOST RECENT return time
-- 
-- 5) Exit       (Example: user enters 2 for Game of Thrones book)
--
--
--
--
-- Game of Thrones loaned to [borrower's name] is due in 3 days on 2019-08-18.
-- Please enter a new due date (YYYY-MM-DD), or a number to add that many days:>_       (User enters a date, or an int. The procedure in this file is invoked.)
--
--
--
--
-- Game of Thrones due date changed. New due date: 2019-08-25 (10 days from now).       (UI returns to ADMIN options.)

DROP PROCEDURE IF EXISTS alterLoanSetDueDate;
DELIMITER //
CREATE PROCEDURE alterLoanSetDueDate (IN bookID INT, IN branchID INT, IN cardNo INT, IN newDueDate DATE, OUT daysFromNow INT)
BEGIN
    DECLARE alreadyBorrowed INT;
    
    START TRANSACTION;
    
    -- Check if loan exists.
    SELECT COUNT(1) INTO alreadyBorrowed
        FROM tbl_book_loans bl
        WHERE bl.bookID   = bookID
          AND bl.branchID = branchID
          AND bl.cardNo   = cardNo
          AND bl.returnedDate IS NULL
        FOR UPDATE;
    
    IF alreadyBorrowed IS NOT NULL AND alreadyBorrowed >= 1 THEN
        -- Alter loan.
        UPDATE tbl_book_loans bl
            SET dueDate = newDueDate
            WHERE bl.bookID   = bookID
              AND bl.branchID = branchID
              AND bl.cardNo   = cardNo
              AND bl.returnedDate IS NULL;
        
        -- Compute new days remaining on the loan.
        SET daysFromNow = getDaysUntil(newDueDate);
        
        COMMIT;
        SELECT CONCAT(getBookTitleFromID(bookID), " due date changed.") AS Result, newDueDate AS "New Due Date", daysFromNow AS "Days Until Due";
    ELSE
        ROLLBACK;
        SELECT "Attempted to alter a loan which does not exist." AS Error;
    END IF;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS alterLoanAddDays;
DELIMITER //
CREATE PROCEDURE alterLoanAddDays (IN bookID INT, IN branchID INT, IN cardNo INT, IN daysToAdd INT, OUT newDueDate DATE, OUT daysFromNow INT)
BEGIN
    DECLARE alreadyBorrowed INT;
    
    START TRANSACTION;
    
    -- Check if loan exists.
    SELECT COUNT(1) INTO alreadyBorrowed
        FROM tbl_book_loans bl
        WHERE bl.bookID   = bookID
          AND bl.branchID = branchID
          AND bl.cardNo   = cardNo
          AND bl.returnedDate IS NULL
        FOR UPDATE;
    
    IF alreadyBorrowed IS NOT NULL AND alreadyBorrowed >= 1 THEN
        -- Compute new due date.
        SELECT DATE(DATE_ADD(bl.dueDate, INTERVAL daysToAdd DAY)) INTO newDueDate
            FROM tbl_book_loans bl
            WHERE bl.bookID   = bookID
              AND bl.branchID = branchID
              AND bl.cardNo   = cardNo
              AND bl.returnedDate IS NULL
            FOR UPDATE;
        
        -- Alter loan.
        UPDATE tbl_book_loans bl
            SET dueDate = newDueDate
            WHERE bl.bookID   = bookID
              AND bl.branchID = branchID
              AND bl.cardNo   = cardNo
              AND bl.returnedDate IS NULL;
        
        -- Compute new days remaining on the loan.
        SET daysFromNow = getDaysUntil(newDueDate);
        
        COMMIT;
        SELECT CONCAT(getBookTitleFromID(bookID), " due date changed.") AS Result, newDueDate AS "New Due Date", daysFromNow AS "Days Until Due";
    ELSE
        ROLLBACK;
        SELECT "Attempted to alter a loan which does not exist or has already ended." AS Error;
    END IF;
END; //
DELIMITER ;

-- Author Sayana---------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
--  Update the details of the Library
DELIMITER //
DROP PROCEDURE IF EXISTS updateLibDetails;
CREATE PROCEDURE updateLibDetails(bchId INT, bchName VARCHAR(45), bchAdd VARCHAR(45))
BEGIN
	IF bchName <> 'N/A' THEN 
		UPDATE tbl_library_branch
		SET branchName = bchName
		WHERE bchId = branchId ;    
	END IF;

	IF bchAdd <> 'N/A' THEN 
		UPDATE tbl_library_branch  
		SET branchAddress = bchAdd
		WHERE bchId = branchId ;      
	END IF; 
    
    SELECT branchId, branchName, branchAddress FROM tbl_library_branch WHERE branchId = bchID;
END; //
DELIMITER ;

-- add new borrower by Administrator
DELIMITER //
DROP PROCEDURE IF EXISTS addBorrowerAdmin;
CREATE PROCEDURE addBorrowerAdmin(bwName VARCHAR(45), bwAdd VARCHAR(45), bwPh VARCHAR(45) )
BEGIN
	START TRANSACTION;
		-- borrower has option to not provide address and phone no
		IF bwAdd = 'N/A' then
			SET bwAdd = NULL ;
		END IF;

		IF bwPh = 'N/A' THEN
			SET bwPh =NULL ;
		END IF;

		INSERT INTO tbl_borrower ( name, address, phone)
		VALUES ( bwName , bwAdd , bwPh );
	COMMIT;
    
    SELECT cardNo, name, address, phone FROM tbl_borrower WHERE name = bwName AND address = bwAdd AND phone = bwPh;
END; //
DELIMITER ;

-- update borrower information by Administrator
DELIMITER //
DROP PROCEDURE IF EXISTS updateBorrowerAdmin;
CREATE PROCEDURE updateBorrowerAdmin(cdNo INT, bwName VARCHAR(45), bwAdd VARCHAR(45), bwPh VARCHAR(45) )
BEGIN
	START TRANSACTION;
		IF bwName <> 'N/A' THEN 
			UPDATE tbl_borrower 
			SET name= bwName 
			WHERE cardNo = cdNo;
		END IF;

		IF bwAdd <> 'N/A' THEN 
			UPDATE tbl_borrower 
			SET address=  bwAdd 
			WHERE cardNo = cdNo;
		END IF;

		IF bwPh <> 'N/A' THEN 
			UPDATE tbl_borrower 
			SET  phone= bwPh 
			WHERE cardNo = cdNo;
		END IF;
	COMMIT;

	SELECT cardNo, name, address, phone FROM tbl_borrower WHERE cardNo = cdNo;
END; //
DELIMITER ;

-- delete a record of borrower by admin
DELIMITER //
DROP PROCEDURE IF EXISTS delBwAdmin;
CREATE PROCEDURE delBwAdmin(cdNo INT )
BEGIN
 DECLARE loansCount INT DEFAULT 0;
 
-- checks if there is any loan for that borrower 
	SELECT COUNT(bookId) INTO loansCount
        FROM tbl_book_loans AS bl
        WHERE bl.cardNo = cdNo
		AND bl.returnedDate IS NULL;
	
	IF loansCount> 0 THEN
		SELECT 'This borrower has a book to return before deleting their record.' AS BorrowerStatus;
	ELSE 
		DELETE FROM tbl_borrower 
		WHERE cardNo = cdNo; 
		SELECT 'Delete successful.' AS BorrowerStatus;
	END IF; 
END; //
DELIMITER ;

-- AUTHOR Sayana existing
DELIMITER //
DROP PROCEDURE IF EXISTS addExistingAuthorAdmin;
CREATE PROCEDURE addExistingAuthorAdmin(auId INT, BkId INT)
BEGIN
    START TRANSACTION;
    INSERT INTO tbl_book_authors (authorId, bookId)
    VALUES  (auId, BkId);
    COMMIT;
END; //
DELIMITER ;

-- AUTHOR Sayana
DELIMITER //
DROP PROCEDURE IF EXISTS addExistingGenreAdmin;
CREATE PROCEDURE addExistingGenreAdmin(gId INT, bId INT)
BEGIN
START TRANSACTION;
	INSERT INTO tbl_book_genres (genre_id, bookId)
	VALUES  (gId, bId);
COMMIT;
END; //
DELIMITER ;

-- remove author to a book by Administrator
-- AUTHOR Sayana
DELIMITER //
DROP PROCEDURE IF EXISTS removeExistingAuthorAdmin;
CREATE PROCEDURE removeExistingAuthorAdmin(auId INT, BkId INT)
BEGIN
START TRANSACTION;
	DELETE FROM tbl_book_authors
        WHERE authorId = auId AND bookId = BkId; 
        SELECT 'Delete sucessfull.' AS Status;
COMMIT;
END; //
DELIMITER ;

-- remove genre to a book by Administrator
-- AUTHOR Sayana
DELIMITER //
DROP PROCEDURE IF EXISTS removeExistingGenreAdmin;
CREATE PROCEDURE removeExistingGenreAdmin(gId INT, BkId INT)
BEGIN
START TRANSACTION;
	DELETE FROM tbl_book_genres
        WHERE genre_id = gId AND bookId = BkId; 
        SELECT 'Delete sucessfull.' AS Status;
COMMIT;
END; //
DELIMITER ;

-- add new author by Administrator
DELIMITER //
DROP PROCEDURE IF EXISTS addAuthorAdmin;
CREATE PROCEDURE addAuthorAdmin(auName VARCHAR(45))
BEGIN
	INSERT INTO tbl_author (authorName)
	VALUES  (auName);
    
    SELECT authorId, authorName FROM tbl_author WHERE authorName = auName;
END; //
DELIMITER ;

-- UPDATE Author info
DELIMITER //
DROP PROCEDURE IF EXISTS updateAuAdmin;
CREATE PROCEDURE updateAuAdmin(auId INT, auName VARCHAR(45))
BEGIN
START TRANSACTION;
	IF (auName <> 'N/A') THEN
		UPDATE tbl_author
		SET authorName = auName
		WHERE authorId = auId;
    END IF;
    
    SELECT authorId, authorName FROM tbl_author WHERE authorId = auId;
COMMIT;
END; //
DELIMITER ;

-- delete author by Administrator
DELIMITER //
DROP PROCEDURE IF EXISTS delAuthorAdmin;
CREATE PROCEDURE delAuthorAdmin(auId INT)
BEGIN
DECLARE bookCount INT DEFAULT 0;

-- checks if there is any book in library by that author
   SELECT COUNT(bookId) INTO bookCount
        FROM tbl_book_authors 
        WHERE tbl_book_authors.authorId = auId;
	IF bookCount> 0 THEN
		SELECT 'We still have book from this author. ' AS AuthorStatus;
	ELSE 
		DELETE FROM tbl_author
        WHERE authorId = auId; 
        SELECT 'Delete successful.' AS AuthorStatus;
	END IF; 
END; //
DELIMITER ;

-- Author Janet --------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS addCopies;
CREATE PROCEDURE addCopies(bkId INT, brchID INT, newNoOfCopies INT)
BEGIN
    IF (newNoOfCopies >= 0) THEN
		IF (SELECT EXISTS(SELECT 1 FROM tbl_book_copies WHERE bookID = bkID AND brchID = branchID)) THEN
			UPDATE tbl_book_copies
			SET noOfCopies = newNoOfCopies.
			WHERE bookID = bkID AND branchID = brchID;
		ELSE
			INSERT INTO tbl_book_copies (bookID, branchID, noOfCopies)
			VALUES (bkID, brchID, newNoOfCopies);
		END IF;
	ELSE
		SELECT 'Please enter a non-negative number of copies.' AS Update_Status;
	END IF;
    
    SELECT b.bookId AS ID, b.title AS Title, getBookCopies(b.bookID, brchId) AS Copies FROM tbl_book b WHERE b.bookId = bkID;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS addGenre;
CREATE PROCEDURE addGenre(gName VARCHAR(45))
BEGIN
	INSERT INTO tbl_genre (genre_name)
    VALUES (gName);
    
    SELECT genre_id, genre_name FROM tbl_genre WHERE genre_name = gName;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS updateGenre;
CREATE PROCEDURE updateGenre(gId INT, gName VARCHAR(45))
BEGIN
	START TRANSACTION;
    
    IF (gName <> 'N/A') THEN
		UPDATE tbl_genre
		SET genre_name = gName
		WHERE genre_id = gId;
    END IF;
    
    SELECT genre_id, genre_name FROM tbl_genre WHERE genre_id = gId;
    COMMIT;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS deleteGenre;
CREATE PROCEDURE deleteGenre(gId INT)
BEGIN
	DECLARE bookCount INT DEFAULT 0;

	SELECT COUNT(bookId) INTO bookCount
	FROM tbl_book_genres 
	WHERE genre_id = gId;
   
	IF bookCount> 0 THEN
		SELECT 'Books with this genre are still in the library.' AS GenreStatus;
	ELSE 
		DELETE FROM tbl_genre
        WHERE genre_id = gId; 
        SELECT 'Delete successful.' AS GenreStatus;
	END IF;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS addBranch;
CREATE PROCEDURE addBranch(brchName VARCHAR(45), brchAddress VARCHAR(45))
BEGIN
	INSERT INTO tbl_library_branch (branchName, branchAddress)
    VALUES (brchName, brchAddress);
    
    SELECT branchId, branchName, branchAddress FROM tbl_library_branch WHERE branchName = brchName AND branchAddress = brchAddress;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS updateBranch;
CREATE PROCEDURE updateBranch(brchId INT, brchName VARCHAR(45), brchAddress VARCHAR(45))
BEGIN
	START TRANSACTION;
    
    IF (brchName <> 'N/A') THEN
		UPDATE tbl_library_branch
		SET branchName = brchName
		WHERE branchId = brchId;
	END IF;
    
    IF (brchAddress <> 'N/A') THEN
		UPDATE tbl_library_branch
		SET branchAddress = brchAddress
		WHERE branchId = brchId;
	END IF;
    
    COMMIT;
    
    SELECT branchId, branchName, branchAddress FROM tbl_library_branch WHERE branchId = brchID;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS deleteBranch;
CREATE PROCEDURE deleteBranch(brchId INT)
BEGIN
    START TRANSACTION;
    
    DELETE FROM tbl_library_branch
    WHERE branchId = brchId;
    
    DELETE FROM tbl_book_loans
    WHERE branchId = brchId;
    
    DELETE FROM tbl_book_copies
    WHERE branchId = brchId;
    
    COMMIT;
END; //
DELIMITER ;

-- DONE loading stored procedures







-- 
-- Display table contents, for debug purposes.
-- 

SHOW TABLES;

SELECT * FROM tbl_author;
SELECT * FROM tbl_book;
SELECT * FROM tbl_book_authors;
SELECT * FROM tbl_book_copies;
SELECT * FROM tbl_book_genres;
SELECT * FROM tbl_book_loans;
SELECT * FROM tbl_borrower;
SELECT * FROM tbl_genre;
SELECT * FROM tbl_library_branch;
SELECT * FROM tbl_publisher;
