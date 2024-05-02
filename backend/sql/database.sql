create database if not exists library;
use library;

create table if not exists books_info(
book_id int primary key,
book_name varchar(80),
book_author varchar(50),
available_or_not bool,
issued_time time,
expiry_time time,
fine int
);

INSERT INTO books_info (book_id, book_name, book_author, available_or_not, issued_time, expiry_time, fine)
VALUES
    (1, 'The Catcher in the Rye', ' J.D. Salinger',true, NULL, NULL, 0),
    (2, 'To Kill a Mockingbird', "Harper Lee", true, NULL, NULL, 0),
    (3, '1984', 'George Orwell', true, NULL, NULL, 0),
    (4, 'The Great Gatsby', 'F. Scott Fitzgerald', true, NULL, NULL, 0),
    (5, 'Pride and Prejudice', 'Jane Austen', true, NULL, NULL, 0),
    (6, "Harry Potter and the Philosopher's Stone", ' J.K. Rowling', true, NULL, NULL, 0),
    (7, 'The Lord of the Rings', ' J.R.R. Tolkien', true, NULL, NULL, 0),
    (8, 'The Hobbit', 'J.R.R. Tolkien', true, NULL, NULL, 0),
    (9, 'The Da Vinci Code', 'Dan Brown', true, NULL, NULL, 0),
    (10, 'The Hunger Games', 'Suzanne Collins', true, NULL, NULL, 0);


UPDATE books_info 
SET issued_time=current_time() ,
 expiry_time=addtime(current_time(),"0:10:0"),
 available_or_not =false
where book_id=1;
select  fines,book_id,book_name,issued_time,expiry_time,available_or_not from books_info;


