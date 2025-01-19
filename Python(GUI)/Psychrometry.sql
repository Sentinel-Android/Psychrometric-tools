create database psychrometry;
use psychrometry;
create table results(id int primary key, DB float, SH float, RH float, ET float, WB float, SV float, PV float, DP float, PT float, Remarks varchar(30), TimeStamp timestamp default CURRENT_TIMESTAMP);