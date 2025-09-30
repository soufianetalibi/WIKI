const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware pour parser le JSON
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Base de données simulée en mémoire
let visiteurs = [];
let compteurVisites = 0;

// Page d'accueil avec formulaire interactif
app.get('/', (req, res) => {
  compteurVisites++;
  res.send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Mon App Docker</title>
      <style>
        body {
          margin: 0;
          padding: 0;
          font-family: Arial, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background: white;
          padding: 40px;
          border-radius: 20px;
          box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 {
          color: #667eea;
          text-align: center;
          margin-bottom: 10px;
        }
        .stats {
          background: #f0f0f0;
          padding: 15px;
          border-radius: 10px;
          margin: 20px 0;
          text-align: center;
        }
        .form-group {
          margin-bottom: 15px;
        }
        label {
          display: block;
          margin-bottom: 5px;
          color: #333;
          font-weight: bold;
        }
        input, textarea {
          width: 100%;
          padding: 10px;
          border: 2px solid #ddd;
          border-radius: 5px;
          font-size: 14px;
          box-sizing: border-box;
        }
        button {
          width: 100%;
          padding: 12px;
          background: #667eea;
          color: white;
          border: none;
          border-radius: 5px;
          font-size: 16px;
          cursor: pointer;
          font-weight: bold;
        }
        button:hover {
          background: #5568d3;
        }
        .visitors {
          margin-top: 30px;
        }
        .visitor-card {
          background: #f9f9f9;
          padding: 15px;
          border-radius: 8px;
          margin-bottom: 10px;
          border-left: 4px solid #667eea;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🐳 Bienvenue !</h1>
        <p style="text-align: center; color: #666;">Application Node.js dockerisée avec traitement backend</p>
        
        <div class="stats">
          <strong>📊 Statistiques du serveur</strong><br>
          Nombre de visites : <strong>${compteurVisites}</strong><br>
          Visiteurs enregistrés : <strong>${visiteurs.length}</strong>
        </div>

        <h3>📝 Laissez un message</h3>
        <form action="/ajouter-visiteur" method="POST">
          <div class="form-group">
            <label>Votre nom :</label>
            <input type="text" name="nom" required>
          </div>
          <div class="form-group">
            <label>Votre message :</label>
            <textarea name="message" rows="3" required></textarea>
          </div>
          <button type="submit">Envoyer 🚀</button>
        </form>

        <div class="visitors">
          <h3>💬 Messages des visiteurs</h3>
          <div id="messages">
            ${visiteurs.length === 0 ? 
              '<p style="text-align: center; color: #999;">Aucun message pour le moment...</p>' : 
              visiteurs.map(v => `
                <div class="visitor-card">
                  <strong>${v.nom}</strong> - <small>${v.date}</small><br>
                  <p style="margin: 10px 0 0 0;">${v.message}</p>
                </div>
              `).join('')
            }
          </div>
        </div>
      </div>
    </body>
    </html>
  `);
});

// Traitement backend : Ajouter un visiteur
app.post('/ajouter-visiteur', (req, res) => {
  const { nom, message } = req.body;
  
  // Validation des données
  if (!nom || !message) {
    return res.status(400).send('Nom et message requis');
  }

  // Traitement : nettoyage et formatage
  const visiteur = {
    id: Date.now(),
    nom: nom.trim(),
    message: message.trim(),
    date: new Date().toLocaleString('fr-FR'),
    longueurMessage: message.length
  };

  // Stockage en base de données (simulée)
  visiteurs.unshift(visiteur); // Ajoute au début
  
  // Limite à 10 messages
  if (visiteurs.length > 10) {
    visiteurs = visiteurs.slice(0, 10);
  }

  // Redirection vers la page d'accueil
  res.redirect('/');
});

// API : Obtenir les statistiques (traitement et calculs)
app.get('/api/stats', (req, res) => {
  // Calculs côté backend
  const stats = {
    totalVisites: compteurVisites,
    totalVisiteurs: visiteurs.length,
    moyenneLongueurMessages: visiteurs.length > 0 
      ? Math.round(visiteurs.reduce((acc, v) => acc + v.longueurMessage, 0) / visiteurs.length)
      : 0,
    dernierMessage: visiteurs[0] || null,
    timestamp: new Date().toISOString()
  };
  
  res.json(stats);
});

// API : Obtenir tous les visiteurs
app.get('/api/visiteurs', (req, res) => {
  res.json({
    total: visiteurs.length,
    visiteurs: visiteurs
  });
});

// API : Rechercher des visiteurs par nom (traitement de recherche)
app.get('/api/rechercher', (req, res) => {
  const query = req.query.q;
  
  if (!query) {
    return res.status(400).json({ error: 'Paramètre q requis' });
  }

  // Traitement : filtrage et recherche
  const resultats = visiteurs.filter(v => 
    v.nom.toLowerCase().includes(query.toLowerCase()) ||
    v.message.toLowerCase().includes(query.toLowerCase())
  );

  res.json({
    query: query,
    nombreResultats: resultats.length,
    resultats: resultats
  });
});

app.listen(PORT, () => {
  console.log(`✅ Serveur démarré sur le port ${PORT}`);
  console.log(`🌐 Ouvrez http://localhost:${PORT} dans votre navigateur`);
  console.log(`📊 API stats: http://localhost:${PORT}/api/stats`);
});