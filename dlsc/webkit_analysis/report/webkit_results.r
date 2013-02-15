DB_USER="root"
DB_PASS="root"

WEBKIT_CVSA_DB="webkit_cvsa"
WEBKIT_DEV_MLS_DB="webkit_dev_mls"
WEBKIT_BUG_MLS_DB="webkit_bug_mls"
WEBKIT_GUILTY_DB="webkit_guilty"

library(RMySQL)
library(xtable)
library(ineq)

con = dbConnect(MySQL(), user=DB_USER, pass=DB_PASS, db=WEBKIT_CVSA_DB)

commitCountQuery="SELECT COUNT(s.id) 
FROM scmlog s"
commitCount=dbGetQuery(con,commitCountQuery)
colnames(commitCount)=c("Commit count")
print(xtable(commitCount, caption="Number of commits to the repository", display=c("d","d")),type="latex",file="report/tables/commitCount.tex")

committerCountQuery="SELECT COUNT(DISTINCT s.committer_id) 
FROM scmlog s"
committerCount=dbGetQuery(con, committerCountQuery)
colnames(committerCount)=c("Committers count")
print(xtable(committerCount, caption="Number of people committing to the repository", display=c("d","d")), type="latex", file="report/tables/committerCount.tex")

filesCountQuery="SELECT COUNT(DISTINCT a.file_id) 
FROM actions a"
filesCount=dbGetQuery(con, filesCountQuery)
colnames(filesCount)=c("Files count")
print(xtable(filesCount, caption="Number of files under version control", display=c("d","d")), type="latex", file="report/tables/filesCount.tex")

top20CommitsByCommitterQuery="SELECT people.name, COUNT(*) AS commit_count 
FROM people LEFT JOIN scmlog ON ( people.id = scmlog.committer_id ) 
GROUP BY scmlog.committer_id 
ORDER BY commit_count 
DESC LIMIT 20"
top20CommitsByCommitter=dbGetQuery(con, top20CommitsByCommitterQuery)
colnames(top20CommitsByCommitter)=c("Committer", "Commit count")
print(xtable(top20CommitsByCommitter, caption="Top 20 committers. Multiple accounts ignored", display=c("d","s","d"), label=c("commits:top20")), type="latex", file="report/tables/top20CommitsByCommitter.tex")

commitsByCommitter2009Query="SELECT people.name, COUNT(*) AS commit_count 
FROM people LEFT JOIN scmlog ON ( people.id = scmlog.committer_id ) 
WHERE year(scmlog.date)=2009 
GROUP BY scmlog.committer_id 
ORDER BY commit_count 
DESC LIMIT 20"
commitsByCommitter2009=dbGetQuery(con, commitsByCommitter2009Query)
colnames(commitsByCommitter2009)=c("Committer","Commit count")
print(xtable(commitsByCommitter2009, caption="Top 20 committers during 2009", display=c("d","s","d"), label=c("commits:2009top20")), type="latex", file="report/tables/commitsByCommitter2009.tex")

repositoryLifeSpanQuery="SELECT YEAR(MIN(date)), YEAR(MAX(date)), 
	YEAR(MAX(date))-YEAR(MIN(date))
FROM scmlog"
repositoryLifeSpan=dbGetQuery(con, repositoryLifeSpanQuery)
colnames(repositoryLifeSpan)=c("First commit", "Last commit","Years")
print(xtable(repositoryLifeSpan, caption="Repository lifespan", display=c("d", "s", "s", "d")), type="latex", file="report/tables/repositoryLifeSpan.tex") 

commitsByCommitterGroupedQuery="SELECT SUBSTRING_INDEX(p.name,'@',1) AS username, 
COUNT(*) AS count 
FROM people p LEFT JOIN scmlog ON (p.id = scmlog.committer_id)
GROUP BY username 
ORDER BY count DESC
LIMIT 20;"
commitsByCommitterGrouped=dbGetQuery(con, commitsByCommitterGroupedQuery)
colnames(commitsByCommitterGrouped) = c("Committer", "Commit count")
print(xtable(commitsByCommitterGrouped, caption="Top 20 committers. Multiple accounts grouped", display=c("d", "s", "d"), label=c("commits:top20grouped")), type="latex", file="report/tables/commitsByCommitterGrouped.tex")

