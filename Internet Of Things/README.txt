
un Hub IoT complet qui simule 5 capteurs de température : 

[5 Devices ioT] → [Azure IoT Hub] → [Azure Functions/Stream Analytics] → [Web App Dashboard]
                                                                       → [azure blob storage]
                                                                       → [DB cosmosDB ou SQL server]
                                                                       → [Web App Dashboard]

En pratique, un capteur est un dispositif ioT qui mesure la températeure 
             le capteur se connecte avec WIFI/Bleutooth/Zigbee à une passerelle ioT
             la passerelle ioT se connecte à azure ioTHub et envoie les messages des devices via  MQTT ou HTTPS
             stream analytics/azure functions se connecte pour stocker les données sur une destination

Pour simuler : 

1-Script Python envoie des données de 5 capteurs à IoT Hub
2-Azure Function ou stream analytics qui traite les données de l'IoT Hub (peut envoyer un mail d'alerte aussi)
4-API REST sur la fonction qui expose les données
5-Static Web App affiche les données en temps réel à partir de l'API

 [5 Devices ioT] → [Azure IoT Hub] → [Azure Functions] → [Web App static Dashboard qui pointe sur l'API de la fonction]             
     
======================================
IOT HUB 
======================================

. Voici ce qui est inclus :
🎯 Fonctionnalités
Dashboard en temps réel avec :

5 devices IoT qui envoient des températures toutes les 2 secondes
Températures aléatoires entre 10°C et 35°C avec variations réalistes
Statut de connexion (online/offline) simulé
Graphique historique des températures
Statistiques globales (devices actifs, température moyenne, messages reçus)

Caractéristiques de chaque device :

Identifiant unique (DEV-001 à DEV-005)
Nom personnalisé (Salon, Cuisine, Chambre, Bureau, Garage)
Code couleur selon la température
Indicateur de statut en temps réel
Horodatage de la dernière mise à jour

📊 Visualisation

Graphique multi-lignes : Suivi en temps réel de tous les capteurs
Cartes de statistiques : Vue d'ensemble instantanée
Cards individuelles : Détails de chaque device
Design moderne : Interface glassmorphism avec animations

=====================================
Script python : 
=====================================

 un script Python complet qui simule 5 devices IoT envoyant des températures à un hub central.
🔧 Fonctionnalités du script
Classes principales :

IoTDevice : Simule un capteur de température

Génère des températures aléatoires avec variations réalistes
Simule des connexions/déconnexions (5% de chance)
Produit des messages JSON horodatés

IoTHub : Hub central qui reçoit les données

Enregistre les devices
Reçoit et traite les données en temps réel
Calcule les statistiques (devices actifs, messages reçus, température moyenne)

Caractéristiques :

✅ 5 devices avec des températures de base différentes
✅ Multi-threading : chaque device envoie des données toutes les 2 secondes
✅ Affichage en temps réel avec icônes colorées (🟢/🔴)
✅ Statistiques affichées toutes les 10 secondes
✅ Format JSON pour les données
✅ Gestion propre de l'arrêt (Ctrl+C)
