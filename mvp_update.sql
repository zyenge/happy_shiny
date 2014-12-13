/*
SELECT @rownum:=@rownum+1 as `row_number`, email, d.Q1
  FROM test.mvp d,  (SELECT @rownum:=0) r
  WHERE 1
  -- put some where clause here
group by email
*/

delete * from test.mvp_temp;
#alter table test.mvp_temp, delete column date_time
# insert csv to mvp_temp
# alter table test.mvp_temp, add date_time
update test.mvp_temp
set date_time=timestamp(date_sh, time_SH) where Zone='CN';
update test.mvp_temp
set date_time=date_add(timestamp(date_sh, time_SH),interval -13 hour) where Zone='DC';
update test.mvp_temp
set date_time=date_add(timestamp(date_sh, time_SH),interval -16 hour) where Zone='CA';
#check hour
select hour ( date_time), a.* from test.mvp_temp a
;

#add column Z_Q1
insert into test.mvp
(select * from test.mvp_temp);


update test.mvp  t2
inner join
(select a.id, (a.Q1 -AVG_Q1) / STD_Q1 as Z_Q1
from test.mvp a join (
SELECT email, avg(Q1) as AVG_Q1 , std(Q1) as STD_Q1, count(*) as cnt 
FROM test.mvp
group by  email
having cnt>=5
) b
on a.email=b.email) t1
on t2.id=t1.id
set t2.Z_Q1=t1.Z_Q1
;


## encrpt users
ALTER TABLE `test`.`mvp` 
ADD COLUMN `code` INT NULL AFTER `email`;
update test.mvp a
inner join 
(select email, rand()*100000 as cd from test.mvp group by email) as b
on a.email=b.email
set a.code=b.cd


# to get Yes/no/not sure and avg(Z_Q1)
SELECT
      /*   case when hour(date_time)<12 then 'morning'
         when hour(date_time) between 12 and 18 then 'afternoon'
   when hour(date_time)>18 then 'evening'  end as period,   */     
         Q4.name  "Prefer to do something else?",
    #Q3.name "Primary Activity",
         count(distinct email) as count_distinct,
    count(*) as count,
         avg(Z_Q1) as avg_Q1,
          std(Z_Q1) as std_Q1
 
FROM
         test.mvp m
join
         Q2
on
   m.Q2 = Q2.id
join
         Q3
on
   m.Q3_P = Q3.id
join
         Q4
on
         m.Q4 = Q4.id
where
         m.code !=4060 and m.email not in (SELECT distinct(email) FROM test.mvp where Z_Q1 is null) 
group by
         1
having count>5
#and period='afternoon' 
order by
         count(*) desc




# get morning,afternoon, evening
SELECT  email,
case when hour(date_time)<12 then 'morning' 
	when hour(date_time) between 12 and 18 then 'afternoon'
   when hour(date_time)>18 then 'evening'  end as period,	
avg(Q1) avg_Q1
FROM test.mvp group by 1,2

#happiness sensitivity
SELECT email, count(*) cnt, std(Q1) sd FROM test.mvp  group by 1 having cnt >=5  order by sd desc



--update: problem with coding:
SELECT * FROM test.mvp_exported where act='Other' and Q3_other is null;
/*
update test.mvp_exported
set Q3_other=Q2_other
where act='Other' and Q3_other is null
*/

insert into test.q2
select 8,"Friends/Family's House"



update test.mvp_exported
set location="Friends/Family's House"
 where location ='other' and Q2_Other like '%house%'

---export csv
## 


use test;
create table test.mvp_exported as (
SELECT code, 
 case when hour(date_time)<12 then 'morning' 
  when hour(date_time) between 12 and 18 then 'afternoon'
   when hour(date_time)>18 then 'evening'  end as period,
 hour(date_time) hr,
 date_time, 
dayname(date(date_time)) week_day, Q1, Z_Q1, Q2.name location, Q3.name act, Q3.category category, S.name as act_2nd, Q4.name perfer_not, Q2_Other,Q3_Other
 FROM test.mvp m 
join 
         Q2
on
   m.Q2 = Q2.id
join
         Q3
on
   m.Q3_P = Q3.id
left join
         Q3 as S
on
   m.Q3_S = S.id
join
         Q4
on
         m.Q4 = Q4.id

)