commitsByMonthQuery="SELECT YEAR(date) AS year, MONTH(date) AS month, COUNT(*) AS count 
FROM scmlog
GROUP BY year, month"
commitsByMonth=dbGetQuery(con, commitsByMonthQuery)
commitsByMonth_ts=ts(commitsByMonth[,3],start=c(2001,8),freq=12)
pdf("report/images/commitsByMonth.pdf")
plot(stl(commitsByMonth_ts, "periodic"))
title("Temporal analysis of monthly activity on the repository")
dev.off()

averageMonthlyCommitsByYearQuery="SELECT g.year, AVG(g.numcommits) 
FROM 
	(SELECT YEAR(date) AS year, MONTH(date) AS month, 
	COUNT(id) AS numcommits 
	FROM scmlog 
	GROUP BY year, month) g
GROUP BY g.year"
averageMonthlyCommitsByYear=dbGetQuery(con, averageMonthlyCommitsByYearQuery)
colnames(averageMonthlyCommitsByYear) = c("Year", "Average commits per month")
print(xtable(averageMonthlyCommitsByYear, caption="Evolution of average commits per month", display = c("d", "d","d")), type = "latex", file = "report/tables/averageMonthlyCommitsByYear.tex")

individualCommitsAfterNovember2007Query="SELECT p.name, MIN(date), MAX(date), COUNT(*) AS commits
FROM people p LEFT JOIN scmlog l ON (p.id = l.committer_id) 
WHERE date >= DATE('2007-11-1') 
AND p.name NOT LIKE '%@%' 
GROUP BY p.name 
ORDER BY commits desc"
individualCommitsAfterNovember2007=dbGetQuery(con, individualCommitsAfterNovember2007Query)
colnames(individualCommitsAfterNovember2007)=c("Committer","First contribution","Last contribution", "Commit count")
print(xtable(individualCommitsAfterNovember2007, caption="Commits without providing an email address after November, 2007", display=c("d","s", "s", "s", "d"), label=c("commits:november")), type = "latex", file ="report/tables/individualCommitsAfterNovember2007.tex")

commitsByCompanyQuery="SELECT SUBSTRING_INDEX(people.name,'@',-1) AS company, 
	MIN(date), MAX(date), COUNT(*) AS commits 
FROM people LEFT JOIN scmlog ON (people.id = scmlog.committer_id) 
WHERE people.name LIKE '%@%' 
GROUP BY company 
ORDER BY commits DESC"
commitsByCompany=dbGetQuery(con, commitsByCompanyQuery)
colnames(commitsByCompany)=c("Company", "First contribution", "Last contribution", "Commit count")
print(xtable(commitsByCompany, caption="Number of commits by the company an user is affiliated to", display=c("d","s","s","s","d"), label=c("commits:company")), type="latex", file="report/tables/commitsByCompany.tex")

commitsByDayQuery="SELECT YEAR(date) AS year, DAYOFWEEK(date) AS day, COUNT(*) AS COMMITS 
FROM scmlog 
WHERE YEAR(date) < 2010
GROUP BY year, day"
commitsByDay=dbGetQuery(con, commitsByDayQuery)
commitsByDay_ts=ts(commitsByDay[,3],start=2001, freq=7)
pdf("report/images/commitsByDay.pdf")
plot(stl(commitsByDay_ts,"periodic"))
title("Temporal analysis of weekly activity on the repository")
dev.off()

commitsByHourQuery="SELECT YEAR(date) as year, HOUR(date) as hour, COUNT(*) AS commits
FROM scmlog 
WHERE YEAR(date) < 2010
GROUP BY year, hour"
commitsByHour=dbGetQuery(con, commitsByHourQuery)
commitsByHour_ts=ts(commitsByHour[,3],start=2001, freq=24)
pdf("report/images/commitsByHour.pdf")
plot(stl(commitsByHour_ts,"periodic"))
title("Temporal analysis of daily activity on the repository")
dev.off()

