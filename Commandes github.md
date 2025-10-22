
git --version     # Doit afficher la version installée


git config --global user.name "Soufiane Talibi"


git config --global user.email "Soufiane.talibi@gmail.com"




1------create a new repository on the command line : 


echo "# WIKI" >> README.md


git init


git add README.md


git commit -m "first commit"


git branch -M main


git remote add origin https://github.com/soufianetalibi/WIKI.git


git push -u origin main


1-----Push an existing repository from the command line


git remote -v


git remote add origin https://github.com/soufianetalibi/WIKI.git


git add .  


git commit -m "Mise à jour"


git branch -M main


git push -u origin main

==================================================================================

CI/CD : build, test, deploy

Docker souvent utilisé dans la CI/CD, facilite de déploiement

Serverless : exécution sans gestion d'infra

IaC : Créer une plateforme à partir du code

GitHub : site qui permet de créer des dépôts pour stocker le développement effectué en local pour : 
              -partager et travailler en équipe (push et pull entre développeurs)
              -pousser les MAJ vers DEV, TEST, PPRD PROD (principe de branches)
              -transférer automatiquement le livrable vers un serveur on promise, cloud … (principe de workflows)

Repository, push, pull, Clone , Fork, Commit , branches, merge, workflows, Runner

exemple CI/CD: 

--je peux créer un repo avec deux branches DEV et PROD, développer sur la branche DEV puis à la fin transférer vers la branche PROD .

1-travailler sur la branche DEV avec des commit 1 2 3 4 ... à chaque fois jusqu'à la fin de la partie DEV : DEV OK 

2-Récupérer toute la MAJ de la branche DEV en local : git branch , git checkout DEV , git pull origin DEV

3-transférer la version DEV vers PROD : git checkout PROD, git pull origin PROD, git merge DEV  

git branch : afficher toutes les branches avec * sur la branche active
git pull : récupérer en local la version à jour github
git merge : effecte le transfert


workflow GitHub Actions qui construit une image Docker et la pousse sur Docker Hub à chaque push : build + push sur Docker Hub
workflow GitHub Actions qui déploie une application nodeJS sur un VPS via SSH
workflow GitHub Actions qui déploie automatiquement une application Node.js sur Azure App Service
workflow GitHub Actions qui construit et déploie une application statique (par exemple un site React) sur GitHub Pages (serveur web statique sur github)


====================================================================================================================================
Exemple de pipeline complet 
====================================================================================================================================

Tu développes une application web Node.js avec Docker. Tu souhaites automatiser :
 La vérification de la qualité du code (lint, tests)
 La construction d’une image Docker
 Le déploiement automatique sur un serveur de test (VPS)
 Le déploiement automatique sur production après validation

==> Workflow complet possible : 

1. A chaque push sur la branche develop

Exécuter les tests unitaires

Vérifier la qualité du code (ESLint, Prettier)

Construire une image Docker taggée develop

Pusher cette image sur Docker Hub

Déployer automatiquement l’image develop sur un serveur de test (VPS)

2. A chaque pull request vers main

Refaire les tests et vérifications

Valider que la PR passe toutes les étapes

Permettre la revue et la validation par l’équipe

3. Après fusion dans la branche main

Construire l’image Docker taggée latest ou versionnée

Pusher cette image Docker sur Docker Hub

Déployer automatiquement sur le serveur de production (VPS ou cloud)

Notifier l’équipe (Slack, email, etc.)
