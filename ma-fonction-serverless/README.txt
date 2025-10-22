
 Cette fonction Azure Serverless (HTTP Trigger) permet d’ajouter un utilisateur dans une base de données SQL Server (hébergée sur Azure)

 prérequis : 

DB_SERVER	monserveursql.database.windows.net	
DB_DATABASE	SQLDB	           Nom de ta base de données
DB_USERNAME	soufiane	   Ton utilisateur SQL
DB_PASSWORD	XXXXXXXXXXXXXX	   Ton mot de passe SQL

 -avoir un environnement python 3.12 en local
 -avoir le dossier "ma-fonction-serverless"
 -avoir une BD SQL ayant la table suivante : 
    CREATE TABLE Utilisateurs (
    Id INT IDENTITY(1,1) PRIMARY KEY,       -- Identifiant auto-incrémenté
    Nom NVARCHAR(100) NOT NULL,             -- Nom de l'utilisateur
    Email NVARCHAR(255) NOT NULL UNIQUE,    -- Adresse email unique
    DateCreation DATETIME DEFAULT GETDATE() -- Date automatique d'insertion
    );
  -

Créer une fonction "MaFonctionSQL" serverless : 

az functionapp create --resource-group AgeFunctionRG --consumption-plan-location francecentral --runtime python --functions-version 4 --name MaFonctionSQL --storage-account mystoragefun1234 --os-type Linux --runtime-version 3.12

-Push de la fonction : 

cd ma-fonction-serverless

func azure functionapp publish MaFonctionSQL

-Ajouter les variables d'environnement sur azure : (pour se connecter à la BD)
      az functionapp config appsettings set \
  --name MaFonctionSQL \
  --resource-group AgeFunctionRG \
  --settings \
  DB_SERVER="monserveur.database.windows.net" \
  DB_DATABASE="MaBaseSQL" \
  DB_USERNAME="adminsql@monserveur" \
  DB_PASSWORD="MonMotDePasseUltraSecret123!"

Vérifier si les variables sont définies sur la fonction : 
 az functionapp config appsettings list --name MaFonctionSQL --resource-group AgeFunctionRG

