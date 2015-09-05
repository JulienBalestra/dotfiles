Aide mémoire MongoDB

#############################
# Commandes bash
#############################

# version serveur mongo
mongod --version

# lancement process serveur
mongod --dbpath /data --fork --logpath /log

# lancement avec choix du storage engine
mongod --storageEngine mmapv1
mongod --storageEngine wiredTiger

# lancement mongo shell
mongo

# import
mongoimport --stopOnError --db pcat --collection products < products.json

# stats
mongostat
mongotop

#############################
# Commandes mongo shell
#############################

# afficher la base en cours d'utilisation
> db
test

# changer de base courante
> use week1
switched to db week1

# afficher liste des bases
> show dbs
local	0.03125GB
pcat	0.0625GB
performance	0.0625GB

# afficher les collections de la base active
> show collections
products
products_bak
system.indexes

# requete
> db.products.find()
> db.products.find().pretty()

# tri
> db.products.find().sort({"_id":1})

# curseur
> db.products.find().skip(3).limit(2)

> var query = db.products.find()
> query

# insertion d'un document
> db.products.insert( { "a" : 1 } )

# mise à jour d'un document
> obj = { "_id" : "ac7", "available" : false, "brand" : "ACME" }
> db.products.update( {"_id" : "ac7" }, obj )
ou
> db.products.save(obj)

# mise à jour partielle d'un document
> db.products.update( {"_id" : 2}, { "$set" : { "a" : 1 } } )

# mise à jour de plusieurs documents
> db.products.update( {"type" : "ac7" }, { "$set" : { "a" : 1 } }, false, true )

# mise à jour upserts (update or insert if not present)
> db.products.update( {"type" : "ac7" }, { "$set" : { "a" : 1 } }, true )

# suppression document
> db.products.remove( {"_id" : "ac7" } )

# batchs
> var bulk = db.items.initializeUnorderedBulkOp()
ou
> var bulk = db.items.initializeOrderedBulkOp()

> db.items.find()
> bulk.insert( {"item" : 1 } )
> bulk.insert( {"item" : 2 } )
> bulk.execute()

# commandes serveurs
> db.isMaster()
> db.serverStatus()
> db.getLastError()
> db.currentOp()
> db.killOp()

# commandes bases
> db.dropDatabase()
> db.repairDatabase()
> db.cloneDatabase()
> db.copyDatabase()
> db.stats()

# commandes collection
> db.products.stats()
> db.products.drop()

# commandes index
> db.product.getIndexes()
> db.product.createIndex()
> db.product.ensureIndex()
> db.product.dropIndex()

# requete avec explain
> db.products.find().explain()
> db.products.find().explain("executionStats")
> db.products.find().explain("allPlansExecution")

# modifier niveau de log
> db.setProfilingLevel()

# consultation logs
> db.system.profile.find().pretty()

#############################
# créer un replicat set sur la meme machine
#############################

cd /data
mkdir 1 2 3
mongod --port 27001 --replSet abc --dbpath /data/1 --logpath /data/log.1 --logappend --oplogSize 50 --smallfiles --fork --journal
mongod --port 27002 --replSet abc --dbpath /data/2 --logpath /data/log.2 --logappend --oplogSize 50 --smallfiles --fork --journal
mongod --port 27003 --replSet abc --dbpath /data/3 --logpath /data/log.3 --logappend --oplogSize 50 --smallfiles --fork --journal

mongo --port 27001 --host localhost
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001" },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003" }
	]
}
> rs.initiate(cfg)
{
	"info" : "Config now saved locally.  Should come online in about a minute.",
	"ok" : 1
}
> rs.status()
> rs.help()

# permettre les lectures sur les serveurs secondaires
> rs.slaveOk()

# Options  :
# définir un serveur "arbitre"
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001" },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003", arbiterOnly:"true" }
	]
}

# définir la priorité pour devenir primary
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001", priority:2 },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003", priority:0 }
	]
}
-> si 0, jamais primary

# cacher un serveur des clients
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001" },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003", hidden: "true" }
	]
}

# retard de réplication
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001" },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003", slaveDelay: 8*3600 }
	]
}
-> en secondes (options hidden: "true" par défaut)

# modifier le poids du vote
> cfg = { 
	_id : "abc",
	members : [
		{ _id : 0, host : "localhost:27001" },
		{ _id : 1, host : "localhost:27002" },
		{ _id : 2, host : "localhost:27003", votes: 2 }
	]
}

# "Write concern" : définir la méthode d'acquitement lors de requetes
> db.foo.insert({"toto" : "titi"})
> db.getLastError({ "w" : "majority", "wtimeout" : 8000 })
