--LET'S DO ANALYSIS AND FIGURE OUT WHAT WE CAN INTERPRET FROM THIS DATASET USING SQL 

--REVIEW THE DATASET TO UNDERSTAND TABLE VALUES 
SELECT * FROM social_media LIMIT 5;
--AFTER REVIEW THE DATASET GENDER COLUMN CONTAINS SAME VALUES WITH DIFFERENT FORMATS SO, LET'S MAKE THEM ONE

UPDATE social_media
SET Gender = CASE
    WHEN Gender IN ('Non binary ', 'Non-Binary', 'Nonbinary ') THEN 'Non-Binary'
	ELSE Gender
END;

--Age, Gender, Relationship Status, Occupation Status: Demographics.

--Demographic Insights:
	--WHAT ARE THE TOTAL NUMBER OF USERS AND THEIR AVERAGE AGE?
		--BY AGE & GENDER:
		  SELECT 
			gender,COUNT(*) as TOTAL_USERS,
			FLOOR(AVG(what_is_your_age)) as AVERAGE_AGE
				FROM social_media
				GROUP BY gender
				ORDER BY 1;
					
		--BY RELATIONSHIP STATUS
		 SELECT 
		 	relationship_status,COUNT(*) as NUMBER_OF_USERS,
			FLOOR(AVG(what_is_your_age)) as AVERAGE_AGE
			 	FROM social_media
				GROUP BY relationship_status
				ORDER BY 2 DESC;
				
		--OCCUPATION STATUS
		SELECT 
		 	occupation_status,COUNT(*) as NUMBER_OF_USERS,
			FLOOR(AVG(what_is_your_age)) as AVERAGE_AGE
			 	FROM social_media
				GROUP BY occupation_status
				ORDER BY 2 DESC;
				
--Social Media Usage Patterns:
--Explore how much time users spend on social media
--what platforms they prefer, and whether they use social media without a specific reason.
SELECT 
	What_is_the_average_time_you_spend_on_social_media_every_day 
		as AVERAGE_TIME_SPENT_ON_SOCIAL_MEDIA,
			COUNT(*) as NUMBER_OF_USERS
			FROM social_media
			GROUP BY 1
			ORDER BY 2 DESC;
			
--WHICH PLATFORM IS MOSTLY USED BY USERS
-- TO KNOW THIS FIRST WE NEED TO EXTRACT ALL DIFFERENT PLATFORMS FROM LIST
SELECT  DISTINCT What_social_media_platforms_do_you_commonly_use FROM social_media; --AFTER RUNNING THIS YOU WILL KNOW WHAT I WANT TO TELL YOU

---------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE A NEW TABLE FOR DISTINCT PLATFORMS AND ADD NEW COLUMN FOR EACH DISTINCT VALUES OF What_social_media_platforms_do_you_commonly_use
DROP TABLE IF EXISTS platforms;

CREATE TABLE platforms as 

SELECT What_social_media_platforms_do_you_commonly_use,
	
      CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Facebook%' THEN 'FACEBOOK' ELSE 'NOT A FACEBOOK USER' END as Facebook_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Instagram%' THEN 'INSTAGRAM' ELSE 'NOT A INSTAGRAM USER' END as Instagram_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%YouTube%' THEN 'YOUTUBE' ELSE 'NOT A YOUTUBE USER' END as Youtube_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Twitter%' THEN 'TWITTER' ELSE 'NOT A TWITTER USER' END as Twitter_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Snapchat%' THEN 'SANPCHAT' ELSE 'NOT A SNAPCHAT USER' END as Snapchat_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Pinterest%' THEN 'PINTEREST' ELSE 'NOT A PINTEREST USER' END as Pinterest_user,
   	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Reddit%' THEN 'REDDIT' ELSE 'NOT A REDDIT USER' END as Reddit_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%Discord%' THEN 'DISCORD' ELSE 'NOT A DISCORD USER' END as Discord_user,
	  CASE WHEN What_social_media_platforms_do_you_commonly_use LIKE '%TikTok%' THEN 'TIKTOK' ELSE 'NOT A TIKTOK USER' END as Tiktok_user

