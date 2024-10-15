--CREATING MENTAL HEALTH SOCIAL MEDIA SCHEMA 
-- NOTE::
-- SOME COLUMNS ANSWER ARE GIVEN IN INTEGER FORMAT BETWEEN 0-5 
-- WHICH INDICATES THAT IF IT CONTAINS 5 VALUES IT'S MEAN STRONGLY AGREED AND 0 MEANS NOT AGREED 


CREATE TABLE social_media(
	Serial_Number INT,
	PRIMARY KEY(Serial_Number),
	Timestamp TIMESTAMP,
	What_is_your_age INT,
	Gender VARCHAR(10),
	Relationship_Status VARCHAR(20),
	Occupation_Status VARCHAR(30),
	What_type_of_organizations_are_you_affiliated_with VARCHAR(50),
	Do_you_use_social_media VARCHAR(8),
	What_social_media_platforms_do_you_commonly_use VARCHAR(250),
	What_is_the_average_time_you_spend_on_social_media_every_day VARCHAR(80),
	Do_you_find_yourself_using_Social_media_without_reason INT,
	Do_you_get_distracted_by_Social_media_when_you_are_busy INT,
	Do_you_feel_restless_if_you_havent_used_Social_media INT,
	How_easily_distracted_are_you INT,
	How_much_are_you_bothered_by_worries INT,
	Do_you_find_it_difficult_to_concentrate_on_things INT,
	How_often_do_you_compare_yourself_to_other_successful_people INT,
	How_do_you_feel_about_these_comparisons_generally_speaking INT,
	Do_you_look_to_seek_validation_for_features_of_social_media INT,
	How_often_do_you_feel_depressed_or_down INT,
	How_frequently_does_your_interest_in_daily_activities_fluctuate INT,
	How_often_do_you_face_issues_regarding_sleep INT
);
--DURING INSERTION I FOUND SIZE OF GENDER IS LESS THAN VALUE IT CONTAIN  SO I INCREASE
--YOU CAN CHANGE DIRECTLY SIZE DURING CREATION OF TABLE 
ALTER TABLE social_media 
ALTER COLUMN Gender TYPE VARCHAR(30);