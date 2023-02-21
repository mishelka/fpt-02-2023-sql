DROP TABLE IF EXISTS links;
CREATE TABLE links(
    link_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(20) NOT NULL,
    url VARCHAR(50) NOT NULL,
    last_update TIMESTAMP
);

INSERT INTO links(name, url)
VALUES
    ('Google', 'http://www.google.com'),
    ('Wikipedia', 'http://www.wikipedia.com'),
    ('Facebook', 'http://www.facebook.com'),
    ('Instagram', 'http://www.instagram.com'),
    ('Twitter', 'http://www.twitter.com');

UPDATE links
    SET
        last_update = '2020-08-01',
        url = 'https://www.facebook.com'
WHERE link_id = 3;

DELETE FROM links
WHERE name LIKE '%w%';