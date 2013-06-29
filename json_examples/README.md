-paigeadele 2013 paigeadele@gmail.com



Block everything by default, allow whats needed on a case by case basis... the automatic way

you need to add this one, set them to be the same if you only have one int and define your rules accordingly..

"network_interfaces": {"public":"eth0","private":"eth1"}



iptables rules are defined like this:


"iptables": {

"role":[

#one-to-many, many-to-one, all depends on roles in a node's expanded run_list (see recipe)
# the syntax is: <dest>, <portOrRange>, <network_interface(public or private)>, <source>, <protocol>

["Servers","30000:65534","private","Base","tcp"],  # <--- nagios!!!
["Servers","873","private","AppSrv","both"],
["Servers","873","private","WebMainSrv","both"],
["Servers","873","private","MySQL_Main_Master","both"],
["Servers","873","private","LoadBalancer","both"],
["AppSrv","80","private","LoadBalancer","tcp"],
["WebMainSrv","80","private","LoadBalancer","tcp"],
["Couchbase_Server","8091","private","Servers","tcp"],
["Couchbase_Server","11211","private","AppSrv","tcp"],
["Couchbase_Server","11211","private","WebMainSrv","tcp"],
["Couchbase_Server","11210","private","Couchbase_Server","tcp"],
["Couchbase_Server","11210","private","AppSrv","tcp"],
["Couchbase_Server","11210","private","WebMainSrv","tcp"],
["Couchbase_Server","11209","private","Couchbase_Server","tcp"],
["Couchbase_Server","21100:21199","private","Couchbase_Server","tcp"],
["MySQL_Main_Master","3306","private","AppSrv","tcp"],
["MySQL_Main_Master","3306","private","Servers","tcp"],
["Base","22","private","Servers","tcp"],
["Security_Server","22","private","Base","tcp"],
["Base","22","private","Security_Server","tcp"],
["DNS_Server","53","private","Base","both"],
["Security_Server","3000","private","Servers","both"],
["Security_Server","80","private","Servers","both"],
["AppSrv","22002","private","Servers","both"],
["WebMainSrv","22002","private","Servers","both"],
["DaemonMaster_Server","22002","private","Servers","both"],
["LoadBalancer","22002","private","Servers","tcp"],
["Base","5666","private","Servers","tcp"],                # <--- nagios!!!
["Bunny_Server","15672","private","Servers","both"],
["Base","10/second","private","Servers","icmp"],
["Servers","30000:65534","private","Base","tcp"],
["Base","4949","private","Security_Server","tcp"]

], #end of role-to-role relationships

#and the static roles (source network/addresses not managed by chef)

"static":[

["LoadBalancer","80","public","any","both"],
["LoadBalancer","443","public","any","both"], #the attack surface on wan, perhaps less so thanks to cloudflare prem

["Servers","4000","private","any","both"], # the only attack surface on rackspace servicenet
["Servers","22","public","wouldnt.you.like.to.know.com","tcp"],
["Base","22","public","10.181.46.2","tcp"],
["Servers","22","public","paigeadele.selfip.net","tcp"],
["DNSSlave_Server","53","public","any","both"],
["DNSSlave_Server","53","private","any","both"],
["DNS_Server","53","public","any","both"]],

"apply_new_rules":"true"} # enables or disables provisioning

Other notes:

*** And this is an important one, You might notice that there's a lot of things allowed from Servers, because Servers
is where I currently manage all of these servers from. It is for all intents and purposes my chef server role, from
where I currently run knife (thats changing, to a management server because of the excess of ports used by erchef.)
I don't allow ssh to any of my VMs except from chef server, and on Rackspace's servicenet.
I don't allow ssh to the chef server from anywhere except my home and work address. So, I effectively eliminated
the need for anything like fail2ban on all of my servers.


TODO:

I want to add OUTPUT rules that reflect the INPUT allow rules (the inverse of the INPUT rules basically, plus static
rules allowing VM's to connect to hosts like the apt servers..... you should see my rsync cookbook because OUTPUT
exclusion would go hand-in-hand with it.


Final thoughts:

I'm so glad I wrote this, it's made my life sooooo much easier. I hope you guys can find it useful in the opscode
community library. Please let me know what you need for me to do I'll be happy to make the adjustments.
