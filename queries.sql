-- CREATE DATABASE FakeNewsDB;
USE FakeNewsDB;
-- CREATE TABLE Source (
    source_id INT PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    website_url VARCHAR(150),
    credibility_score INT
);
INSERT INTO Source VALUES (1, 'BBC News', 'UK', 'www.bbc.com', 8), (2, 'CNN', 'USA', 'www.cnn.com', 7), (3, 'The Hindu', 'India', 'www.thehindu.com', 9), (4, 'NDTV', 'India', 'www.ndtv.com', 7);
SELECT * FROM Source;
SELECT* FROM News;
SELECT* FROM Category;
SELECT* FROM Verifier;
SELECT* FROM verification;
SELECT country, AVG(credibility_score) AS avg_score FROM Source GROUP BY country;
SELECT Category.category_name, COUNT (*) AS total_news FROM News JOIN Category ON News.category_id = Category.category_id GROUP BY Category.category_name;
SELECT Category.category_name, COUNT(*)AS total_news FROM News JOIN Category ON News.category_id = Category.category_id GROUP BY Category.category_name;
SELECT verifier_id, AVG(confidence_level) AS avg_conf FROM Verification GROUP BY verifier_id;
SELECT news_id FROM News WHERE news_id IN ( SELECT news_id FROM Verification);
SELECT news_id FROM News WHERE news_id NOT IN (SELECT news_id FROM Verification);
SELECT source_id FROM Source WHERE source_id NOT IN ( SELECT source_id FROM News);
SELECT title FROM News WHERE source_id IN (SELECT source_id FROM Source WHERE credibility_score > (SELECT AVG(credibility_score) FROM Source));
SELECT news_id FROM Verification WHERE confidence_level > (SELECT AVG(confidence_level) FROM Verification);
SELECT title FROM News WHERE news_id IN (SELECT news_id FROM Verification WHERE status = 'Fake');
SELECT N.title, S.source_name FROM News N JOIN Source S ON N.source_id = S.source_id;
SELECT N.title, C.category_name FROM News N JOIN Category C ON N.category_id = C.category_id;
SELECT N.title, V.status, VR.verifier_name
FROM News N
JOIN Verification V 
ON N.news_id = V.news_id
JOIN Verifier VR 
ON V.verifier_id = VR.verifier_id;
SELECT * FROM News_Source_View;
SELECT * FROM Fake_News_View;
SELECT * FROM Category_Count_View;
SELECT * FROM Verification WHERE verification_id = 20;
SELECT verification_id, confidence_level 
FROM Verification 
WHERE verification_id = 21;
SELECT verification_id, status 
FROM Verification 
WHERE verification_id = 30;
CALL display_news_titles();
CALL display_fake_news();

CALL display_high_credibility_sources();
SELECT * FROM News_Unnormalized;
SELECT* FROM NEWS;
SELECT* FROM New_news;
CREATE TABLE News_New (
    news_id INT PRIMARY KEY,
    title VARCHAR(100),
    category_id INT
);
INSERT INTO News_New VALUES
(101, 'Election Updates', 1),
(102, 'New Government Policies', 1),
(103, 'New Vaccine Developed', 2),
(104, 'AI Technology Breakthrough', 3),
(105, 'Cricket Team Wins Championship', 4);
SELECT * FROM News_New;
SELECT source_id, source_name, credibility_score FROM Source WHERE source_id IN (2, 3);
SELECT COUNT(*) AS fake_count FROM Verification WHERE status = 'Fake';
SELECT COUNT(*) AS remaining_fake FROM Verification WHERE status = 'Fake';
SELECT COUNT(*) AS restored_fake FROM Verification WHERE status = 'Fake';
SELECT news_id, title FROM News WHERE news_id IN (112, 113);
SELECT verification_id, news_id, status FROM Verification WHERE verification_id IN (32, 33);
SELECT * FROM Verification WHERE news_id = 101 FOR UPDATE;
SELECT * FROM Verification WHERE news_id = 101 FOR UPDATE;