FROM social_media;
---------------------------------------------------------------------------------------------------------------------------------------------------
--WHICH INDIVISUAL PLATFORM IS MOSTLY USED BY USERS
SELECT 
		SUM(CASE WHEN Facebook_user  LIKE 'FACEBOOK' THEN 1 ELSE 0 END) as FACEBOOK_USER,
		SUM(CASE WHEN Instagram_user LIKE 'INSTAGRAM' THEN 1 ELSE 0 END) as INSTAGRAM_USER,
		SUM(CASE WHEN Youtube_user   LIKE 'YOUTUBE' THEN 1 ELSE 0 END) as YOUTUBE_USER,
		SUM(CASE WHEN Twitter_user   LIKE 'TWITTER' THEN 1 ELSE 0 END) as TWITTER_USER,
		SUM(CASE WHEN Snapchat_user  LIKE 'SANPCHAT' THEN 1 ELSE 0 END) as SANPCHAT_USER,
		SUM(CASE WHEN Pinterest_user LIKE 'PINTEREST' THEN 1 ELSE 0 END) as PINTEREST_USER,
		SUM(CASE WHEN Reddit_user    LIKE 'REDDIT' THEN 1 ELSE 0 END) as REDDIT_USER,
		SUM(CASE WHEN Discord_user   LIKE 'DISCORD' THEN 1 ELSE 0 END) as DISCORD_USER,
		SUM(CASE WHEN Tiktok_user    LIKE 'TIKTOK' THEN 1 ELSE 0 END) as TIKTOK_USER
FROM platforms;
---------------------------------------------------------------------------------------------------------------------------------------------------
--what platforms they prefer, and whether they use social media without a specific reason.
SELECT 
	What_social_media_platforms_do_you_commonly_use as SOCIAL_MEDIA_PLATFORMS,
	what_is_the_average_time_you_spend_on_social_media_every_day as AVERAGE_TIME_SPENT_ON_SOCIAL_MEDIA,
	do_you_find_yourself_using_social_media_without_reason as USING_WITHOUT_ANY_REASON,
	COUNT(*) as NUMBER_OF_USERS
		FROM social_media
		GROUP BY 1,2,3
		ORDER BY 4 DESC;		
---------------------------------------------------------------------------------------------------------------------------------------------------
--Time Spent on Social Media vs. Mental Health:
	--CATGEORIES THE AVERAGE TIME SPENT INTO LOW USUAGE,HIGH USUAGE,MEDIUM USUAGE
	--USE THIS CATEGORRY TO UNDERSTAND MENTAL HEALTH IMPACT LIKE DEPRESSED,SLEEP REGRADING PROBLEM,DAILY ACTIVITIES FLUCTUATION

DROP VIEW IF EXISTS social_media_usage_vs_mental_health;

CREATE VIEW social_media_usage_vs_mental_health
	as
		SELECT 
		  what_is_your_age,
		  occupation_status,
		  relationship_status,
		  gender,
		  
				CASE WHEN 
						What_is_the_average_time_you_spend_on_social_media_every_day='More than 5 hours'
						 OR
						What_is_the_average_time_you_spend_on_social_media_every_day='Between 4 and 5 hours'
				     THEN 'HIGH USAGE' 
					 WHEN
					 	What_is_the_average_time_you_spend_on_social_media_every_day='Between 3 and 4 hours'
						 OR
						What_is_the_average_time_you_spend_on_social_media_every_day='Between 2 and 3 hours'
					 THEN 'MEDIUM USAGE' 
					 WHEN
					 	What_is_the_average_time_you_spend_on_social_media_every_day='Between 1 and 2 hours'
						 OR
						What_is_the_average_time_you_spend_on_social_media_every_day='Less than an Hour'
					 THEN 'LOW USAGE'
					 ELSE 'UNKNOWN'
				END AS USAGE_CATEGORY,
			How_often_do_you_feel_depressed_or_down,
			How_often_do_you_face_issues_regarding_sleep,
			How_frequently_does_your_interest_in_daily_activities_fluctuate,
			Do_you_find_it_difficult_to_concentrate_on_things,
			Do_you_get_distracted_by_Social_media_when_you_are_busy	

FROM social_media;

--USERS WITH FEELING DEPRESSION
SELECT usage_category,How_often_do_you_feel_depressed_or_down,
	COUNT(*) as NUMBER_OF_USERS_FEELING_DEPRESSED_BY_USUAGE_CATEGORY
		FROM  social_media_usage_vs_mental_health
		GROUP BY 1,2
		ORDER BY 1,3 DESC;
		
--USERS FACING SLEEP REGRADING PROBLEM
SELECT usage_category,How_often_do_you_face_issues_regarding_sleep,
	COUNT(*) as NUMBER_OF_USERS_FACE_PROBLEM_REGRADING_SLEEP_BY_USUAGE_CATEGORY
		FROM social_media_usage_vs_mental_health
		GROUP BY 1,2
		ORDER BY 1,3 DESC;
		
--MOOD SWINGS DUE TO USAGE OF SOCIAL MEDIA 

SELECT usage_category,How_frequently_does_your_interest_in_daily_activities_fluctuate,
	COUNT(*) as NUMBER_OF_USERS_WITH_MOOD_SWINGS_PROBLEM_BY_USUAGE_CATEGORY
		FROM social_media_usage_vs_mental_health
		GROUP BY 1,2
		ORDER BY 1,3 DESC;

