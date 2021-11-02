
SELECT create_graph('reddit_hyperlinks');

CREATE TABLE RedditHyperLinks(source VARCHAR, target VARCHAR, post_id VARCHAR, post_time VARCHAR);


SELECT * FROM cypher('reddit_hyperlinks', $$ CREATE(:subreddit)-[:HYPERLINK]->(:subreddit) $$) as (a agtype);
SELECT * FROM cypher('reddit_hyperlinks', $$ MATCH(n) DETACH DELETE n $$) as (a agtype);

--SELECT create_vlabel('reddit_hyperlinks','subreddit');
--SELECT create_elabel('reddit_hyperlinks','HYPERLINK');

COPY RedditHyperLinks(source, target, post_id, post_time)
FROM '/home/josh/Downloads/soc-redditHyperlinks-title.csv' -- replace this
DELIMITER ','
CSV HEADER;

DELETE FROM RedditHyperLinks 
WHERE RedditHyperLinks.target LIKE '%\_%' OR RedditHyperLinks.target = '%[0-9]%'
OR RedditHyperLinks.source LIKE '%\_%' OR RedditHyperLinks.source = '%[0-9]%';

CREATE INDEX red_src_idx ON RedditHyperLinks (source);
CREATE INDEX red_target_idx ON RedditHyperLinks (target);

ALTER TABLE RedditHyperLinks ADD COLUMN target_gid graphid;
ALTER TABLE RedditHyperLinks ADD COLUMN source_gid graphid;


CREATE TABLE subreddit_gids (subreddit VARCHAR, gid graphid);

CREATE UNIQUE INDEX sub_idx ON subreddit_gids (subreddit);

SELECT nextval('reddit_hyperlinks.subreddit_id_seq') ;

INSERT INTO subreddit_gids
SELECT 
	subreddit,
	ag_catalog._graphid(
		(ag_catalog._label_id('reddit_hyperlinks'::name, 'subreddit'::name))::integer, 
		currval('reddit_hyperlinks.subreddit_id_seq') + RANK() OVER (ORDER BY subreddit)
	) as gid		
FROM (
	SELECT source as subreddit 
	FROM RedditHyperLinks 
	UNION 
	SELECT target 
	FROM RedditHyperLinks
) as a;

SET enable_hashjoin = TRUE;
SET enable_nestloop = FALSE;

UPDATE RedditHyperLinks
SET source_gid = (
	SELECT gids.gid
	FROM subreddit_gids AS gids
	WHERE gids.subreddit = RedditHyperLinks.source
);

UPDATE RedditHyperLinks
SET target_gid = (
	SELECT gids.gid
	FROM subreddit_gids AS gids
	WHERE gids.subreddit = RedditHyperLinks.target
);


SELECT nextval('reddit_hyperlinks."HYPERLINK_id_seq"') ;

INSERT INTO reddit_hyperlinks.subreddit
SELECT gid, agtype_build_map('name', subreddit)::agtype FROM subreddit_gids;

INSERT INTO reddit_hyperlinks."HYPERLINK"
SELECT 
	ag_catalog._graphid(
		(ag_catalog._label_id('reddit_hyperlinks'::name, 'HYPERLINK'::name))::integer, 
		currval('reddit_hyperlinks."HYPERLINK_id_seq"') + ROW_NUMBER() OVER (ORDER BY post_id)
	) as gid,
source_gid, 
target_gid, 
agtype_build_map('post_id', CONCAT('"', post_id, '"'), 'post_date', CONCAT('"', post_time, '"'))::agtype FROM RedditHyperLinks;

SELECT setval('reddit_hyperlinks.subreddit_id_seq', currval('reddit_hyperlinks.subreddit_id_seq') + (SELECT count(*) FROM subreddit_gids));

SELECT setval('reddit_hyperlinks."HYPERLINK_id_seq"', currval('reddit_hyperlinks."HYPERLINK_id_seq"') + (SELECT count(*) FROM RedditHyperLinks));


SELECT count(*) FROM cypher('reddit_hyperlinks', $$ MATCH (n) RETURN n$$) as (a agtype);
SELECT count(*) FROM cypher('reddit_hyperlinks', $$ MATCH (n)-[e]->(m) RETURN e$$) as (a agtype);
SELECT count(*) FROM cypher('reddit_hyperlinks', $$ MATCH (n)-[e*]->(m) RETURN e$$) as (a agtype);
