
App "mon-app-visiteurs" dockerisée avec le backend Node.js qui permet de laisser un message.

1. Livre d'or / Système de messages
2. Compteur de visites 📊
3. Affichage des messages
4. API REST : 
      /api/stats → Statistiques (nombre de visites, moyenne des messages, etc.)
      /api/visiteurs → Liste de tous les visiteurs
      /api/rechercher?q=mot → Rechercher dans les messages

📁 Structure de votre projet

Créez un dossier et ajoutez ces fichiers :

mon-app-docker/
├── app.js          (déjà créé dans les artifacts)
├── package.json    (déjà créé dans les artifacts)
├── Dockerfile      (déjà créé dans les artifacts)
└── .dockerignore   (déjà créé dans les artifacts)

🚀 Commandes pour lancer l'application

Étape 1 : Construire l'image Docker

cd mon-app-docker
docker build -t mon-app-visiteurs .

Étape 2 : Lancer le conteneur

docker run -d -p 3000:3000 --name app-visiteurs mon-app-visiteurs

Étape 3 : Vérifier que ça fonctionne

# Voir les logs
docker logs app-visiteurs
# Vérifier que le conteneur tourne
docker ps

Étape 4 : Ouvrir dans le navigateur
Allez sur : http://localhost:3000

🐳 Commandes utiles

# Arrêter le conteneur
docker stop app-visiteurs

# Redémarrer le conteneur
docker start app-visiteurs

# Supprimer le conteneur
docker rm app-visiteurs

# Supprimer l'image
docker rmi mon-app-visiteurs

# Voir les logs en temps réel
docker logs -f app-visiteurs

# Entrer dans le conteneur (pour déboguer)
docker exec -it app-visiteurs sh

📤 Pour publier sur Docker Hub

# 1. Se connecter à Docker Hub
docker login

# 2. Taguer l'image avec votre username Docker Hub "souflouf89"
docker tag mon-app-visiteurs souflouf89/mon-app-visiteurs:latest

# 3. Pousser vers Docker Hub
docker push souflouf89/mon-app-visiteurs:latest

# 4. Quelqu'un d'autre peut maintenant l'utiliser avec :
docker pull souflouf89/mon-app-visiteurs:latest
docker run -p 3000:3000 souflouf89/mon-app-visiteurs:latest

🎯 Version simplifiée (tout en une commande)

# Construction + Lancement en une seule fois
docker build -t mon-app-visiteurs . && docker run -d -p 3000:3000 --name app-visiteurs mon-app-visiteurs

✅ Vérification finale

Une fois lancé, testez :

Page web : http://localhost:3000
Stats API : http://localhost:3000/api/stats
Visiteurs : http://localhost:3000/api/visiteurs

Note importante : Les données (visiteurs, messages) sont stockées en mémoire, donc elles seront perdues quand vous arrêtez le conteneur. Pour persister les données, il faudrait ajouter une vraie base de données (MongoDB, PostgreSQL, etc.).

====

  Pour déployer depuis dockerHub vers azure ACI : 
  
  az group create --name RG-app-ACI-visiteurs --location francecentral
  az container create --resource-group RG-app-ACI-visiteurs --name mon-app-visiteurs --image souflouf89/mon-app-visiteurs:latest --cpu 1 --memory 1 --restart-policy Always --ports 3000 --os-type Linux --dns-name-label mon-app-visiteurs-dns --location francecentral

  puis voir sur l'URL : http://mon-app-visiteurs-dns.francecentral.azurecontainer.io:3000