--USER LOSSING THEIR CONCENTRATION DUE TO SOCIAL MEDIA USUAGE
SELECT 
	usage_category,
	Do_you_find_it_difficult_to_concentrate_on_things,
	Do_you_get_distracted_by_Social_media_when_you_are_busy,
		COUNT(*) as NUMBER_OF_USERS_WITH_CONCENTRATION_PROBLEM_BY_USUAGE_CATEGORY
			FROM social_media_usage_vs_mental_health
			GROUP BY 1,2,3
			ORDER BY 1,4 DESC;

--MENTAL HEALTH PROBLEM BY AGE 
--CREATING A BUCKET AGE GROUP OF 12-18,19-25,26-35,35+ THEN FINDING USERS WITH MENTAL HEALTH PROBLEM IN THESE GROUPS
SELECT 
	CASE
		WHEN what_is_your_age BETWEEN 12 AND 18 THEN '12-18'
		WHEN what_is_your_age BETWEEN 19 AND 25 THEN '19-25'
		WHEN what_is_your_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN what_is_your_age BETWEEN 36 AND 100 THEN '36+'
	ELSE 'OUT OF RANGE'
 END as  AGE_GROUP,
		do_you_get_distracted_by_social_media_when_you_are_busy,
		how_often_do_you_feel_depressed_or_down,
		COUNT(*) NUMBER_OF_USER_GETTING_DISTRACTED_AND_FEELING_DEPRESION
FROM social_media
GROUP BY 1,2,3
ORDER BY 2 DESC,3 DESC,4 DESC;

--LET'S FIND OUT NUMBER OF USER WHOSE AGE IS BETWEEN 12-18 AND HOW MUCH THEY COMPARE THEM SELF WITH INFLUNCERS
SELECT 
		what_is_your_age,
		how_often_do_you_compare_yourself_to_other_successful_people,
		COUNT(*) NUMBER_OF_USER
	FROM social_media 
	WHERE what_is_your_age BETWEEN 12 AND 18
	GROUP BY 1,2
	ORDER BY 2 DESC,3 DESC;

--FINDING NUMBER OF USERS OF AGE GROUP WHICH FACE DISTRACTION WHEN THEY ARE BUSY AND HAVING MOOD SWINGS.
SELECT *
FROM (
    SELECT 
        AGE_GROUP,
        MOOD_SWING_LEVEL,
		DISTRACTION_LEVEL_WHEN_BUSY,
        NUMBER_OF_USERS,
        RANK() OVER (PARTITION BY AGE_GROUP ORDER BY NUMBER_OF_USERS DESC) AS rank
    FROM (
        SELECT 
            CASE
                WHEN what_is_your_age BETWEEN 12 AND 18 THEN '12-18'
                WHEN what_is_your_age BETWEEN 19 AND 25 THEN '19-25'
                WHEN what_is_your_age BETWEEN 26 AND 35 THEN '26-35'
                WHEN what_is_your_age BETWEEN 36 AND 100 THEN '36+'
                ELSE 'OUT OF RANGE'
            END AS AGE_GROUP,
            how_frequently_does_your_interest_in_daily_activities_fluctuate as MOOD_SWING_LEVEL,
			do_you_get_distracted_by_social_media_when_you_are_busy as DISTRACTION_LEVEL_WHEN_BUSY,
            COUNT(*) AS NUMBER_OF_USERS
        FROM social_media
        GROUP BY 1, 2,3
    ) AS age_grouped_data
) AS ranked_data
WHERE rank =1
ORDER BY AGE_GROUP;

--FINDING NUMBER OF USERS BY RELATIONSHIP STATUS WHICH FACE MENTAL HEALTH PROBLEM IN THEIR LIFE

SELECT relationship_status,
do_you_find_yourself_using_social_media_without_reason as social_media_addiction_level,
what_is_the_average_time_you_spend_on_social_media_every_day as AVERAGE_TIME_SPENT_ON_SOCIAL_MEDIA,
count(*) as NUMBER_OF_USERS
FROM social_media
GROUP BY 1,2,3
ORDER BY 2 desc,4 desc;

--FINDING THOSE RELATIONSHIP STATUS THOSE ARE ADDICITED TO SOCIAL MEDIA AND HAVING DEPRESSION AND FEELING RESTLESS WHEY THEY DONT USE SOCIAL MEDIA 

SELECT 
		relationship_status,
		do_you_find_yourself_using_social_media_without_reason as social_media_addiction_level,
		do_you_feel_restless_if_you_havent_used_social_media as FEELING_RESTLESS_WITHOUT_SOCIAL_MEDIA,
		how_often_do_you_feel_depressed_or_down as DEPRESSION_LEVEL,
		count(*) as NUMBER_OF_USER
			FROM social_media
				WHERE 
					do_you_find_yourself_using_social_media_without_reason IN (4,5)
					AND 
					do_you_feel_restless_if_you_havent_used_social_media in(4,5)
			GROUP BY 1,2,3,4
			ORDER BY 2 desc,3 DESC,4 desc,5 DESC;
			
