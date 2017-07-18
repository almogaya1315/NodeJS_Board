
-- 1) Show user’s news feed (user's friends posts)

with WritersDetails as
(select distinct u.FirstName, u.LastName, u.UserId
from users u join Posts p on u.UserId = p.WriterId)

select wd.FirstName + ' ' + wd.LastName FriendName, p.Name PostName, p.PostDate
from Users u join Friends f on u.UserId = f.UserId
		     join Posts p on p.WriterId = f.FriendId
			 join WritersDetails wd on wd.UserId = f.FriendId
where u.UserId = 14 
and year(p.PostDate) >= 2014


-- 2) Show users in my groups

with GroupsIbelong as
(select u.UserId, m.GroupId
from Users u join Members m on u.UserId = m.UserId
where u.UserId = 11),

AllMembersInMyGroups as
(select m.UserId, m.GroupId
from Members m join GroupsIbelong gb on m.GroupId = gb.GroupId
where m.UserId != 11
group by m.UserId, m.GroupId),

MembersDetails as
(select distinct u.FirstName, u.LastName, u.UserId
from users u join Members m on u.UserId = m.UserId),

GroupDetails as
(select g.Title, g.GroupId
from Groups g)

select md.FirstName + ' ' + md.LastName MemberName, gd.Title
from AllMembersInMyGroups mg join MembersDetails md on mg.UserId = md.UserId
							 join GroupDetails gd on mg.GroupId = gd.GroupId
order by gd.Title


-- 3) What are the highlight posts?

select p.PostId, p.Name, count(l.UserId) likes
from Posts p join Likers l on p.PostId = l.PostId
group by p.PostId, p.Name
order by likes desc


-- 4) Users I may know (but are not my friends)

with FriendsDetails as
(select distinct u.FirstName, u.LastName, u.UserId
from Users u join Friends f on u.UserId = f.FriendId),

MyFriends as
(select u.UserId, f.FriendId
from Users u join Friends f on u.UserId = f.UserId
where u.UserId = 2),

MyFriendFriends as
(select mf.FriendId MyFriendId, fd.FirstName, fd.LastName, f.FriendId
from MyFriends mf join Friends f on mf.FriendId = f.UserId
				  join FriendsDetails fd on fd.UserId = mf.FriendId)

select ff.FirstName + ' ' + ff.LastName MyFriend, fd.FirstName + ' ' + fd.LastName HisFriend
from MyFriendFriends ff join FriendsDetails fd on ff.FriendId = fd.UserId
where fd.UserId != 2 and fd.UserId != ff.MyFriendId
order by MyFriend


-- 5) Best friend (most msgs and more then 5 likes)

with FriendsDetails as
(select distinct u.FirstName, u.LastName, u.UserId
from Users u join Friends f on u.UserId = f.FriendId),

UsersFriendsMaxMsgs as
(select u.UserId, u.FirstName UserFirst, u.LastName UserLast, fd.UserId FriendId, fd.FirstName FriendFirst, fd.LastName FriendLast, count(m.MessageId) MsgsFromFriend
from Users u join Messages m on u.UserId = m.ReceiverId
		     join Friends f on m.SenderId = f.FriendId and m.ReceiverId = f.UserId
			 join FriendsDetails fd on fd.UserId = m.SenderId
group by u.UserId, u.FirstName, u.LastName, fd.UserId, fd.FirstName, fd.LastName), 

UsersFriendsFiveLikes as
(select  u.UserId, F.FriendId, count(l.UserId) Likes
from Users u join Posts p on u.UserId = p.WriterId
			 join Likers l on p.PostId = l.PostId
			 join Friends f on l.UserId = f.FriendId
group by u.UserId, F.FriendId
having count(l.UserId) > 4)

select mm.UserFirst + ' ' + mm.UserLast UserName, mm.FriendFirst + ' ' + mm.FriendLast FriendName, max(mm.MsgsFromFriend) maxMsg, fl.Likes
from UsersFriendsFiveLikes fl join UsersFriendsMaxMsgs mm 
on fl.FriendId = mm.FriendId and fl.UserId = mm.UserId
group by mm.UserFirst, mm.UserLast, mm.FriendFirst, mm.FriendLast, fl.Likes
go


-- 6) Portrait (pictures which only I tagged on) 

with PicsITagged as
(select u.FirstName + ' ' + u.LastName UserName, p.Name Picture, p.PictureId
from Users u join Taggers t on u.UserId = t.UserId
			 join Pictures p on p.PictureId = t.PictureId
where u.UserId = 10)

select t.PictureId, pt.Picture
from PicsITagged pt join Taggers t on pt.PictureId = t.PictureId
group by t.PictureId, pt.Picture 
having count(t.UserId) = 1
	

-- 7) Administrator Statistics (all posts through the years)

with AllPosts as
(select year(PostDate) PostYear, count(PostId) PostCount
from Posts
group by year(PostDate)),

AllAlbums as
(select year(PostDate) AlbumYear, count(p.PostId) AlbumCount
from Albums a join Posts p on a.PostId = p.PostId
group by year(PostDate)),

AllPictures as
(select year(PostDate) PictureYear, count(p.PostId) PictureCount
from Pictures pc join Posts p on pc.PostId = p.WriterId
group by year(PostDate))

select PostYear Year, PostCount, AlbumCount, PictureCount
from AllPosts ap join AllAlbums aa on ap.PostYear = aa.AlbumYear
				 join AllPictures apc on ap.PostYear = apc.PictureYear		
				 

-- 8) We like our picture (pictures that were taged and liked)

with LikedPosts as
(select p.PostId, p.Name PostName, count(l.UserId) Likes
from Users u join Likers l on u.UserId = l.UserId
			 join Posts p on p.PostId = l.PostId
group by p.PostId, p.Name),

TaggedPictures as
(select p.PostId, pc.PictureId, p.Name PictureName, count(t.UserId) Tags 
from Users u join Taggers t on u.UserId = t.UserId
			 join Pictures pc on t.PictureId = pc.PictureId
			 join Posts p on p.PostId = pc.PostId
group by p.PostId, pc.PictureId, p.Name)

select distinct tp.PictureName, tp.Tags, lp.Likes
from LikedPosts lp join TaggedPictures tp on lp.PostId = tp.PostId

	   