commitsByCommitterQuery = "SELECT committer_id, COUNT(*) AS commits 
FROM scmlog 
GROUP BY committer_id 
ORDER BY commits"
commitsByCommitter = dbGetQuery(con, commitsByCommitterQuery)

Gini(commitsByCommitter$commits)
pdf("report/images/lorenz.pdf")
Lc(commitsByCommitter$commits, plot=T)
dev.off()

dbDisconnect(con)

# Developers mailing list
con = dbConnect(MySQL(), user=DB_USER, pass=DB_PASS, db=WEBKIT_DEV_MLS_DB)

messageCountQuery="SELECT COUNT(m.message_ID)
FROM messages m"
messageCount=dbGetQuery(con, messageCountQuery)
colnames(messageCount)=c("Email count")
print(xtable(messageCount, caption="Number of messages sent to the mailing list", display=c("d","d")), type="latex", file="report/tables/messageCount.tex")

postersCountQuery="SELECT COUNT(DISTINCT p.people_ID)
FROM messages_people p"
postersCount=dbGetQuery(con, postersCountQuery)
colnames(postersCount)=c("Posters count")
print(xtable(postersCount, caption="Number of people writing to the mailing list", display=c("d","d")), type="latex", file="report/tables/postersCount.tex")

messagesByPostersQuery="SELECT p.username, COUNT(*) as emails 
FROM messages_people mp LEFT JOIN messages m 
	ON (m.message_id = mp.message_id ) 
	LEFT JOIN people p ON (p.people_ID = mp.people_ID ) 
GROUP BY p.username 
ORDER BY emails DESC 
LIMIT 20"
messagesByPosters=dbGetQuery(con, messagesByPostersQuery)
colnames(messagesByPosters)=c("Username", "Email count")
print(xtable(messagesByPosters, caption="Top 20 posters", display=c("d","s","d"), label=c("emails:top20")), type="latex", file="report/tables/messagesByPosters.tex")

messagesByPosters2009Query="SELECT p.username, COUNT(*) as emails 
FROM messages_people mp LEFT JOIN messages m 
	ON (m.message_id = mp.message_id ) 
	LEFT JOIN people p ON (p.people_ID = mp.people_ID )
WHERE YEAR(m.arrival_date) = 2009
GROUP BY p.username 
ORDER BY emails DESC 
LIMIT 20"
messagesByPosters2009=dbGetQuery(con, messagesByPosters2009Query) 
colnames(messagesByPosters2009)=c("Username", "Email count")
print(xtable(messagesByPosters2009, caption="Top 20 posters during 2009", display=c("d","s","d"), label=c("emails:2009top20")), type="latex", file="report/tables/messagesByPosters2009.tex")

emailAddressesByUserQuery="SELECT username, email_address 
FROM people 
WHERE username IN (
	SELECT username 
	FROM people 
	GROUP BY username 
	HAVING COUNT(*) > 1) 
ORDER BY username"
emailAddressesByUser=dbGetQuery(con, emailAddressesByUserQuery)
colnames(emailAddressesByUser)=c("Username", "Email address")
print(xtable(emailAddressesByUser, caption="Email addresses for users with more than one email address", display=c("d","s","s"), label=c("emails:multiple")), type="latex", file="report/tables/emailAddressesByUser.tex")

mailingListLifeSpanQuery="SELECT YEAR(MIN(m.arrival_date)), YEAR(MAX(m.arrival_date)), 
	YEAR(MAX(m.arrival_date))-YEAR(MIN(m.arrival_date))
FROM messages m"
mailingListLifeSpan=dbGetQuery(con, mailingListLifeSpanQuery)
colnames(mailingListLifeSpan)=c("First email", "Last email", "Years")
print(xtable(mailingListLifeSpan, caption="Mailing list lifespan", display=c("d","s","s","d")), type="latex", file="report/tables/mailingListLifeSpan.tex")

messagesByMonthQuery="SELECT YEAR(arrival_date) AS year, MONTH(arrival_date) AS month, 
	COUNT(*) AS count
