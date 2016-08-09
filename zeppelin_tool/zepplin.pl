#!/usr/bin/perl
# store the contents of an audit log into Hive.
# Each audit log entry is inserted as a row into a table named 'provided'.
#
# Usage:
#    ./audit_log_zepplin.pl hdfs-audit.log table_name
# Sarun Singla [2016]

use strict;
use warnings;

#generating the write dataset to be input into hive table.
my $audit_log=$ARGV[0];
my $table_name = $ARGV[1];

if(!$audit_log && !$table_name)
{
    print "Please enter run script  followed by audit file location and a table name\n";
}
elsif(!$table_name)
{
    print "Please also provide a table name\n";
}

else
{
    print "HDFS Audit logs you passed : $audit_log\n";
    print "We are doing magic on the data now\n";
    my $file1 = `sed 's/\t/ /g' $audit_log >/home/hive/replace_tab_space.log`;
    my $file2 = `sed 's/\ /,/g2' /home/hive/replace_tab_space.log >/home/hive/file_for_hive`;

#creating a hive table
    print "Creating a hive table for the logs to live in, table name is as you provided:\n";
    print "$table_name\n";
    my $table= "CREATE TABLE $table_name(ts timestamp,time_ms String,name_info string,fs_namesystem string,allowed string,username string,auth_details string,user_ip string,command_executed string,src_executed_on string,dst string,perm string,proto string) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';";
    print "Query Executing to create table:\n";
    print "$table\n";
   # my $create_table =`hive -e \"$table\"`;
     my $create_table =`hive -e \"$table\"`;
## Add data to hive table..
    print "Adding the data to the table create.\n";
    my $hive_file_location = "/home/hive/file_for_hive";
    my $loading_data = "hive -e \"load data local inpath '/home/hive/file_for_hive' into table $table_name ;\"";
    print "Query executing to load data to hive table:\n";
    print "$loading_data\n";
    my $execute = `$loading_data`;
    my $deleting_not_required_files = `rm /home/hive/replace_tab_space.log /home/hive/file_for_hive`;
}