--FINDING THOSE RELATION WHICH COMPARE THEMSELF WITH OTHER SOCIAL MEDIA INFLUNCERS
SELECT 
		relationship_status,
		how_often_do_you_compare_yourself_to_other_successful_people as COMPARISON_WITH_SOCIAL_MEDIA_INFLUNCERS,
		COUNT(*) as NUMBER_OF_USERS
	FROM social_media
	GROUP BY 1,2
	ORDER BY 2 DESC,3 DESC;

--FINDING THOSE REALTION AND THEIR AGE WHO ARE SEEKED TO VALIDATION OF NEW FEATURES
SELECT 
		relationship_status,
		CASE
                WHEN what_is_your_age BETWEEN 12 AND 18 THEN '12-18'
                WHEN what_is_your_age BETWEEN 19 AND 25 THEN '19-25'
                WHEN what_is_your_age BETWEEN 26 AND 35 THEN '26-35'
                WHEN what_is_your_age BETWEEN 36 AND 100 THEN '36+'
                ELSE 'OUT OF RANGE'
            END AS AGE_GROUP,
		do_you_look_to_seek_validation_for_features_of_social_media as EXICITED_FOR_NEW_FEATURES,
		COUNT(*) as NUMBER_OF_USERS
	FROM social_media
		WHERE do_you_look_to_seek_validation_for_features_of_social_media IN (4,5)
	GROUP BY 1,2,3
	ORDER BY 3 DESC, 4 DESC;

--BY OCCUPATION STATUS
--FINDING OCCUPATION THOSE ARE ENGAGE WITH SOCIAL MEDIA AND WHAT TYPE OF SOCIAL MEDIA BY THEIR AGE GROUP
SELECT 
				s.occupation_status,
				CASE
		                WHEN what_is_your_age BETWEEN 12 AND 18 THEN '12-18'
		                WHEN what_is_your_age BETWEEN 19 AND 25 THEN '19-25'
		                WHEN what_is_your_age BETWEEN 26 AND 35 THEN '26-35'
		                WHEN what_is_your_age BETWEEN 36 AND 100 THEN '36+'
		                ELSE 'OUT OF RANGE'
		        END AS AGE_GROUP,
				s.what_type_of_organizations_are_you_affiliated_with,
				p.facebook_user,p.instagram_user,p.youtube_user,p.twitter_user,p.snapchat_user,p.pinterest_user,p.reddit_user,p.discord_user,p.tiktok_user,
				COUNT(*) as NUMBER_OF_USERS
		FROM social_media s
			JOIN platforms P 
				ON s.what_social_media_platforms_do_you_commonly_use=p.what_social_media_platforms_do_you_commonly_use
					WHERE do_you_use_social_media='Yes'
					GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
					ORDER BY NUMBER_OF_USERS DESC;

--FINDING THOSE OCCUPATION WHO FACES MENTAL HEALTH PROBLEM DUE TO  HEAVY SOCIAL MEDIA USAGE 
--FEELING DEPRESSED BY OCCUPATION
SELECT 
		occupation_status,
		gender,
		usage_category as SOCIAL_MEDIA_USAGE,
		how_often_do_you_feel_depressed_or_down as FEELING_DEPRESSED,
		COUNT(*) as NUMBER_OF_USERS
	FROM social_media_usage_vs_mental_health
	
GROUP BY 1,2,3,4
ORDER BY NUMBER_OF_USERS DESC ;

--FEELING MOOD SWINGS DUE TO USAGE OF SOCIAL MEDIA IN DIFFERENT OCCUPATION STATUS
SELECT 
		occupation_status,
		usage_category,
		how_frequently_does_your_interest_in_daily_activities_fluctuate as MOOD_SWINGS,
		do_you_get_distracted_by_social_media_when_you_are_busy as DISTRACTION_FROM_DAILY_WORK,
		COUNT(*) as NUMBER_OF_USERS
	FROM social_media_usage_vs_mental_health
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--OCCUPATION THOSE FIND THEMSELF DIFFICULT TO CONCENTRATE ON THINGS AND FACING SLEEP REGRADING PROBLEM

SELECT 
		occupation_status,
		usage_category,
		do_you_find_it_difficult_to_concentrate_on_things as DIFFICULTY_TO_CONCENTRATE		,
		how_often_do_you_face_issues_regarding_sleep as SLEEP_REGRADING_PROBLEM,
		COUNT(*) as NUMBER_OF_USERS
	FROM social_media_usage_vs_mental_health
GROUP BY 1,2,3,4
ORDER BY 5 DESC;



