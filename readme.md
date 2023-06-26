# pj-craft

Beautiful Crafting System for ESX and QBcore

Originaly based on [Codem_Craft](https://github.com/LucidB1/codem-craft)

[Preview](https://streamable.com/ii9wao)
 
```sql
 CREATE TABLE IF NOT EXISTS `pj_craft` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) DEFAULT NULL,
    `itemName` varchar(50) DEFAULT NULL,
    `craftTime` varchar(50) DEFAULT NULL,
    `itemLabel` varchar(50) DEFAULT NULL,
    `craftStartTime` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4;

```