FROM messages
WHERE YEAR(arrival_date) < 2010
GROUP BY year, month"
messagesByMonth=dbGetQuery(con, messagesByMonthQuery)
messagesByMonth_ts=ts(messagesByMonth[,3],start=c(2005,6), freq=12)
pdf("report/images/messagesByMonth.pdf")
plot(stl(messagesByMonth_ts,"periodic"))
title("Temporal analysis of monthly activity on the mailing list")
dev.off()

messagesByCompanyQuery="SELECT people.domain_name, COUNT(*) as emails
FROM people LEFT JOIN messages_people 
ON (people.people_ID = messages_people.people_ID) 
GROUP BY people.domain_name 
ORDER BY emails DESC 
LIMIT 20"
messagesByCompany=dbGetQuery(con, messagesByCompanyQuery)
colnames(messagesByCompany)=c("Domain name", "Email count")
print(xtable(messagesByCompany, caption="Number of emails sent by company employees", display=c("d","s","d"), label=c("emails:company")), type="latex", file="report/tables/messagesByCompany.tex")


messagesByDayQuery="SELECT YEAR(messages.arrival_date) AS year, DAYOFWEEK(messages.arrival_date) AS day, COUNT(*) AS emails 
FROM messages 
WHERE YEAR(messages.arrival_date) < 2010
GROUP BY year, day"
messagesByDay=dbGetQuery(con, messagesByDayQuery)
messagesByDay_ts=ts(messagesByDay[,3],start=2005, freq=7)
pdf("report/images/messagesByDay.pdf")
plot(stl(messagesByDay_ts,"periodic"))
title("Temporal analysis of weekly activity on the mailing list")
dev.off()

messagesByHourQuery="SELECT YEAR(messages.arrival_date) AS year, HOUR(messages.arrival_date) AS hour, COUNT(*) AS emails 
FROM messages 
WHERE YEAR(messages.arrival_date) < 2010
GROUP BY year, hour"
messagesByHour=dbGetQuery(con, messagesByHourQuery)
messagesByHour_ts=ts(messagesByHour[,3],start=2005, freq=24)
pdf("report/images/messagesByHour.pdf")
plot(stl(messagesByHour_ts,"periodic"))
title("Temporal analysis of daily activity on the mailing list")
dev.off()

dbDisconnect(con)

# Unassigned bugs mailing list
con = dbConnect(MySQL(), user=DB_USER, pass=DB_PASS, db=WEBKIT_BUG_MLS_DB)

unassignedBugsCountQuery="SELECT COUNT(*) 
FROM messages"
unassignedBugsCount=dbGetQuery(con, unassignedBugsCountQuery)
colnames(unassignedBugsCount)=c("Unassigned bugs count")
print(xtable(unassignedBugsCount, caption="Total number of unassigned bugs", display=c("d","d")), type="latex", file="report/tables/unassignedBugsCount.tex")

unassignedBugsByMonthQuery="SELECT YEAR(arrival_date) AS year, MONTH(arrival_date) AS month, 
COUNT(message_id) as bugs
FROM messages 
GROUP BY year, month
UNION
SELECT 2007 AS year, 1 AS month, 0 AS bugs
ORDER BY year, month"
unassignedBugsByMonth=dbGetQuery(con, unassignedBugsByMonthQuery)
unassignedBugsByMonth_ts=ts(unassignedBugsByMonth[,3],start=c(2005,12), freq=12)
pdf("report/images/unassignedBugsByMonth.pdf")
plot(stl(unassignedBugsByMonth_ts,"periodic"))
title("Temporal analysis of unassigned bugs")
dev.off()

dbDisconnect(con)

test = read.table("sloccount_summary.txt",header=T, stringsAsFactors=F)
c1 = c(test[,1])
c2 = c(test[,2])
c3 = c(test[,3])
c1 = paste(c1,c3)
pdf("report/images/sloc.pdf")
pie(c2,labels=c1,col=rainbow(length(c1)),main="SLOC by programming languages")
dev.off()
